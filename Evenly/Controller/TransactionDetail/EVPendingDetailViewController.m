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
#import "EVCharge.h"
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
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [EVColor creamColor];
    [self.tableView registerClass:[EVPendingDetailCell class] forCellReuseIdentifier:@"pendingDetailCell"];
    [self.view addSubview:self.tableView];
}

#pragma mark - Take Action

- (void)confirmCharge {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"SENDING PAYMENT..."];
    
    if ([self.exchange isKindOfClass:[EVCharge class]]) {
        EVCharge *charge = (EVCharge *)self.exchange;
        [charge completeWithSuccess:^{
            
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
            [EVStatusBarManager sharedManager].completion = ^(void) {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                    [[EVCIA sharedInstance] reloadAllExchangesWithCompletion:^{
                    }];
                }];
            };
        } failure:^(NSError *error) {
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
            DLog(@"failed to complete charge");
        }];
    }
}

- (void)denyCharge {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"DENYING PAYMENT..."];

    if ([self.exchange isKindOfClass:[EVCharge class]]) {
        EVCharge *charge = (EVCharge *)self.exchange;
        [charge denyWithSuccess:^{
            
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
            [EVStatusBarManager sharedManager].completion = ^(void) {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                    [[EVCIA sharedInstance] reloadAllExchangesWithCompletion:^{
                    }];
                }];
            };
        } failure:^(NSError *error) {
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
            DLog(@"failed to complete charge");
        }];
    }
}

- (void)remindCharge {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"REMINDING..."];
    
    if ([self.exchange isKindOfClass:[EVCharge class]]) {
        EVCharge *charge = (EVCharge *)self.exchange;
        [charge remindWithSuccess:^{
            
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
            [EVStatusBarManager sharedManager].completion = ^(void) {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                    [[EVCIA sharedInstance] reloadAllExchangesWithCompletion:^{
                    }];
                }];
            };
        } failure:^(NSError *error) {
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
            DLog(@"failed to remind charge");
        }];
    }
}

- (void)cancelCharge {
    [self denyCharge];
    return;
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"CANCELING PAYMENT..."];
    
    if ([self.exchange isKindOfClass:[EVCharge class]]) {
        EVCharge *charge = (EVCharge *)self.exchange;
        [charge cancelWithSuccess:^{
            
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
            [EVStatusBarManager sharedManager].completion = ^(void) {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                    [[EVCIA sharedInstance] reloadAllExchangesWithCompletion:^{
                    }];
                }];
            };
        } failure:^(NSError *error) {
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
            DLog(@"failed to cancel charge");
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
