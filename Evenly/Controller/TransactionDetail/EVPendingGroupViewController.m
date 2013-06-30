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

#import "EVGroupRequestRecord.h"
#import "EVGroupRequestTier.h"

@interface EVPendingGroupViewController ()

@property (nonatomic, strong) EVGroupRequestPendingPaymentOptionCell *paymentOptionCell;
@property (nonatomic, weak) EVGroupRequestRecord *record;

- (void)reload;

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
    
    for (UIButton *button in self.paymentOptionCell.optionButtons) {
        [button addTarget:self action:@selector(paymentOptionButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.paymentOptionCell.payInFullButton addTarget:self
                                               action:@selector(payInFullButtonPress:)
                                     forControlEvents:UIControlEventTouchUpInside];
    [self.paymentOptionCell.payPartialButton addTarget:self
                                                action:@selector(payPartialButtonPress:)
                                      forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Public Interface

- (void)payInFullButtonPress:(id)sender {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"PAYING..."];
    [self.groupRequest makePaymentOfAmount:self.record.amountOwed
                                 forRecord:self.record
                               withSuccess:^(EVPayment *payment) {
                                   [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
                                   [[EVCIA sharedInstance] reloadAllExchangesWithCompletion:NULL];
                                   [[EVStatusBarManager sharedManager] setPostSuccess:^{
                                       [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
                                   }];
                               } failure:^(NSError *error) {
                                   [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
                               }];
}

- (void)payPartialButtonPress:(id)sender {
    EVPartialPaymentViewController *viewController = [[EVPartialPaymentViewController alloc] initWithRecord:self.record];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
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
                                   [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
                               } failure:^(NSError *error) {
                                   DLog(@"Failed to update record: %@", error);
                                   [oldButton setSelected:YES];
                                   [button setSelected:NO];
                                   [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
                               }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    [self.paymentOptionCell setRecord:self.record];
    if ([self.record numberOfPayments] > 0) {
        self.paymentOptionCell.headerLabel.text = nil;
    } else {
        self.paymentOptionCell.headerLabel.text = @"Select A Payment Option";
    }
    [self.tableView reloadData];
}

@end
