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
#import "EVInviteActivityItem.h"
#import <FacebookSDK/FacebookSDK.h>

#define CELL_HEIGHT 54

#define HEADER_HEIGHT 80
#define HEADER_MARGIN 10
#define HEADER_BOLD_LABEL_HEIGHT 25

@interface EVInviteViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;

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
    [self loadHeaderView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = [self tableViewFrame];
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

- (void)loadHeaderView {
    self.headerView = [UIView new];
    self.headerView.backgroundColor = [UIColor clearColor];
    self.headerView.frame = [self headerViewFrame];
    [self loadHeaderTitleLabel];
    [self loadHeaderSubtitleLabel];
    self.tableView.tableHeaderView = self.headerView;
}

- (void)loadHeaderTitleLabel {
    UILabel *label;
    label = [[UILabel alloc] initWithFrame:[self headerTitleLabelFrame]];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [EVColor darkColor];
    label.font = [EVFont blackFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Get $5 for every 3 friends that sign up.";
    [self.headerView addSubview:label];
}

- (void)loadHeaderSubtitleLabel {
    UILabel *label;
    label = [[UILabel alloc] initWithFrame:[self headerSubtitleLabelFrame]];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor = [EVColor darkColor];
    label.font = [EVFont defaultFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Friends will thank you!\nAfter joining, they'll receive $1 on us.";
    [self.headerView addSubview:label];
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
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 2;
    if (indexPath.row == EVInviteMethodFacebook) {
        cell.textLabel.text = @"Invite From Facebook";
        cell.imageView.image = [EVImages inviteFacebookIcon];
    } else if (indexPath.row == EVInviteMethodContacts) {
        cell.textLabel.text = @"Invite From Contacts";
        cell.imageView.image = [EVImages inviteContactsIcon];
    } else if (indexPath.row == EVInviteMethodLink) {
        cell.textLabel.text = @"Share your personal invitation URL via email, text, and more";
        cell.imageView.image = [EVImages invitePlusIcon];
    }
    cell.position = [self.tableView cellPositionForIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == EVInviteMethodFacebook) {
        [self showFacebookController];
    } else if (indexPath.row == EVInviteMethodContacts) {
        [self showContactsController];
    } else if (indexPath.row == EVInviteMethodLink) {
        [self showActivityController];
    }
}

- (void)showFacebookController {
    EVInviteFacebookViewController *facebookInviteController = [[EVInviteFacebookViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:facebookInviteController animated:YES];
}

- (void)showContactsController {
    EVInviteContactsViewController *inviteContactsController = [[EVInviteContactsViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:inviteContactsController animated:YES];
}

- (void)showActivityController {
    EVInviteActivityItem *activityItem = [[EVInviteActivityItem alloc] initWithURL:[[EVCIA me] shortInviteURL]];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[ activityItem ]
                                                                                         applicationActivities:nil];
    [activityViewController setExcludedActivityTypes:@[ UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll ]];
    [self presentViewController:activityViewController animated:YES completion:NULL];
}

#pragma mark - Frames

- (CGRect)tableViewFrame {
    return self.view.bounds;
}

- (CGRect)headerViewFrame {
    return CGRectMake(0,
                      0,
                      self.view.bounds.size.width,
                      HEADER_HEIGHT);
}

- (CGRect)headerTitleLabelFrame {
    return CGRectMake(HEADER_MARGIN,
                      HEADER_MARGIN,
                      self.headerView.frame.size.width - 2*HEADER_MARGIN,
                      HEADER_BOLD_LABEL_HEIGHT);
}

- (CGRect)headerSubtitleLabelFrame {
    return CGRectMake(HEADER_MARGIN,
                      HEADER_MARGIN + HEADER_BOLD_LABEL_HEIGHT,
                      self.headerView.frame.size.width - 2*HEADER_MARGIN,
                      self.headerView.frame.size.height - HEADER_MARGIN - HEADER_BOLD_LABEL_HEIGHT);
}

@end
