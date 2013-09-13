//
//  EVProfileViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVProfileViewController.h"
#import "EVStoryDetailViewController.h"
#import "EVEditProfileViewController.h"
#import "EVProfileCell.h"
#import "EVNoActivityCell.h"
#import "EVProfileHistoryCell.h"
#import "EVWithdrawal.h"
#import "EVExchange.h"
#import "EVRequestViewController.h"
#import "EVPaymentViewController.h"

#import "ReactiveCocoa.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"

@interface EVProfileViewController () {
    BOOL _loading;
}


@property (nonatomic, strong) EVProfileCell *profileCell;

@end

@implementation EVProfileViewController

#pragma mark - Lifecycle

- (id)initWithUser:(EVUser *)user
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.title = @"Profile";
        self.user = user;
        self.canDismissManually = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self userIsMe])
        [self loadWalletBarButtonItem];
    [self loadTableView];
    [self loadProfileCell];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.timeline count] == 0)
        self.tableView.loading = YES;
    [self.tableView reloadData];
    self.view.backgroundColor = [EVColor creamColor];
    [self.user timelineWithSuccess:^(NSArray *timeline) {
        self.timeline = timeline;
        self.tableView.loading = NO;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        DLog(@"Failure: %@", error);
    }];
}

#pragma mark - View Loading

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:[self tableViewFrame] style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, [UIApplication sharedApplication].statusBarFrame.size.height, 0);
    [self.tableView registerClass:[EVProfileCell class] forCellReuseIdentifier:@"profileCell"];
    [self.tableView registerClass:[EVNoActivityCell class] forCellReuseIdentifier:@"noActivityCell"];
    [self.tableView registerClass:[EVProfileHistoryCell class] forCellReuseIdentifier:@"profileHistoryCell"];
    [self.view addSubview:self.tableView];
    
    __block EVProfileViewController *profileController = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [profileController.user timelineWithSuccess:^(NSArray *timeline) {
            profileController.timeline = timeline;
            profileController.tableView.loading = NO;
            [profileController.tableView reloadData];
            [profileController.tableView.pullToRefreshView stopAnimating];
        } failure:^(NSError *error) {
            DLog(@"Failure: %@", error);
            profileController.tableView.loading = NO;
            [profileController.tableView.pullToRefreshView stopAnimating];
        }];
    }];
    self.tableView.pullToRefreshView.originalTopInset = [self totalBarHeight];
    
    [self.tableView setLoading:self.user.loading];
}

- (void)loadProfileCell {
    self.profileCell = [[EVProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"profileCell"];
    self.profileCell.user = self.user;
    self.profileCell.parent = self;
    self.profileCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    EVContact *contact = [EVContact new];
    contact.email = self.user.email;
    contact.name = self.user.name;
    
    __weak EVProfileViewController *weakSelf = self;
    if (![self userIsMe]) {
        self.profileCell.handleChargeUser = ^{
            [weakSelf requestFromContact:weakSelf.user];
        };
        self.profileCell.handlePayUser = ^{
            [weakSelf payContact:weakSelf.user];
        };
    }
}

#pragma mark - Gesture Handling

- (void)editProfileButtonTapped {
    EVEditProfileViewController *editController = [[EVEditProfileViewController alloc] initWithUser:self.user];
    editController.handleSave = ^(EVUser *user) {
        self.user = [EVCIA me];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:editController animated:YES];
}

- (void)payContact:(EVUser *)contact {
    [self displayExchangeController:[EVPaymentViewController new] forContact:contact];
}

- (void)requestFromContact:(EVUser *)contact {
    [self displayExchangeController:[EVRequestViewController new] forContact:contact];
    
//    EVRequestViewController *requestController = [EVRequestViewController new];
//    [requestController viewDidLoad];
//    [requestController addContact:contact];
//    [requestController advancePhase];
//    [self displayExchangeController:requestController];
}

- (void)displayExchangeController:(EVExchangeViewController *)controller forContact:(EVUser *)contact {
    EVNavigationController *navController = [[EVNavigationController alloc] initWithRootViewController:controller];
    
    [controller viewDidLoad];
    [controller addContact:contact];
    // EVPaymentViewController has a reaction that advances when a contact is added, so just do this for requests
    if ([controller isKindOfClass:[EVRequestViewController class]])
        [controller advancePhase];
    
    [self presentViewController:navController animated:YES completion:NULL];
    [controller unloadPageControlAnimated:NO];
    [controller loadPageControl];
    controller.pageControl.currentPage = 1;
}

#pragma mark - TableView DataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.user.loading)
        return 0;
    
    if (![self hasExchanges] && !self.tableView.isLoading)
        return 2;
    return (1 + [self.timeline count]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
        return [EVProfileCell cellHeightForUser:self.user];
    if (![self hasExchanges])
        return [EVNoActivityCell cellHeightForUser:self.user];
    return [EVProfileHistoryCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVGroupedTableViewCell *cell;
    if (indexPath.row == 0) {
        self.profileCell.user = self.user;
        cell = self.profileCell;
    } else if (![self hasExchanges] && !self.tableView.isLoading) {
        EVNoActivityCell *noActivityCell = [tableView dequeueReusableCellWithIdentifier:@"noActivityCell"];
        noActivityCell.userIsSelf = [self.user.dbid isEqualToString:[EVCIA me].dbid];
        cell = noActivityCell;
    } else {
        EVProfileHistoryCell *historyCell = [tableView dequeueReusableCellWithIdentifier:@"profileHistoryCell"];
        EVStory *story = [self.timeline objectAtIndex:indexPath.row - 1];
        historyCell.story = story;
        cell = historyCell;
    }
    cell.position = [self.tableView cellPositionForIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0 || ![self hasExchanges])
        return;
    EVStoryDetailViewController *detailController = [[EVStoryDetailViewController alloc] initWithStory:[self.timeline objectAtIndex:indexPath.row-1]];
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - Utility

- (BOOL)hasExchanges {
    return (self.timeline && [self.timeline count] != 0);
}

- (BOOL)userIsMe {
    return [self.user.dbid isEqualToString:[EVCIA me].dbid];
}

#pragma mark - Frames

- (CGRect)tableViewFrame {
    CGRect tableFrame = self.view.bounds;
    tableFrame.size.height += [UIApplication sharedApplication].statusBarFrame.size.height;
    return tableFrame;
}


#pragma mark - EVReloadable

- (void)setLoading:(BOOL)loading {
    _loading = loading;
    [self.tableView setLoading:_loading];
}

- (BOOL)isLoading {
    return _loading;
}

- (void)reload {
    [self loadProfileCell];
    [self.tableView reloadData];
    [self.tableView setLoading:NO];
}
@end
