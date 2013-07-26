//
//  EVRewardsSlider.h
//  Evenly
//
//  Created by Joseph Hankin on 7/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVRewardsSliderBackground.h"

extern NSString *const EVRewardsSliderPanBeganNotification;
extern NSString *const EVRewardsSliderPanEndedNotification;
extern NSString *const EVRewardsSliderSwipeBeganNotification;
extern NSString *const EVRewardsSliderSwipeEndedNotification;

@interface EVRewardsSlider : UIControl<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *foregroundView;

@property (nonatomic, strong) UILabel *label;
@property (nonatomic) EVRewardsSliderColor sliderColor;
@property (nonatomic, strong) UIView *arrowContainer;
@property (nonatomic, strong) NSArray *arrows;

@property (nonatomic, strong) EVRewardsSliderBackground *backgroundView;
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic, strong) NSDecimalNumber *rewardAmount;

@property (nonatomic) BOOL animationEnabled;

- (id)initWithFrame:(CGRect)frame sliderColor:(EVRewardsSliderColor)color;

- (void)makeAnAppearanceWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion;
- (void)pulse;
- (void)setRewardAmount:(NSDecimalNumber *)rewardAmount animated:(BOOL)animated;

@end
