//
//  EVProfileViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVProfileViewController.h"
#import "EVTransactionDetailViewController.h"
#import "EVEditProfileViewController.h"
#import "EVProfileCell.h"
#import "EVNoActivityCell.h"
#import "EVProfileHistoryCell.h"
#import "EVWithdrawal.h"
#import "EVExchange.h"

#import "ReactiveCocoa.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"

@interface EVProfileViewController ()

@end

@implementation EVProfileViewController

#pragma mark - Lifecycle

- (id)initWithUser:(EVUser *)user
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.title = @"Profile";
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.exchanges count] == 0)
        self.tableView.loading = YES;
    [self.tableView reloadData];
    self.view.backgroundColor = [EVColor creamColor];
    [EVCIA reloadMe];
    [[EVCIA me] loadAvatar];
    [[EVCIA sharedInstance] refreshHistoryWithCompletion:^(NSArray *history) {
        self.tableView.loading = NO;
        self.exchanges = history;
        [self.tableView reloadData];
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
    [self.tableView registerClass:[EVProfileCell class] forCellReuseIdentifier:@"profileCell"];
    [self.tableView registerClass:[EVNoActivityCell class] forCellReuseIdentifier:@"noActivityCell"];
    [self.tableView registerClass:[EVProfileHistoryCell class] forCellReuseIdentifier:@"profileHistoryCell"];
    [self.view addSubview:self.tableView];
    
    __block EVProfileViewController *profileController = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [[EVCIA sharedInstance] refreshHistoryWithCompletion:^(NSArray *history) {
            profileController.tableView.loading = NO;
            profileController.exchanges = history;
            [profileController.tableView reloadData];
            [profileController.tableView.pullToRefreshView stopAnimating];
        }];
    }];
}

#pragma mark - Gesture Handling

- (void)editProfileButtonTapped {
    EVEditProfileViewController *editController = [[EVEditProfileViewController alloc] initWithUser:self.user];
    [self.navigationController pushViewController:editController animated:YES];
}

- (void)addFriendButtonTapped {
    NSLog(@"add friend or whatever");
}

#pragma mark - TableView DataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![self hasExchanges] && !self.tableView.isLoading)
        return 2;
    return (1 + [self.exchanges count]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
        return [EVProfileCell cellHeightForUser:self.user];
    if (![self hasExchanges])
        return [EVNoActivityCell cellHeight];
    return [EVProfileHistoryCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVGroupedTableViewCell *cell;
    if (indexPath.row == 0) {
        EVProfileCell *profileCell = [tableView dequeueReusableCellWithIdentifier:@"profileCell" forIndexPath:indexPath];
        profileCell.user = self.user;
        profileCell.parent = self;
        profileCell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = profileCell;
    } else if (![self hasExchanges] && !self.tableView.isLoading) {
        EVNoActivityCell *noActivityCell = [tableView dequeueReusableCellWithIdentifier:@"noActivityCell"];
        cell = noActivityCell;
    } else {
        EVProfileHistoryCell *historyCell = [tableView dequeueReusableCellWithIdentifier:@"profileHistoryCell"];
        EVObject *object = [self.exchanges objectAtIndex:indexPath.row-1];
        historyCell.story = [self storyForObject:object];
        cell = historyCell;
    }
    cell.position = [self.tableView cellPositionForIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0 || ![self hasExchanges])
        return;
    EVObject *object = [self.exchanges objectAtIndex:indexPath.row-1];
    EVTransactionDetailViewController *detailController = [[EVTransactionDetailViewController alloc] initWithStory:[self storyForObject:object]];
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - Utility

- (EVStory *)storyForObject:(EVObject *)object {
    EVStory *story;
    if ([object isKindOfClass:[EVExchange class]])
        story = [EVStory storyFromCompletedExchange:(EVExchange *)object];
    else if ([object isKindOfClass:[EVWithdrawal class]])
        story = [EVStory storyFromWithdrawal:(EVWithdrawal *)object];
    return story;
}

- (BOOL)hasExchanges {
    return (self.exchanges && [self.exchanges count] != 0);
}

#pragma mark - Frames

- (CGRect)tableViewFrame {
    CGRect tableFrame = self.view.bounds;
    tableFrame.size.height += [UIApplication sharedApplication].statusBarFrame.size.height;
    return tableFrame;
}

@end
