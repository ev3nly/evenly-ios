//
//  EVInviteViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVInviteViewController.h"
#import "EVGroupedTableViewCell.h"
#import "EVInviteFacebookViewController.h"
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
@property (nonatomic, strong) UIButton *inviteByTextButton;

@end

@implementation EVInviteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Invite";
        self.canDismissManually = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadWalletBarButtonItem];
    [self loadTableView];
    [self loadFooterView];
    [self loadTextFieldBackground];
    [self loadTextField];
    [self loadInviteByTextButton];
    [self configureReactions];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = [self tableViewFrame];
    self.footerView.frame = [self footerViewFrame];
    self.textFieldBackground.frame = [self textFieldBackgroundFrame];
    self.textField.frame = [self textFieldFrame];
    self.inviteByTextButton.frame = [self inviteByTextButtonFrame];
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
    self.textField.placeholder = @"Enter Phone Number";
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.textFieldBackground addSubview:self.textField];
}

- (void)loadInviteByTextButton {
    self.inviteByTextButton = [UIButton new];
    [self.inviteByTextButton setBackgroundImage:[EVImages blueButtonBackground] forState:UIControlStateNormal];
    [self.inviteByTextButton setBackgroundImage:[EVImages blueButtonBackgroundPress] forState:UIControlStateHighlighted];
    [self.inviteByTextButton addTarget:self action:@selector(invitePhoneNumber) forControlEvents:UIControlEventTouchUpInside];
    [self.inviteByTextButton setTitle:@"INVITE BY TEXT" forState:UIControlStateNormal];
    [self.inviteByTextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.inviteByTextButton.titleLabel.font = [EVFont defaultButtonFont];
    self.inviteByTextButton.frame = [self inviteByTextButtonFrame];
    [self.footerView addSubview:self.inviteByTextButton];
}

- (void)configureReactions {
    [self.textField.rac_textSignal subscribeNext:^(NSString *text) {
        text = [EVStringUtility addHyphensToPhoneNumber:text];
        self.textField.text = text;
        if (text.length == 12)
            [self.textField resignFirstResponder];
    }];

    RAC(self.inviteByTextButton.enabled) = [RACSignal combineLatest:@[self.textField.rac_textSignal]
                                                            reduce:^(NSString *text) {
                                                                return @([text isPhoneNumber]);
                                                            }];
}

#pragma mark - Button

- (void)invitePhoneNumber {
    [self.view findAndResignFirstResponder];
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"INVITING..."];
    
    [EVInvite createWithPhoneNumber:[EVStringUtility strippedPhoneNumber:self.textField.text] success:^(EVObject *object) {
        [EVStatusBarManager sharedManager].duringSuccess = ^{
            self.textField.text = @"";
            self.inviteByTextButton.enabled = NO;
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
    
    if (indexPath.row == EVInviteMethodFacebook) {
        cell.textLabel.text = @"Invite From Facebook";
        cell.imageView.image = [EVImages inviteFacebookIcon];
    } else if (indexPath.row == EVInviteMethodContacts) {
        cell.textLabel.text = @"Invite From Contacts";
        cell.imageView.image = [EVImages inviteContactsIcon];
    }
    cell.position = [self.tableView cellPositionForIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == EVInviteMethodFacebook) {
        EVInviteFacebookViewController *facebookInviteController = [[EVInviteFacebookViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:facebookInviteController animated:YES];
    } else if (indexPath.row == EVInviteMethodContacts) {
        EVInviteContactsViewController *inviteContactsController = [[EVInviteContactsViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:inviteContactsController animated:YES];
    }
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(findAndResignFirstResponder)]];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view findAndResignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.view removeGestureRecognizers];
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

- (CGRect)inviteByTextButtonFrame {
    return CGRectMake(self.textFieldBackground.frame.origin.x,
                      CGRectGetMaxY(self.textField.frame) + TEXT_FIELD_BUTTON_BUFFER,
                      self.textFieldBackground.bounds.size.width,
                      [EVImages blueButtonBackground].size.height);
}

@end
