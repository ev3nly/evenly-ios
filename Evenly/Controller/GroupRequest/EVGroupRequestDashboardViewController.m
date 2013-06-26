//
//  EVGroupRequestDashboardViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestDashboardViewController.h"
#import "EVGroupRequestDashboardTableViewDataSource.h"
#import "EVDashboardTitleCell.h"
#import "EVDashboardUserCell.h"
#import "EVDashboardNoOneJoinedCell.h"
#import "EVGroupRequestProgressView.h"

#import "EVGroupRequestRecordViewController.h"

typedef enum {
    EVGroupRequestActionEdit,
    EVGroupRequestActionInvite,
    EVGroupRequestActionCloseRequest
} EVGroupRequestAction;

@interface EVGroupRequestDashboardViewController ()

@property (nonatomic, strong) EVGroupRequest *groupRequest;
@property (nonatomic, strong) EVGroupRequestDashboardTableViewDataSource *dataSource;

@property (nonatomic, strong) UITableView *tableView;

- (void)loadRightBarButton;

@end

@implementation EVGroupRequestDashboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithGroupRequest:(EVGroupRequest *)groupRequest {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.groupRequest = groupRequest;
        self.dataSource = [[EVGroupRequestDashboardTableViewDataSource alloc] initWithGroupRequest:self.groupRequest];
        [self.dataSource.inviteButton addTarget:self action:@selector(inviteButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.dataSource.remindAllButton addTarget:self action:@selector(remindAllButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        self.title = self.groupRequest.title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadRightBarButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.dataSource;
    self.dataSource.tableView = self.tableView;
    self.tableView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[EVDashboardTitleCell class] forCellReuseIdentifier:@"titleCell"];
    [self.tableView registerClass:[EVDashboardUserCell class] forCellReuseIdentifier:@"userCell"];
    [self.tableView registerClass:[EVDashboardNoOneJoinedCell class] forCellReuseIdentifier:@"noOneJoinedCell"];
    [self.tableView registerClass:[EVGroupedTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
}

- (void)loadRightBarButton {
    UIImage *image = [UIImage imageNamed:@"More"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width + 20.0, image.size.height)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    [button setImage:image forState:UIControlStateNormal];
    [button setShowsTouchWhenHighlighted:YES];
    [button setAdjustsImageWhenHighlighted:NO];
    [button addTarget:self action:@selector(moreButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.dataSource animate];
}

#pragma mark - Button Actions

- (void)moreButtonPress:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Edit", @"Invite", @"Close Request", nil];
    [actionSheet showInView:self.view];
}

- (void)inviteButtonPress:(id)sender {
    
}

- (void)remindAllButtonPress:(id)sender {
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource heightForRowAtIndexPath:indexPath];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < EVDashboardPermanentRowCOUNT)
        return nil;
    if ([self.dataSource.displayedRecords count] == 0)
        return nil;
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EVGroupRequestRecord *record = [self.dataSource recordAtIndexPath:indexPath];
    if (record) {
        EVGroupRequestRecordViewController *viewController = [[EVGroupRequestRecordViewController alloc] initWithRecord:record];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == EVGroupRequestActionCloseRequest)
    {
        [self closeRequest];
    }
}

- (void)closeRequest {
    self.groupRequest.completed = YES;
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"CLOSING REQUEST..."];
    [self.groupRequest updateWithSuccess:^{
        [[EVCIA sharedInstance] reloadPendingSentExchangesWithCompletion:NULL];
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
        [EVStatusBarManager sharedManager].completion = ^(void) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            }];
        };
    } failure:^(NSError *error) {
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
    }];
}

@end
