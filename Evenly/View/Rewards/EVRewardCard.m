//
//  EVRewardCard.m
//  Evenly
//
//  Created by Joseph Hankin on 8/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRewardCard.h"

@implementation EVRewardCard

- (id)initWithFrame:(CGRect)frame text:(NSString *)text color:(UIColor *)color {
    self = [self initWithFrame:frame];
    if (self) {
        _text = text;
        self.animationEnabled = YES;
        
        self.autoresizesSubviews = YES;
        
        self.back = [[EVRewardCardBack alloc] initWithFrame:self.bounds text:text color:color];
        self.back.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        [self addSubview:self.back];
        
        self.face = [[EVRewardCardFace alloc] initWithFrame:self.bounds color:color];
        self.face.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        
        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
        [self addGestureRecognizer:self.tapRecognizer];
    }
    return self;
}

- (void)tapRecognized:(UITapGestureRecognizer *)recognizer {
    if (self.animationEnabled)
        [self.face startAnimating];
    [self flip];
}

- (void)flip {
    UIView *from, *to;
    UIViewAnimationOptions transition;
    if (self.back.superview)
    {
        from = self.back;
        to = self.face;
        transition = UIViewAnimationOptionTransitionFlipFromBottom;
    }
    else
    {
        from = self.face;
        to = self.back;
        transition = UIViewAnimationOptionTransitionFlipFromTop;
    }
    [UIView transitionFromView:from
                        toView:to
                      duration:0.5
                       options:transition | UIViewAnimationOptionAllowAnimatedContent
                    completion:^(BOOL finished) {
                        
                    }];
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)pulse {
    [self.back pulseToScale:1.15 duration:EV_DEFAULT_ANIMATION_DURATION];
}

- (void)setRewardAmount:(NSDecimalNumber *)rewardAmount animated:(BOOL)animated completion:(void (^)(void))completion {
    [self.face setRewardAmount:rewardAmount animated:animated completion:completion];
}

@end
