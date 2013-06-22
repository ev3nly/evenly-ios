//
//  EVTransactionDetailViewController.h
//  Evenly
//
//  Created by Justin Brunet on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"
#import "EVTransactionDetailCell.h"

@class EVStory;

@interface EVTransactionDetailViewController : EVViewController <UITableViewDataSource, UITableViewDelegate, EVTransactionDetailCellDelegate>

@property (nonatomic, strong) EVStory *story;
@property (nonatomic, strong) UITableView *tableView;

- (id)initWithStory:(EVStory *)story;
- (void)avatarTappedForUser:(EVUser *)user;

@end
