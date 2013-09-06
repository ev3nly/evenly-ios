//
//  EVViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EV_VIEW_CONTROLLER_BAR_BUTTON_HEIGHT 44
#define EV_VIEW_CONTROLLER_BAR_BUTTON_IMAGE_INSET UIEdgeInsetsMake(1, 10, -1, 10)

@protocol EVReloadable <NSObject>

@property (nonatomic, getter = isLoading) BOOL loading;
- (void)reload;

@end

@interface EVViewController : UIViewController

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;

@property (nonatomic, assign) BOOL shouldDismissGrandparent;

- (float)totalBarHeight;

- (void)loadTitleLabel;
- (void)backButtonPress:(id)sender;

- (UIButton *)defaultCancelButton;
- (void)loadWalletBarButtonItem;
- (void)loadStatusBarBackground;

- (void)cancelButtonPress:(id)sender;

@end
