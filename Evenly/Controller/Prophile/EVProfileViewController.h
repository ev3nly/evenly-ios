//
//  EVProfileViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"
#import "EVUser.h"

@interface EVProfileViewController : EVViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EVUser *user;
@property (nonatomic, strong) NSArray *timeline;

- (id)initWithUser:(EVUser *)user;

@end
