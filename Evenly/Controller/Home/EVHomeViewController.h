//
//  EVHomeViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"

@class EVFloatingButton;

@interface EVHomeViewController : EVViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *floatingView;
@property (nonatomic, strong) EVFloatingButton *requestButton;
@property (nonatomic, strong) EVFloatingButton *payButton;

@end
