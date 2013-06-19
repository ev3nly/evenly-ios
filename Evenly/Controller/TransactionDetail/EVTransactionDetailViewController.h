//
//  EVTransactionDetailViewController.h
//  Evenly
//
//  Created by Justin Brunet on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"

@class EVStory;

@interface EVTransactionDetailViewController : EVViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) EVStory *story;
@property (nonatomic, strong) UITableView *tableView;

- (id)initWithStory:(EVStory *)story;

@end
