//
//  UIView+EVAdditions.m
//  TCTouch
//
//  Created by Joe Hankin on 3/27/12.
//  Copyright (c) 2012 Blackboard. All rights reserved.
//

#import "UIView+EVAdditions.h"
#import "NSArray+EVAdditions.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (EVAdditions)

- (void)setOrigin:(CGPoint)inOrigin {
	[self setFrame:CGRectMake(inOrigin.x, inOrigin.y, self.frame.size.width, self.frame.size.height)];
}

- (void)setSize:(CGSize)inSize {
	[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, inSize.width, inSize.height)];
}

- (void)align {
	[self setFrame:CGRectMake((int)self.frame.origin.x,
                              (int)self.frame.origin.y,
                              (int)self.frame.size.width,
                              (int)self.frame.size.height)];
}

- (void)removeAllSubviews {
	for (UIView *tmpView in [self subviews]) {
		[tmpView removeFromSuperview];
	}
}

- (void)comeToFront {
    [self.superview bringSubviewToFront:self];
}

- (UIViewController *)viewController {
	for (UIView *next = [self superview]; next; next = next.superview) {
		UIResponder *nextResponder = [next nextResponder];
		if ([nextResponder isKindOfClass:[UIViewController class]]) {
			return (UIViewController *)nextResponder;
		}
	}
	return nil;
}

- (void)logSuperviews {
    NSLog(@"SUPERVIEWS OF %@:", self);
    NSMutableArray *array = [NSMutableArray array];
    UIView *view = self;
    while ((view = [view superview])) {
        [array addObject:view];
    }
    
    [array reverse];
    int i = 0;
    NSString *spacer = @"|\t";
    for (view in array) {
        NSString *logString = @"";
        for (int j = 0; j < i; j++) {
            logString = [logString stringByAppendingString:spacer];
        }
        logString = [logString stringByAppendingString:[view description]];
        NSLog(@"%@", logString);
        i++;
    }
}

- (BOOL)findAndResignFirstResponder {
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;
    }
    for (UIView *subView in self.subviews) {
        if ([subView findAndResignFirstResponder])
            return YES;
    }
    return NO;
}

- (UIView *)currentFirstResponder {
    if (self.isFirstResponder)
        return self;
    for (UIView *subview in self.subviews) {
        if ([subview currentFirstResponder])
            return [subview currentFirstResponder];
    }
    return nil;
}

- (void)removeGestureRecognizers {
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers)
        [self removeGestureRecognizer:recognizer];
}

#pragma mark - Animations

- (void)rotateContinuouslyWithDuration:(float)duration {
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#define BOUNCE_OVERSHOOT_DISTANCE_PERCENT 0.2
#define BOUNCE_OVERSHOOT_DURATION_PERCENT 0.65
#define BOUNCE_MINIMUM_CHANGE 10

- (void)bounceAnimationToFrame:(CGRect)targetFrame duration:(float)duration completion:(void (^)(void))completion {
    [self bounceAnimationToFrame:targetFrame
                 initialDuration:duration
                 durationDamping:BOUNCE_OVERSHOOT_DURATION_PERCENT
                 distanceDamping:BOUNCE_OVERSHOOT_DISTANCE_PERCENT
                      completion:completion];
}

- (void)bounceAnimationToFrame:(CGRect)targetFrame
               initialDuration:(float)duration
               durationDamping:(float)durationDamping
               distanceDamping:(float)distanceDamping
                    completion:(void (^)(void))completion {
    CGPoint currentOrigin = self.frame.origin;
    float overshootXAmount = fabsf(targetFrame.origin.x - currentOrigin.x) + (fabsf(targetFrame.origin.x - currentOrigin.x)*distanceDamping);
    float overshootYAmount = fabsf(targetFrame.origin.y - currentOrigin.y) + (fabsf(targetFrame.origin.y - currentOrigin.y)*distanceDamping);
    
    if (overshootXAmount < BOUNCE_MINIMUM_CHANGE && overshootYAmount < BOUNCE_MINIMUM_CHANGE) {
        [UIView animateWithDuration:duration
                         animations:^{
                             self.frame = targetFrame;
                         } completion:^(BOOL finished) {
                             if (completion)
                                 completion();
                         }];
        return;
    }
    
    if (targetFrame.origin.x < currentOrigin.x)
        overshootXAmount = -overshootXAmount;
    if (targetFrame.origin.y < currentOrigin.y)
        overshootYAmount = -overshootYAmount;
    
    CGRect overshootFrame = targetFrame;
    overshootFrame.origin.x = currentOrigin.x + overshootXAmount;
    overshootFrame.origin.y = currentOrigin.y + overshootYAmount;
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = overshootFrame;
                     } completion:^(BOOL finished) {
                         [self bounceAnimationToFrame:targetFrame
                                             duration:(duration * durationDamping)
                                           completion:^{
                                               if (completion)
                                                   completion();
                                           }];
                     }];
}

#define ZOOM_OVERSHOOT_SCALE 1.3
#define ZOOM_SMALL_SCALE 0.2
#define ZOOM_OVERSHOOT_DURATION_PERCENT 0.2

- (void)zoomBounceWithDuration:(float)duration completion:(void (^)(void))completion {
    self.transform = CGAffineTransformMakeScale(ZOOM_SMALL_SCALE, ZOOM_SMALL_SCALE);
    self.alpha = 0;
    [UIView animateWithDuration:(1.0-ZOOM_OVERSHOOT_DURATION_PERCENT)*duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(ZOOM_OVERSHOOT_SCALE, ZOOM_OVERSHOOT_SCALE);
                         self.alpha = 1;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:ZOOM_OVERSHOOT_DURATION_PERCENT*duration
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              self.transform = CGAffineTransformIdentity;
                                          } completion:^(BOOL finished) {
                                              if (completion)
                                                  completion();
                                          }];
                     }];
}

- (void)shrinkBounceWithDuration:(float)duration completion:(void (^)(void))completion {
    self.alpha = 1;
    [UIView animateWithDuration:ZOOM_OVERSHOOT_DURATION_PERCENT*duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(ZOOM_OVERSHOOT_SCALE, ZOOM_OVERSHOOT_SCALE);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:(1.0-ZOOM_OVERSHOOT_DURATION_PERCENT)*duration
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              self.transform = CGAffineTransformMakeScale(ZOOM_SMALL_SCALE, ZOOM_SMALL_SCALE);
                                               self.alpha = 0;
                                          } completion:^(BOOL finished) {
                                              if (completion)
                                                  completion();
                                          }];
                     }];
}

- (void)pulseFromAlpha:(float)fromAlpha toAlpha:(float)toAlpha duration:(float)duration {
    self.alpha = fromAlpha;
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{
                         self.alpha = toAlpha;
                     } completion:nil];
}

static char UIViewUserInfoKey;

- (void)setUserInfo:(NSDictionary *)userInfo {
    objc_setAssociatedObject(self,
                             &UIViewUserInfoKey,
                             userInfo,
                             OBJC_ASSOCIATION_RETAIN);
}

- (NSDictionary *)userInfo {
    return objc_getAssociatedObject(self, &UIViewUserInfoKey);
}


@end
