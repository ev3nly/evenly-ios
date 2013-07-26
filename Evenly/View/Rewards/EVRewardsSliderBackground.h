//
//  EVRewardsSliderBackground.h
//  Evenly
//
//  Created by Joseph Hankin on 7/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVRewardsCardAmountView.h"

@interface EVRewardsSliderBackground : UIView

@property (nonatomic, strong) NSArray *logos;
@property (nonatomic, readonly, getter = isAnimating) BOOL animating;
@property (nonatomic, strong) NSDecimalNumber *rewardAmount;
@property (nonatomic, strong) EVRewardsCardAmountView *rewardCard;

//@property (nonatomic, strong) UILabel *rewardAmountLabel;

- (id)initWithFrame:(CGRect)frame sliderColor:(EVRewardsSliderColor)color;

- (void)startAnimating;
- (void)stopAnimating;

- (void)setRewardAmount:(NSDecimalNumber *)rewardAmount animated:(BOOL)animated;
@end
