//
//  EVRewardsGameViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 7/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"
#import "EVReward.h"
#import "TTTAttributedLabel.h"

@class EVNavigationBarButton;

@interface EVRewardsGameViewController : EVViewController <TTTAttributedLabelDelegate>

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) EVNavigationBarButton *doneButton;

- (id)initWithReward:(EVReward *)reward;
- (void)didSelectOptionAtIndex:(NSInteger)index;

@end
