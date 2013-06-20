//
//  EVPendingDetailViewController.h
//  Evenly
//
//  Created by Justin Brunet on 6/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVModalViewController.h"
#import "EVStory.h"

@interface EVPendingDetailViewController : EVModalViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EVStory *story;

- (id)initWithStory:(EVStory *)story;

@end
