//
//  EVViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVViewController : UIViewController

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;

- (void)loadTitleLabel;
- (void)backButtonPress:(id)sender;

@end
