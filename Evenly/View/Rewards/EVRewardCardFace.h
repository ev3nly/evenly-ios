//
//  EVRewardCardFace.h
//  Evenly
//
//  Created by Joseph Hankin on 8/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVThrobber.h"

@interface EVRewardCardFace : UIView

@property (nonatomic, strong) NSDecimalNumber *rewardAmount;

@property (nonatomic, readonly, getter = isAnimating) BOOL animating;

@property (nonatomic, strong) EVThrobber *throbber;

@property (nonatomic, strong) UIView *contentContainer;

@property (nonatomic, strong) UIImageView *logo;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *leftStripe;
@property (nonatomic, strong) UIView *rightStripe;

- (id)initWithFrame:(CGRect)frame color:(UIColor *)color;

- (void)startAnimating;
- (void)stopAnimating;

- (void)setRewardAmount:(NSDecimalNumber *)rewardAmount animated:(BOOL)animated completion:(void (^)(void))completion;

@end
