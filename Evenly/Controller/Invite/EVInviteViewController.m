//
//  EVInviteViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVInviteViewController.h"
#import "EVGroupedTableViewCell.h"
#import "EVFacebookInviteViewController.h"
#import "EVInviteContactsViewController.h"
#import "EVInvite.h"
#import "EVValidator.h"
#import "ReactiveCocoa.h"
#import <FacebookSDK/FacebookSDK.h>

#define CELL_HEIGHT 54

#define FOOTER_TOP_BUFFER 20
#define TEXT_FIELD_BUTTON_BUFFER 20
#define TEXT_FIELD_SIDE_BUFFER 10

@interface EVInviteViewController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIView *textFieldBackground;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *inviteEmailButton;

@end

@implementation EVInviteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Invite";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadTableView];
    [self loadFooterView];
    [self loadTextFieldBackground];
    [self loadTextField];
    [self loadInviteEmailButton];
    [self configureReactions];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(findAndResignFirstResponder)]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = [self tableViewFrame];
    self.footerView.frame = [self footerViewFrame];
    self.textFieldBackground.frame = [self textFieldBackgroundFrame];
    self.textField.frame = [self textFieldFrame];
    self.inviteEmailButton.frame = [self inviteEmailButtonFrame];
}

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:[self tableViewFrame] style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    [self.tableView registerClass:[EVGroupedTableViewCell class] forCellReuseIdentifier:@"groupedTableViewCell"];
    [self.view addSubview:self.tableView];
}

- (void)loadFooterView {
    self.footerView = [UIView new];
    self.footerView.backgroundColor = [UIColor clearColor];
    self.footerView.frame = [self footerViewFrame];
    self.tableView.tableFooterView = self.footerView;
}

- (void)loadTextFieldBackground {
    EVGroupedTableViewCell *cell = [[EVGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textField"];
    cell.position = EVGroupedTableViewCellPositionSingle;
    self.textFieldBackground = cell;
    [self.footerView addSubview:self.textFieldBackground];
}

- (void)loadTextField {
    self.textField = [UITextField new];
    self.textField.text = @"";
    self.textField.textColor = [EVColor darkLabelColor];
    self.textField.font = [EVFont boldFontOfSize:15];
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField.placeholder = @"Enter Email";
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.textFieldBackground addSubview:self.textField];
}

- (void)loadInviteEmailButton {
    self.inviteEmailButton = [UIButton new];
    [self.inviteEmailButton setBackgroundImage:[EVImages blueButtonBackground] forState:UIControlStateNormal];
    [self.inviteEmailButton setBackgroundImage:[EVImages blueButtonBackgroundPress] forState:UIControlStateHighlighted];
    [self.inviteEmailButton addTarget:self action:@selector(inviteEmail) forControlEvents:UIControlEventTouchUpInside];
    [self.inviteEmailButton setTitle:@"INVITE EMAIL" forState:UIControlStateNormal];
    [self.inviteEmailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.inviteEmailButton.titleLabel.font = [EVFont defaultButtonFont];
    self.inviteEmailButton.frame = [self inviteEmailButtonFrame];
    [self.footerView addSubview:self.inviteEmailButton];
}

- (void)configureReactions {
    RAC(self.inviteEmailButton.enabled) = [RACSignal combineLatest:@[self.textField.rac_textSignal]
                                                            reduce:^(NSString *text) {
                                                                return @([[EVValidator sharedValidator] stringIsValidEmail:text]);
                                                            }];
}

#pragma mark - Button

- (void)inviteEmail {
    [self.view findAndResignFirstResponder];
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"INVITING..."];

    [EVInvite createWithEmails:@[self.textField.text] success:^(EVObject *object) {
        [EVStatusBarManager sharedManager].duringSuccess = ^{
            self.textField.text = @"";
            self.inviteEmailButton.enabled = NO;
        };
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
    } failure:^(NSError *error) {
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
    }];
}

#pragma mark - TableView DataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return EVInviteMethodCOUNT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVGroupedTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"groupedTableViewCell"];
    
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow"]];
    cell.textLabel.text = indexPath.row == EVInviteMethodFacebook ? @"Invite From Facebook" : @"Invite From Contacts";
    cell.position = [self.tableView cellPositionForIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == EVInviteMethodFacebook) {
        EVFacebookInviteViewController *facebookInviteController = [[EVFacebookInviteViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:facebookInviteController animated:YES];
    } else if (indexPath.row == EVInviteMethodContacts) {
        EVInviteContactsViewController *inviteContactsController = [[EVInviteContactsViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:inviteContactsController animated:YES];
    }
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view findAndResignFirstResponder];
    return YES;
}

#pragma mark - Frames

- (CGRect)tableViewFrame {
    return self.view.bounds;
}

- (CGRect)footerViewFrame {
    return CGRectMake(0,
                      0,
                      self.view.bounds.size.width,
                      FOOTER_TOP_BUFFER + [EVImages blueButtonBackground].size.height + CELL_HEIGHT + TEXT_FIELD_BUTTON_BUFFER);
}

- (CGRect)textFieldBackgroundFrame {
    return CGRectMake(TEXT_FIELD_SIDE_BUFFER,
                      0,
                      self.view.bounds.size.width - TEXT_FIELD_SIDE_BUFFER*2,
                      CELL_HEIGHT);
}

- (CGRect)textFieldFrame {
    return CGRectMake(TEXT_FIELD_SIDE_BUFFER,
                      0,
                      self.textFieldBackground.bounds.size.width - TEXT_FIELD_SIDE_BUFFER*2,
                      self.textFieldBackground.bounds.size.height);
}

- (CGRect)inviteEmailButtonFrame {
    return CGRectMake(20,
                      CGRectGetMaxY(self.textField.frame) + TEXT_FIELD_BUTTON_BUFFER,
                      self.view.bounds.size.width - 20*2,
                      [EVImages blueButtonBackground].size.height);
}

@end
