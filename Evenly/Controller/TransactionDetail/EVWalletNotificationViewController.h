//
//  EVWalletNotificationViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 8/2/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVModalViewController.h"
#import "EVWalletNotification.h"

@interface EVWalletNotificationViewController : EVModalViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EVWalletNotification *walletNotification;

- (id)initWithWalletNotification:(EVWalletNotification *)walletNotification;
- (void)sendConfirmationEmail:(id)sender;

@end
