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

@interface EVExchangeViewController : EVViewController

@property (nonatomic, strong) EVExchange *exchange;

- (void)loadFormView;
- (void)completeExchangePress:(id)sender;

@end
