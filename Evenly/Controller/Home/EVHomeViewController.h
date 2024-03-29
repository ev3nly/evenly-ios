//
//  EVHomeViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"
#import "EVNewsfeedDataSource.h"

@class EVFloatingButton;

@interface EVHomeViewController : EVViewController <UITableViewDelegate>

@property (nonatomic, strong) EVNewsfeedDataSource *newsfeedDataSource;

@property (nonatomic, strong) UIView *floatingView;
@property (nonatomic, strong) EVFloatingButton *requestButton;
@property (nonatomic, strong) EVFloatingButton *payButton;

@end
