//
//  EVRewardCard.h
//  Evenly
//
//  Created by Joseph Hankin on 8/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EVRewardCardBack.h"
#import "EVRewardCardFace.h"

@interface EVRewardCard : UIControl

@property (nonatomic, strong) EVRewardCardBack *back;
@property (nonatomic, strong) EVRewardCardFace *face;

@property (nonatomic, strong) UIColor *color;
@property (nonatomic) BOOL animationEnabled;

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

- (id)initWithFrame:(CGRect)frame text:(NSString *)text color:(UIColor *)color;

- (void)flip;
- (void)setRewardAmount:(NSDecimalNumber *)rewardAmount animated:(BOOL)animated;

@end
