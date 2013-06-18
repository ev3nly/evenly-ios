//
//  EVPushPopViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPushPopViewController.h"

@interface EVPushPopViewController ()

@end

@implementation EVPushPopViewController


#pragma mark - Pushing and Popping Views

- (void)pushView:(UIView *)incomingView animated:(BOOL)animated {
    UIView *currentView = [self.viewStack lastObject];
    [incomingView setOrigin:CGPointMake(self.view.frame.size.width, incomingView.frame.origin.y)];
    [self.view addSubview:incomingView];
    [UIView animateWithDuration:(animated ? EV_DEFAULT_ANIMATION_DURATION : 0.0) animations:^{
        [currentView setOrigin:CGPointMake(-currentView.frame.size.width, currentView.frame.origin.y)];
        [incomingView setOrigin:CGPointMake(0, incomingView.frame.origin.y)];
    } completion:^(BOOL finished) {
        [currentView removeFromSuperview];
        [self.viewStack addObject:incomingView];
    }];
}

- (void)popViewAnimated:(BOOL)animated {
    if ([self.viewStack count] <= 1)
        return;
    
    UIView *currentView = [self.viewStack lastObject];
    UIView *previousView = [self.viewStack objectAtIndex:[self.viewStack count] - 2];
    [previousView setOrigin:CGPointMake(-previousView.frame.size.width, previousView.frame.origin.y)];
    [self.view addSubview:previousView];
    [UIView animateWithDuration:(animated ? EV_DEFAULT_ANIMATION_DURATION : 0.0) animations:^{
        [currentView setOrigin:CGPointMake(self.view.frame.size.width, currentView.frame.origin.y)];
        [previousView setOrigin:CGPointMake(0, previousView.frame.origin.y)];
    } completion:^(BOOL finished) {
        [currentView removeFromSuperview];
        [self.viewStack removeLastObject];
    }];
}

@end
