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

#import "EVGroupRequestEditViewController.h"
#import "EVInstructionView.h"
#import "EVSettingsManager.h"

#import "EVGroupRequestInviteViewController.h"

typedef enum {
//    EVGroupRequestActionEdit,
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
        self.title = @"Group Request";
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
    [button setImageEdgeInsets:EV_VIEW_CONTROLLER_BAR_BUTTON_IMAGE_INSET];
    [button setImage:image forState:UIControlStateNormal];
    [button setShowsTouchWhenHighlighted:YES];
    [button setAdjustsImageWhenHighlighted:NO];
    [button addTarget:self action:@selector(moreButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.dataSource animate];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:EVHasSeenGroupRequestDashboardAlertKey] != YES)
    {
        [self showDashboardInstructions];
    }
}

- (void)showDashboardInstructions {
    EVInstructionView *instructionView = [[EVInstructionView alloc] initWithAttributedText:[EVStringUtility groupRequestDashboardInstructions]];
    [instructionView setShowingLogo:YES];
    [instructionView showInView:self.view];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:EVHasSeenGroupRequestDashboardAlertKey];
    [[NSUserDefaults standardUserDefaults] synchronize];    
}

#pragma mark - Button Actions

- (void)moreButtonPress:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:
//                                  @"Payment Options",
                                  @"Invite",
                                  @"Close Request", nil];
    [actionSheet showInView:self.view];
}

- (void)inviteButtonPress:(id)sender {
    [self showInviteViewController];
}

- (void)remindAllButtonPress:(id)sender {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"REMINDING ALL..."];
    [self.groupRequest remindAllWithSuccess:^{
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
    } failure:^(NSError *error) {
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
    }];
}

#pragma mark - Invite View Controller

- (void)showInviteViewController {
    EVGroupRequestInviteViewController *inviteViewController = [[EVGroupRequestInviteViewController alloc] initWithGroupRequest:self.groupRequest];
    inviteViewController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:inviteViewController];
    [self presentViewController:navController animated:YES completion:NULL];
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

- (void)gearButtonPress:(id)sender {
    NSDictionary *userInfo = [sender userInfo];
    NSIndexPath *indexPath = userInfo[@"indexPath"];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EVGroupRequestRecord *record = [self.dataSource recordAtIndexPath:indexPath];
    if (record) {
        EVGroupRequestRecordViewController *viewController = [[EVGroupRequestRecordViewController alloc] initWithRecord:record];
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == EVGroupRequestActionCloseRequest)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Close Request"
                                                        message:@"Are you sure you want to close this request?"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
        [alert show];
    }
//    else if (buttonIndex == EVGroupRequestActionEdit)
//    {
//        EVGroupRequestEditViewController *editViewController = [[EVGroupRequestEditViewController alloc] initWithGroupRequest:self.groupRequest];
//        editViewController.delegate = self;
//        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:editViewController];
//        [self presentViewController:navController animated:YES completion:NULL];
//    }
    else if (buttonIndex == EVGroupRequestActionInvite)
    {
        [self showInviteViewController];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        [self closeRequest];
    }
}

- (void)closeRequest {
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.groupRequest.completed = YES;
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"CLOSING REQUEST..."];
    [self.groupRequest updateWithSuccess:^{
        [[EVCIA sharedInstance] reloadPendingSentExchangesWithCompletion:NULL];
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
        [EVStatusBarManager sharedManager].duringSuccess = ^(void) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            }];
        };
    } failure:^(NSError *error) {
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

#pragma mark - EVGroupRequestRecordViewControllerDelegate

- (void)viewController:(EVGroupRequestRecordViewController *)viewController updatedRecord:(EVGroupRequestRecord *)record {
    EV_PERFORM_ON_MAIN_QUEUE(^{
        NSInteger index = [self.groupRequest.records indexOfObject:record];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:EVDashboardPermanentRowCOUNT + index inSection:0] ]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    });
}

- (void)viewController:(EVGroupRequestRecordViewController *)viewController deletedRecord:(EVGroupRequestRecord *)record {
    EV_PERFORM_ON_MAIN_QUEUE(^{
        [self.dataSource setGroupRequest:self.groupRequest];
        [self.tableView reloadData];
    });
}
#pragma mark - EVGroupRequestEditViewControllerDelegate

- (void)editViewControllerMadeChanges:(EVGroupRequestEditViewController *)editViewController {
    EV_PERFORM_ON_MAIN_QUEUE(^{
        [self.tableView reloadData];
    });
}

#pragma mark - EVGroupRequestInviteViewControllerDelegate

- (void)inviteViewController:(EVGroupRequestInviteViewController *)controller sentInvitesTo:(NSArray *)invitees {
    EV_PERFORM_ON_MAIN_QUEUE(^{
        [self.dataSource setGroupRequest:self.groupRequest];
        [self.tableView reloadData];
    });
}

@end
