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

@end
