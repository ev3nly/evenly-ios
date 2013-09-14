//
//  EVPendingGroupViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPendingGroupViewController.h"
#import "EVGroupRequestPendingHeaderCell.h"
#import "EVGroupedTableViewCell.h"
#import "EVDashboardTitleCell.h"
#import "EVGroupRequestPendingPaymentCell.h"
#import "EVRewardsGameViewController.h"

#import "EVGroupRequestRecord.h"
#import "EVGroupRequestTier.h"
#import "EVPayment.h"

@interface EVPendingGroupViewController () {
    BOOL _loading;
}

@property (nonatomic, strong) EVGroupRequestPendingPaymentCell *payRejectCell;
@property (nonatomic, weak) EVGroupRequestRecord *record;

@end

@implementation EVPendingGroupViewController

- (id)initWithGroupRequest:(EVGroupRequest *)request {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.groupRequest = request;
        self.record = [self.groupRequest myRecord];
        self.title = @"Request";
    }
    return self;
}

#pragma mark - EVReloadable

- (void)setLoading:(BOOL)loading {
    _loading = loading;
    [self.tableView setLoading:_loading];
}

- (BOOL)isLoading {
    return _loading;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadPayRejectCell];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    
    [self.tableView registerClass:[EVGroupRequestPendingHeaderCell class] forCellReuseIdentifier:@"transactionCell"];
    [self.tableView registerClass:[EVGroupedTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
    [self.tableView setLoading:self.groupRequest.loading];
}

- (void)loadPayRejectCell {
    self.payRejectCell = [[EVGroupRequestPendingPaymentCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                       reuseIdentifier:@"payRejectCell"];
    [self.payRejectCell setPosition:EVGroupedTableViewCellPositionBottom];
    [self.payRejectCell setRecord:self.record];
    [self.payRejectCell.payInFullButton addTarget:self
                                               action:@selector(payInFullButtonPress:)
                                     forControlEvents:UIControlEventTouchUpInside];
    [self.payRejectCell.declineButton addTarget:self
                                             action:@selector(declineButtonPress:)
                                   forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Public Interface

- (void)payInFullButtonPress:(id)sender {
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.payRejectCell.payInFullButton.enabled = NO;
    self.payRejectCell.declineButton.enabled = NO;
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"PAYING..."];
    [self.groupRequest makePaymentOfAmount:self.record.amountOwed
                                 forRecord:self.record
                               withSuccess:^(EVPayment *payment) {
                                   [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
                                   [[EVCIA sharedInstance] reloadPendingExchangesWithCompletion:^(NSArray *exchanges) {

                                   }];
                                   [EVCIA reloadMe];
                                   [[EVStatusBarManager sharedManager] setPostSuccess:^{
                                       if (payment.reward)
                                           [self showGameForReward:payment.reward];
                                       else
                                           [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
                                   }];
                               } failure:^(NSError *error) {
                                   [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
                                   self.navigationItem.leftBarButtonItem.enabled = YES;
                                   self.navigationItem.rightBarButtonItem.enabled = YES;
                                   self.payRejectCell.payInFullButton.enabled = YES;
                                   self.payRejectCell.declineButton.enabled = YES;
                               }];
}

- (void)declineButtonPress:(id)sender {
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.payRejectCell.payInFullButton.enabled = NO;
    self.payRejectCell.declineButton.enabled = NO;
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"DECLINING..."];
    [self.groupRequest deleteRecord:self.record
                        withSuccess:^{
                            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
                            [[EVCIA sharedInstance] reloadPendingExchangesWithCompletion:^(NSArray *exchanges) {
                            }];
                            [[EVStatusBarManager sharedManager] setPostSuccess:^{
                                [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
                            }];
                        } failure:^(NSError *error) {
                            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
                            self.navigationItem.leftBarButtonItem.enabled = YES;
                            self.navigationItem.rightBarButtonItem.enabled = YES;
                            self.payRejectCell.payInFullButton.enabled = YES;
                            self.payRejectCell.payPartialButton.enabled = YES;
                            self.payRejectCell.declineButton.enabled = YES;
                        }];
}

- (void)showGameForReward:(EVReward *)reward {
    EVRewardsGameViewController *rewardsViewController = [[EVRewardsGameViewController alloc] initWithReward:reward];
    [self.navigationController pushViewController:rewardsViewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.groupRequest.loading)
        return 0;
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [EVGroupRequestPendingHeaderCell cellHeightForStory:[EVStory storyFromGroupRequest:self.groupRequest] memo:self.groupRequest.memo];
    }
    return [self.payRejectCell heightForRecord:[self.groupRequest myRecord]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVGroupedTableViewCell *cell = nil;
    if (indexPath.row == 0) {
        EVGroupRequestPendingHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"transactionCell" forIndexPath:indexPath];
        EVStory *story = [EVStory storyFromGroupRequest:self.groupRequest];
        [headerCell setStory:story];
        [headerCell.memoLabel setText:self.groupRequest.memo];
        cell = headerCell;
    }
    else if (indexPath.row == 1) {
        cell = self.payRejectCell;
    }
    return cell;
}

#pragma mark - EVPartialPaymentViewControllerDelegate

- (void)viewController:(EVPartialPaymentViewController *)viewController madePartialPayment:(EVPayment *)payment {
    [self reload];
}

- (void)reload {
    [self.tableView setLoading:NO];
    self.record = [self.groupRequest myRecord];
    [self.payRejectCell setRecord:self.record];
    [self.tableView reloadData];
}

@end
