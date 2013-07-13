//
//  EVRewardsGameViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 7/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"
#import "EVReward.h"

@class EVNavigationBarButton;

@interface EVRewardsGameViewController : EVViewController

@property (nonatomic, strong) EVNavigationBarButton *cancelButton;
@property (nonatomic, strong) EVNavigationBarButton *doneButton;

- (id)initWithReward:(EVReward *)reward;

@end
