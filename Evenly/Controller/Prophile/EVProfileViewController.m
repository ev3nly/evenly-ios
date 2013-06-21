//
//  EVProfileViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVProfileViewController.h"
#import "EVProfileCell.h"
#import "EVNoActivityCell.h"
#import "EVProfileHistoryCell.h"
#import "EVWithdrawal.h"
#import "ReactiveCocoa.h"

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.view.backgroundColor = [EVColor creamColor];
    [EVCIA reloadMe];
    [[EVCIA me] loadAvatar];
    [[EVCIA sharedInstance] reloadHistoryWithCompletion:^(NSArray *history) {
        self.tableView.isLoading = NO;
        self.exchanges = history;
        [self.tableView reloadData];
    }];
}

#pragma mark - View Loading

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
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
}

#pragma mark - Gesture Handling

- (void)profileButtonTapped:(id)sender {
    NSLog(@"prof tap");
}

#pragma mark - TableView DataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![self hasExchanges])
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
        profileCell.position = [self cellPositionForIndexPath:indexPath];
        profileCell.parent = self;
        cell = profileCell;
    } else if (![self hasExchanges]) {
        EVNoActivityCell *noActivityCell = [tableView dequeueReusableCellWithIdentifier:@"noActivityCell"];
        noActivityCell.position = [self cellPositionForIndexPath:indexPath];
        cell = noActivityCell;
    } else {
        EVProfileHistoryCell *historyCell = [tableView dequeueReusableCellWithIdentifier:@"profileHistoryCell"];
        historyCell.position = [self cellPositionForIndexPath:indexPath];
        EVExchange *exchange = [self.exchanges objectAtIndex:indexPath.row-1];
        if (![[self.exchanges objectAtIndex:indexPath.row-1] isKindOfClass:[EVWithdrawal class]])
              historyCell.story = [EVStory storyFromCompletedExchange:exchange];
        cell = historyCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Utility

- (EVGroupedTableViewCellPosition)cellPositionForIndexPath:(NSIndexPath *)indexPath {
    NSInteger rowCount = [self tableView:self.tableView numberOfRowsInSection:indexPath.section];
    if (rowCount <= 1)
        return EVGroupedTableViewCellPositionSingle;
    else {
        if (indexPath.row == 0)
            return EVGroupedTableViewCellPositionTop;
        else if (indexPath.row == rowCount - 1)
            return EVGroupedTableViewCellPositionBottom;
        else
            return EVGroupedTableViewCellPositionCenter;
    }
}

- (BOOL)hasExchanges {
    return (self.exchanges && [self.exchanges count] != 0);
}

@end
