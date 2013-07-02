//
//  EVGroupRequestEditViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/26/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"
#import "EVGroupRequest.h"

@class EVGroupRequestEditViewController;

@protocol EVGroupRequestEditViewControllerDelegate <NSObject>

- (void)editViewControllerMadeChanges:(EVGroupRequestEditViewController *)editViewController;

@end

@interface EVGroupRequestEditViewController : EVViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<EVGroupRequestEditViewControllerDelegate> delegate;
@property (nonatomic, strong) EVGroupRequest *groupRequest;
@property (nonatomic, strong) UITableView *tableView;

- (id)initWithGroupRequest:(EVGroupRequest *)groupRequest;

@end
