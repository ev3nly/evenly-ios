//
//  EVRewardsCardAmountView.h
//  Evenly
//
//  Created by Joseph Hankin on 7/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EV_REWARDS_CARD_AMOUNT_VIEW_WIDTH 88.0
#define EV_REWARDS_CARD_AMOUNT_VIEW_HEIGHT 56.0

@interface EVRewardsCardAmountView : UIView

@property (nonatomic) EVRewardsSliderColor cardColor;

@property (nonatomic, strong) UILabel *label;

+ (instancetype)cardWithColor:(EVRewardsSliderColor)color;
+ (instancetype)cardWithColor:(EVRewardsSliderColor)color text:(NSString *)text;

+ (instancetype)greenCardWithText:(NSString *)text;
+ (instancetype)grayCardWithText:(NSString *)text;
+ (instancetype)blueCardWithText:(NSString *)text;

- (void)setText:(NSString *)text;
@end
