//
//  EVRewardsSlider.h
//  Evenly
//
//  Created by Joseph Hankin on 7/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVRewardsSlider : UIControl<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *foregroundView;

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIColor *foregroundColor;
@property (nonatomic, strong) UIView *arrowContainer;
@property (nonatomic, strong) NSArray *arrows;

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic, strong) NSDecimalNumber *rewardAmount;

- (void)makeAnAppearanceWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion;
- (void)pulse;

@end
