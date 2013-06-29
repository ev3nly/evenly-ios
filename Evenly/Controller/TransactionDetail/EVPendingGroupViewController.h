//
//  EVPendingGroupViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVModalViewController.h"
#import "EVGroupRequest.h"

#import "EVPartialPaymentViewController.h"

@interface EVPendingGroupViewController : EVModalViewController <UITableViewDataSource, UITableViewDelegate, EVPartialPaymentViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EVGroupRequest *groupRequest;

- (id)initWithGroupRequest:(EVGroupRequest *)request;

- (void)payInFullButtonPress:(id)sender;
- (void)payPartialButtonPress:(id)sender;

@end
