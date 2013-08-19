//
//  EVPendingDetailViewController.m
//  Evenly
//
//  Created by Justin Brunet on 6/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPendingDetailViewController.h"
#import "EVPendingDetailCell.h"
#import "EVStory.h"
#import "EVRequest.h"
#import "EVPayment.h"
#import "EVWalletViewController.h"
#import "EVNavigationManager.h"
#import "MBProgressHUD.h"
#import "EVRewardsGameViewController.h"

@interface EVPendingDetailViewController () {
    BOOL _loading;
}

@property (nonatomic, strong) EVPendingDetailCell *cell;

@end

@implementation EVPendingDetailViewController

@dynamic loading;

#pragma mark - Lifecycle

- (id)initWithExchange:(EVExchange *)exchange {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.exchange = exchange;
        self.title = @"Request";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadCell];
    [self loadTableView];
    if (self.exchange.isLoading)
        [self.tableView setLoading:YES];
}

- (void)loadCell {
    self.cell = [[EVPendingDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
}

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [EVColor creamColor];
    self.tableView.backgroundView = nil;
    [self.tableView registerClass:[EVPendingDetailCell class] forCellReuseIdentifier:@"pendingDetailCell"];
    [self.view addSubview:self.tableView];
    
    [self.tableView setLoading:[self.exchange isLoading]];
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
    [self.tableView reloadData];
    [self.tableView setLoading:NO];
}

#pragma mark - Take Action

- (void)confirmRequest {
    [self prepareForRequestWithText:@"SENDING PAYMENT..."];
    if ([self.exchange isKindOfClass:[EVRequest class]]) {
        EVRequest *request = (EVRequest *)self.exchange;
        [request completeWithSuccess:^(EVPayment *payment){

            // Don't allow the balance to fall below 0.  If a payment amount is > available balance, it gets
            // paid via credit card, leaving the balance unaffected.
            NSDecimalNumber *newBalance = [[[EVCIA me] balance] decimalNumberBySubtracting:self.exchange.amount];
            if ([newBalance compare:[NSDecimalNumber zero]] != NSOrderedAscending) {
                [[EVCIA me] setBalance:newBalance];
            }
            [[EVCIA sharedInstance] reloadPendingSentExchangesWithCompletion:NULL];
            
            EVStory *story = [EVStory storyFromCompletedExchange:self.exchange];
            story.publishedAt = [NSDate date];
            [[NSNotificationCenter defaultCenter] postNotificationName:EVStoryLocallyCreatedNotification
                                                                object:nil
                                                              userInfo:@{ @"story" : story }];
            
            
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
            [EVStatusBarManager sharedManager].duringSuccess = ^(void) {
                [EVCIA reloadMe];
                [[EVCIA sharedInstance] reloadPendingExchangesWithCompletion:NULL];
                if (payment.reward)
                {
                    EVRewardsGameViewController *rewardsViewController = [[EVRewardsGameViewController alloc] initWithReward:payment.reward];
                    [self.navigationController pushViewController:rewardsViewController animated:YES];
                } else {
                    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
                }
            };
        } failure:^(NSError *error) {
            [self handleFailure];
        }];
    }
}

- (void)denyRequest {
    [self prepareForRequestWithText:@"DENYING PAYMENT..."];
    if ([self.exchange isKindOfClass:[EVRequest class]]) {
        EVRequest *request = (EVRequest *)self.exchange;
        [request denyWithSuccess:^{
            [[EVCIA sharedInstance] reloadPendingExchangesWithCompletion:^(NSArray *exchanges) {
            }];
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
            [EVStatusBarManager sharedManager].duringSuccess = ^(void) {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                }];
            };
        } failure:^(NSError *error) {
            [self handleFailure];
        }];
    }
}

- (void)remindRequest {
    [self prepareForRequestWithText:@"REMINDING..."];
    if ([self.exchange isKindOfClass:[EVRequest class]]) {
        EVRequest *request = (EVRequest *)self.exchange;
        [request remindWithSuccess:^{
            
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
            [EVStatusBarManager sharedManager].duringSuccess = ^(void) {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                    [[EVCIA sharedInstance] reloadPendingExchangesWithCompletion:^(NSArray *exchanges) {
                    }];
                }];
            };
        } failure:^(NSError *error) {
            [self handleFailure];
        }];
    }
}

- (void)cancelRequest {
    [self prepareForRequestWithText:@"CANCELING REQUEST..."];
    if ([self.exchange isKindOfClass:[EVRequest class]]) {
        EVRequest *request = (EVRequest *)self.exchange;
        [request cancelWithSuccess:^{
            
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
            [EVStatusBarManager sharedManager].duringSuccess = ^(void) {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                    [[EVCIA sharedInstance] reloadPendingExchangesWithCompletion:^(NSArray *exchanges) {
                    }];
                }];
            };
        } failure:^(NSError *error) {
            [self handleFailure];
        }];
    }
}

- (void)prepareForRequestWithText:(NSString *)text {
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.cell disableAllButtons];
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:text];    
}

- (void)handleFailure {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [self.cell enableAllButtons];
}

#pragma mark - TableView DataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.exchange.loading)
        return 0;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [EVPendingDetailCell cellHeightForStory:[EVStory storyFromPendingExchange:self.exchange]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVPendingDetailCell *cell = self.cell;
    cell.story = [EVStory storyFromPendingExchange:self.exchange];
    NSString *amountString = [EVStringUtility amountStringForAmount:self.exchange.amount];
    [cell.confirmButton setTitle:[NSString stringWithFormat:@"PAY %@", amountString] forState:UIControlStateNormal];
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
