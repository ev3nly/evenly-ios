//
//  EVPendingDetailViewController.h
//  Evenly
//
//  Created by Justin Brunet on 6/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVModalViewController.h"
#import "EVExchange.h"

@interface EVPendingDetailViewController : EVModalViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EVExchange *exchange;

- (id)initWithExchange:(EVExchange *)exchange;
- (void)confirmCharge;
- (void)denyCharge;

@end
