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
#import "EVGroupRequestPendingPaymentOptionCell.h"
#import "EVRewardsGameViewController.h"

#import "EVGroupRequestRecord.h"
#import "EVGroupRequestTier.h"
#import "EVPayment.h"

@interface EVPendingGroupViewController () {
    BOOL _loading;
}

@property (nonatomic, strong) EVGroupRequestPendingPaymentOptionCell *paymentOptionCell;
@property (nonatomic, weak) EVGroupRequestRecord *record;

@end

@implementation EVPendingGroupViewController

- (id)initWithGroupRequest:(EVGroupRequest *)request {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.groupRequest = request;
        self.record = [self.groupRequest myRecord];
        self.title = @"Group Request";
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
    
    [self loadPaymentOptionCell];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    
    [self.tableView registerClass:[EVGroupRequestPendingHeaderCell class] forCellReuseIdentifier:@"transactionCell"];
    [self.tableView registerClass:[EVDashboardTitleCell class] forCellReuseIdentifier:@"detailCell"];
    [self.tableView registerClass:[EVGroupedTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
    [self.tableView setLoading:self.groupRequest.loading];
}

- (void)loadPaymentOptionCell {
    
    self.paymentOptionCell = [[EVGroupRequestPendingPaymentOptionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                           reuseIdentifier:@"paymentOptionCell"];
    self.paymentOptionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.paymentOptionCell setRecord:self.record];
    [self.paymentOptionCell setPosition:EVGroupedTableViewCellPositionBottom];
    if ([self.record numberOfPayments] > 0) {
        self.paymentOptionCell.headerLabel.text = nil;
    } else {
        self.paymentOptionCell.headerLabel.text = @"Select A Payment Option";
    }
    
    [self addTargetsToOptionButtons];
    
    [self.paymentOptionCell.payInFullButton addTarget:self
                                               action:@selector(payInFullButtonPress:)
                                     forControlEvents:UIControlEventTouchUpInside];
    [self.paymentOptionCell.payPartialButton addTarget:self
                                                action:@selector(payPartialButtonPress:)
                                      forControlEvents:UIControlEventTouchUpInside];
    [self.paymentOptionCell.declineButton addTarget:self
                                             action:@selector(declineButtonPress:)
                                   forControlEvents:UIControlEventTouchUpInside];
}

- (void)addTargetsToOptionButtons {
    for (UIButton *button in self.paymentOptionCell.optionButtons) {
        [button addTarget:self action:@selector(paymentOptionButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - Public Interface

- (void)payInFullButtonPress:(id)sender {
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.paymentOptionCell.payInFullButton.enabled = NO;
    self.paymentOptionCell.payPartialButton.enabled = NO;
    self.paymentOptionCell.declineButton.enabled = NO;
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"PAYING..."];
    [self.groupRequest makePaymentOfAmount:self.record.amountOwed
                                 forRecord:self.record
                               withSuccess:^(EVPayment *payment) {
                                   [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
                                   [[EVCIA sharedInstance] reloadPendingExchangesWithCompletion:^(NSArray *exchanges) {

                                   }];
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
                                   self.paymentOptionCell.payInFullButton.enabled = YES;
                                   self.paymentOptionCell.payPartialButton.enabled = YES;
                                   self.paymentOptionCell.declineButton.enabled = YES;
                               }];
}

- (void)payPartialButtonPress:(id)sender {
    EVPartialPaymentViewController *viewController = [[EVPartialPaymentViewController alloc] initWithRecord:self.record];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)declineButtonPress:(id)sender {
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.paymentOptionCell.payInFullButton.enabled = NO;
    self.paymentOptionCell.payPartialButton.enabled = NO;
    self.paymentOptionCell.declineButton.enabled = NO;
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
                            self.paymentOptionCell.payInFullButton.enabled = YES;
                            self.paymentOptionCell.payPartialButton.enabled = YES;
                            self.paymentOptionCell.declineButton.enabled = YES;
                        }];
}

- (void)paymentOptionButtonPress:(UIButton *)button {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"SETTING PAYMENT OPTION..."];
    
    UIButton *oldButton = nil;
    for (oldButton in self.paymentOptionCell.optionButtons) {
        if (oldButton.selected)
            break;
    }
    [oldButton setSelected:NO];
    [button setSelected:YES];
    NSInteger index = [self.paymentOptionCell.optionButtons indexOfObject:button];
    [self.record setTier:[self.record.groupRequest.tiers objectAtIndex:index]];
    [self.record.groupRequest updateRecord:self.record
                               withSuccess:^(EVGroupRequestRecord *record) {
                                   self.record = record;
                                   [self.paymentOptionCell setRecord:record];
                                   [self addTargetsToOptionButtons];
                                   [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
                               } failure:^(NSError *error) {
                                   DLog(@"Failed to update record: %@", error);
                                   [oldButton setSelected:YES];
                                   [button setSelected:NO];
                                   [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
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
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [EVGroupRequestPendingHeaderCell cellHeightForStory:[EVStory storyFromGroupRequest:self.groupRequest]];
    } else if (indexPath.row == 1) {
        return [EVDashboardTitleCell heightWithTitle:self.groupRequest.title memo:self.groupRequest.memo];
    } else {
        return [self.paymentOptionCell heightForRecord:[self.groupRequest myRecord]];
    }
    return 44.0; // not reached
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVGroupedTableViewCell *cell = nil;
    if (indexPath.row == 0) {
        EVGroupRequestPendingHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"transactionCell" forIndexPath:indexPath];
        EVStory *story = [EVStory storyFromGroupRequest:self.groupRequest];
        [headerCell setStory:story];
        cell = headerCell;
    } else if (indexPath.row == 1) {
        EVDashboardTitleCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
        detailCell.position = EVGroupedTableViewCellPositionCenter;
        [detailCell.titleLabel setText:self.groupRequest.title];
        [detailCell.memoLabel setText:self.groupRequest.memo];
        detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = detailCell;
    } else if (indexPath.row == 2) {
        cell = self.paymentOptionCell;
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
    [self.paymentOptionCell setRecord:self.record];
    if ([self.record numberOfPayments] > 0) {
        self.paymentOptionCell.headerLabel.text = nil;
    } else {
        self.paymentOptionCell.headerLabel.text = @"Select A Payment Option";
    }
    [self.tableView reloadData];
}

@end
