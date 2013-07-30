//
//  EVChangePasswordViewController.m
//  Evenly
//
//  Created by Justin Brunet on 7/16/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVChangePasswordViewController.h"
#import "EVEditLabelCell.h"

#define BUTTON_BUFFER 10

@interface EVChangePasswordViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) NSString *previousPassword;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *confirmPassword;

@property (nonatomic, strong) NSMutableArray *cells;

@end

@implementation EVChangePasswordViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Change Password";
        self.cells = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadTableView];
    [self loadFooterView];
    [self loadSaveButton];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(findAndResignFirstResponder)]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = [self tableViewFrame];
    self.footerView.frame = [self footerViewFrame];
    self.saveButton.frame = [self saveButtonFrame];
}

#pragma mark - View Loading

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:[self tableViewFrame] style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    [self.tableView registerClass:[EVEditLabelCell class] forCellReuseIdentifier:@"editLabelCell"];
    [self.view addSubview:self.tableView];
}

- (void)loadFooterView {
    self.footerView = [UIView new];
    self.footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = self.footerView;
}

- (void)loadSaveButton {
    self.saveButton = [UIButton new];
    [self.saveButton setBackgroundImage:[EVImages blueButtonBackground] forState:UIControlStateNormal];
    [self.saveButton setBackgroundImage:[EVImages blueButtonBackgroundPress] forState:UIControlStateHighlighted];
    [self.saveButton addTarget:self action:@selector(saveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveButton setTitleEdgeInsets:UIEdgeInsetsMake(1, 0, 0, 0)];
    self.saveButton.titleLabel.font = [EVFont defaultButtonFont];
    [self.footerView addSubview:self.saveButton];
    self.saveButton.enabled = NO;
}

#pragma mark - TableView DataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [EVEditLabelCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVEditLabelCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"editLabelCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        [cell setTitle:@"Old Password" placeholder:@"Previous password"];
        cell.textField.secureTextEntry = YES;
        cell.textField.returnKeyType = UIReturnKeyNext;
        [cell.textField.rac_textSignal subscribeNext:^(NSString *text) {
            self.previousPassword = text;
        }];
    } else if (indexPath.row == 1) {
        [cell setTitle:@"New Password" placeholder:@"At least 8 characters"];
        cell.textField.secureTextEntry = YES;
        cell.textField.returnKeyType = UIReturnKeyNext;
        [cell.textField.rac_textSignal subscribeNext:^(NSString *text) {
            self.password = text;
            [self validatePasswords];
        }];
        EVEditLabelCell *previousCell = [self.cells objectAtIndex:0];
        previousCell.textField.next = cell.textField;
    } else {
        [cell setTitle:@"Confirm" placeholder:@"Same as above"];
        cell.textField.secureTextEntry = YES;
        cell.textField.returnKeyType = UIReturnKeyDone;
        [cell.textField.rac_textSignal subscribeNext:^(NSString *text) {
            self.confirmPassword = text;
            [self validatePasswords];
        }];
        EVEditLabelCell *previousCell = [self.cells objectAtIndex:1];
        previousCell.textField.next = cell.textField;
    }
    
    cell.position = [self.tableView cellPositionForIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.cells addObject:cell];
    return cell;
}

- (void)validatePasswords {
    self.saveButton.enabled = (self.password.length >= 8 && [self.confirmPassword isEqualToString:self.password]);
}

#pragma mark - Button Handling

- (void)saveButtonTapped {
    [self.view findAndResignFirstResponder];
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress];
    
    [EVCIA me].password = self.password;
    [EVCIA me].currentPassword = self.previousPassword;
    self.saveButton.enabled = NO;
    
    [[EVCIA me] updateWithSuccess:^{
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
        [EVStatusBarManager sharedManager].duringSuccess = ^(void){ [self.navigationController popViewControllerAnimated:YES]; };
    } failure:^(NSError *error) {
        DLog(@"failed to save user: %@", error);
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
    }];
}

#pragma mark - Frames

- (CGRect)tableViewFrame {
    return self.view.bounds;
}

- (CGRect)footerViewFrame {
    return CGRectMake(0,
                      0,
                      self.view.bounds.size.width,
                      BUTTON_BUFFER + [EVImages blueButtonBackground].size.height*2 + BUTTON_BUFFER*2);
}

- (CGRect)saveButtonFrame {
    return CGRectMake(BUTTON_BUFFER,
                      BUTTON_BUFFER,
                      self.view.bounds.size.width - BUTTON_BUFFER*2,
                      [EVImages blueButtonBackground].size.height);
}

@end
