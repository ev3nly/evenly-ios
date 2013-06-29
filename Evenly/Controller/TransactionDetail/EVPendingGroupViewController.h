//
//  EVPendingGroupViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVModalViewController.h"
#import "EVGroupRequest.h"

@interface EVPendingGroupViewController : EVModalViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EVGroupRequest *groupRequest;

- (id)initWithGroupRequest:(EVGroupRequest *)request;

- (void)payInFull;
- (void)payPartial;

@end
