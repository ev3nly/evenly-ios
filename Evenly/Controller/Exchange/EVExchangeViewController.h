//
//  EVExchangeViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"
#import "EVExchange.h"
#import "ReactiveCocoa.h"

@interface EVExchangeViewController : EVViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) EVExchange *exchange;
@property (nonatomic, strong) NSArray *suggestions;
@property (nonatomic, strong) UITableView *suggestionsTableView;

- (void)loadFormView;
- (void)completeExchangePress:(id)sender;

@end
