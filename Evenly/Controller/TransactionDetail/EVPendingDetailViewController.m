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

@interface EVPendingDetailViewController ()

@end

@implementation EVPendingDetailViewController

#pragma mark - Lifecycle

- (id)initWithExchange:(EVExchange *)exchange {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.exchange = exchange;
        self.title = @"Transaction";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadTableView];
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
}

#pragma mark - Take Action

- (void)confirmRequest {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"SENDING PAYMENT..."];
    
    if ([self.exchange isKindOfClass:[EVRequest class]]) {
        EVRequest *request = (EVRequest *)self.exchange;
        [request completeWithSuccess:^{
            [[EVCIA me] setBalance:[[[EVCIA me] balance] decimalNumberBySubtracting:self.exchange.amount]];
            [[EVCIA sharedInstance] reloadPendingSentExchangesWithCompletion:NULL];
            
            EVStory *story = [EVStory storyFromCompletedExchange:self.exchange];
            story.publishedAt = [NSDate date];
            [[NSNotificationCenter defaultCenter] postNotificationName:EVStoryLocallyCreatedNotification
                                                                object:nil
                                                              userInfo:@{ @"story" : story }];
            
            
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
            [EVStatusBarManager sharedManager].duringSuccess = ^(void) {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                    [[EVCIA sharedInstance] reloadPendingExchangesWithCompletion:^(NSArray *exchanges) {
                        
                    }];
                }];
            };
        } failure:^(NSError *error) {
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
            DLog(@"failed to complete request");
        }];
    }
}

- (void)denyRequest {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"DENYING PAYMENT..."];

    if ([self.exchange isKindOfClass:[EVRequest class]]) {
        EVRequest *request = (EVRequest *)self.exchange;
        [request denyWithSuccess:^{
            
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
            [EVStatusBarManager sharedManager].duringSuccess = ^(void) {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                    [[EVCIA sharedInstance] reloadPendingExchangesWithCompletion:^(NSArray *exchanges) {
                    }];
                }];
            };
        } failure:^(NSError *error) {
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
            DLog(@"failed to complete request");
        }];
    }
}

- (void)remindRequest {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"REMINDING..."];
    
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
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
            DLog(@"failed to remind request");
        }];
    }
}

- (void)cancelRequest {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"CANCELING PAYMENT..."];
    
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
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
            DLog(@"failed to cancel request");
        }];
    }
}

#pragma mark - TableView DataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [EVPendingDetailCell cellHeightForStory:[EVStory storyFromPendingExchange:self.exchange]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVPendingDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pendingDetailCell" forIndexPath:indexPath];
    cell.story = [EVStory storyFromPendingExchange:self.exchange];
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
