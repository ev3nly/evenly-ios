//
//  EVPushPopViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"

@interface EVPushPopViewController : EVViewController

@property (nonatomic, strong) NSMutableArray *viewStack;

- (void)pushView:(UIView *)incomingView animated:(BOOL)animated;
- (void)popViewAnimated:(BOOL)animated;

@end
