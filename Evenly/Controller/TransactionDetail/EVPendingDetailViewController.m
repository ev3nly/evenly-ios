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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([self.exchange isKindOfClass:[EVCharge class]]) {
        EVCharge *charge = (EVCharge *)self.exchange;
        [charge completeWithSuccess:^{
            
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"Success!";
            
            EV_DISPATCH_AFTER(1.0, ^(void){
                [hud hide:YES];
                [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                    [[EVCIA sharedInstance] reloadAllExchangesWithCompletion:^{
                        
                    }];
                }];
            });
        } failure:^(NSError *error) {
            [hud hide:YES];
            DLog(@"failed to complete charge");
        }];
    }
}

- (void)denyCharge {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    if ([self.exchange isKindOfClass:[EVCharge class]]) {
        EVCharge *charge = (EVCharge *)self.exchange;
        [charge denyWithSuccess:^{
            
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"Success!";
            
            EV_DISPATCH_AFTER(1.0, ^(void){
                [hud hide:YES];
                [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                    [[EVCIA sharedInstance] reloadAllExchangesWithCompletion:^{
                        
                    }];
                }];
            });
        } failure:^(NSError *error) {
            [hud hide:YES];
            DLog(@"failed to complete charge");
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
