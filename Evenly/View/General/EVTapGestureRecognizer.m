//
//  EVTapGestureRecognizer.m
//  Evenly
//
//  Created by Justin Brunet on 6/13/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVTapGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface EVTapGestureRecognizer ()

@property (nonatomic, assign) BOOL withinView;

- (BOOL)viewContainsTouch:(UITouch *)touch;

@end

@implementation EVTapGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.state == UIGestureRecognizerStatePossible)
        self.state = UIGestureRecognizerStateBegan;
    NSLog(@"began");
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.state = UIGestureRecognizerStateChanged;
    self.withinView = [self viewContainsTouch:[touches anyObject]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.withinView = [self viewContainsTouch:[touches anyObject]];
    if ([self isWithinView])
        self.state = UIGestureRecognizerStateEnded;
    else
        self.state = UIGestureRecognizerStateCancelled;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.state = UIGestureRecognizerStateCancelled;
}

#pragma mark - Utility

- (BOOL)viewContainsTouch:(UITouch *)touch {
    return CGRectContainsPoint(self.view.bounds, [touch locationInView:self.view]);
}

- (BOOL)isWithinView {
    return self.withinView;
}

@end
