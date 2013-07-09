//
//  UIView+EVAdditions.m
//  TCTouch
//
//  Created by Joe Hankin on 3/27/12.
//  Copyright (c) 2012 Blackboard. All rights reserved.
//

#import "UIView+EVAdditions.h"
#import "NSArray+EVAdditions.h"

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

#define BOUNCE_OVERSHOOT_DISTANCE_PERCENT 0.1
#define BOUNCE_OVERSHOOT_DURATION_PERCENT 0.3

- (void)bounceAnimationToFrame:(CGRect)targetFrame duration:(float)duration completion:(void (^)(void))completion {
    CGPoint currentOrigin = self.frame.origin;
    float overshootXAmount = fabsf(targetFrame.origin.x - currentOrigin.x) + (fabsf(targetFrame.origin.x - currentOrigin.x)*BOUNCE_OVERSHOOT_DISTANCE_PERCENT);
    float overshootYAmount = fabsf(targetFrame.origin.y - currentOrigin.y) + (fabsf(targetFrame.origin.y - currentOrigin.y)*BOUNCE_OVERSHOOT_DISTANCE_PERCENT);
    
    if (targetFrame.origin.x < currentOrigin.x)
        overshootXAmount = -overshootXAmount;
    if (targetFrame.origin.y < currentOrigin.y)
        overshootYAmount = - overshootYAmount;
    
    CGRect overshootFrame = targetFrame;
    overshootFrame.origin.x = currentOrigin.x + overshootXAmount;
    overshootFrame.origin.y = currentOrigin.y + overshootYAmount;
    
    [UIView animateWithDuration:(duration * (1.0-BOUNCE_OVERSHOOT_DURATION_PERCENT))
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.frame = overshootFrame;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:(duration * BOUNCE_OVERSHOOT_DURATION_PERCENT)
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              self.frame = targetFrame;
                                          } completion:^(BOOL finished) {
                                              if (completion)
                                                  completion();
                                          }];
                     }];
}

@end
