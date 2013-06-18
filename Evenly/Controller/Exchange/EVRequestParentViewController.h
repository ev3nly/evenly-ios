//
//  EVRequestParentViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVModalViewController.h"
#import "EVRequestSwitch.h"
#import "EVPrivacySelectorView.h"
#import "EVExchangeViewController.h"

@class EVRequestViewController;
@class EVGroupRequestViewController;

typedef enum {
    EVRequestTypeFriend = 0,
    EVRequestTypeGroup = 1
} EVRequestType;

@interface EVRequestParentViewController : EVModalViewController <EVSwitchDelegate>

@property (nonatomic, strong) EVRequestSwitch *requestSwitch;
@property (nonatomic, strong) EVRequestViewController *friendRequestController;
@property (nonatomic, strong) EVGroupRequestViewController *groupRequestController;
@property (nonatomic, strong) EVPrivacySelectorView *privacySelector;
@property (nonatomic, strong) EVViewController<EVExchangeCreator> *activeViewController;

- (void)setActiveViewController:(EVViewController *)viewController animated:(BOOL)animated;

@end
