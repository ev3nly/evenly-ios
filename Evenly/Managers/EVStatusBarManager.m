//
//  EVStatusBarManager.m
//  Evenly
//
//  Created by Justin Brunet on 6/21/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVStatusBarManager.h"
#import "EVNavigationManager.h"
#import "AMBlurView.h"
#import <QuartzCore/QuartzCore.h>

#define DEFAULT_IN_PROGRESS_TEXT @"SAVING.."
#define DEFAULT_SUCCESS_TEXT @"SUCCESS!"
#define DEFAULT_FAILURE_TEXT @"WHOOPS! SOMETHING WENT WRONG."

typedef void(^EVStatusBarManagerActionBlock)(void);

@interface EVStatusBarManager ()

@property (nonatomic, strong) EVStatusBarProgressView *progressView;
@property (nonatomic, strong) NSDate *lastStatusChange;
@property (nonatomic, strong) NSMutableArray *actionStack;

- (BOOL)mustWait;

@end

@implementation EVStatusBarManager

static EVStatusBarManager *_sharedManager = nil;

+ (EVStatusBarManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [EVStatusBarManager new];
        _sharedManager.progressView = [EVStatusBarProgressView new];
        _sharedManager.lastStatusChange = [NSDate date];
        _sharedManager.actionStack = [NSMutableArray arrayWithCapacity:0];
    });
    return _sharedManager;
}

- (void)setup {
}

- (void)setStatus:(EVStatusBarStatus)status {
    NSString *defaultText = DEFAULT_IN_PROGRESS_TEXT;
    if (status == EVStatusBarStatusSuccess)
        defaultText = DEFAULT_SUCCESS_TEXT;
    else if (status == EVStatusBarStatusFailure)
        defaultText = DEFAULT_FAILURE_TEXT;
    [self setStatus:status text:defaultText];
}

- (void)setStatus:(EVStatusBarStatus)status text:(NSString *)text {
    if (status == EVStatusBarStatusNone)
        return; //manager sets this
    EV_PERFORM_ON_MAIN_QUEUE(^{
        EVStatusBarManagerActionBlock action = [self actionForStatus:status text:text];
        
        if (status == EVStatusBarStatusInProgress) {
            [self.actionStack addObject:action];
            if ([self currentStatus] == EVStatusBarStatusNone)
                [self runStackAction];
        } else {
            if ([self currentStatus] == EVStatusBarStatusInProgress) {
                if (![self emptyStack])
                    [self.actionStack removeObjectAtIndex:0];
                [self.actionStack addObject:action];
                [self runStackAction];
            } else {
                if (![self emptyStack])
                    [self.actionStack removeObjectAtIndex:0];
            }
        }
    });
}

- (EVStatusBarManagerActionBlock)actionForStatus:(EVStatusBarStatus)status text:(NSString *)text {
    EVStatusBarManagerActionBlock action = nil;
    if (status == EVStatusBarStatusInProgress) {
        action = ^(void) {
            self.progressView.status = status;
            [self progressWithText:text];
        };
    } else if (status == EVStatusBarStatusSuccess) {
        action = ^(void) {
            self.progressView.status = status;
            [self successWithText:text];
        };
    } else if (status == EVStatusBarStatusFailure) {
        action = ^(void) {
            self.progressView.status = status;
            [self failureWithText:text];
        };
    }
    return action;
}

#pragma mark - View Modification

- (void)progressWithText:(NSString *)text {    
    CGRect originalFrame = [UIApplication sharedApplication].statusBarFrame;
    self.progressView.frame = [self startingFrame];
    [self.progressView setStatus:EVStatusBarStatusInProgress text:text];
    [self removeDropShadow];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [[UIApplication sharedApplication].keyWindow insertSubview:self.progressView atIndex:0];
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.progressView.frame = originalFrame;
                     } completion:^(BOOL finished) {
                         
                     }];
    self.lastStatusChange = [NSDate date];
}

- (void)successWithText:(NSString *)text {
    if ([self mustWait]) {
        EV_DISPATCH_AFTER(0.5, ^(void) {
            [self successWithText:text];
        });
        return;
    }
    if (self.preSuccess)
        self.preSuccess();
    self.preSuccess = nil;
    [self.progressView setStatus:EVStatusBarStatusSuccess text:text];
    [self hideProgressView];
    self.lastStatusChange = [NSDate date];
}

- (void)failureWithText:(NSString *)text {
    if ([self mustWait]) {
        EV_DISPATCH_AFTER(0.5, ^(void) {
            [self failureWithText:text];
        });
        return;
    }
    [self.progressView setStatus:EVStatusBarStatusFailure text:text];
    [self hideProgressView];
    self.lastStatusChange = [NSDate date];
}

- (void)removeDropShadow {
    for (UIView *subview in [UIApplication sharedApplication].keyWindow.subviews) {
        for (UIView *sub in subview.subviews) {
            if (!sub.hidden) {
                sub.layer.shadowOpacity = 0; //adds a stupid shadow behind the scenes. took an obnoxious amount of time to narrow this down
            }
        }
    }
}

- (void)hideProgressView {
    EV_DISPATCH_AFTER(1.0, ^ (void) {
        CGRect destinationFrame = self.progressView.frame;
        destinationFrame.origin.y += destinationFrame.size.height+10;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        if (self.duringSuccess)
            self.duringSuccess();
        self.duringSuccess = nil;
        [UIView animateWithDuration:0.4
                         animations:^{
                             self.progressView.frame = destinationFrame;
                         } completion:^(BOOL finished) {
                             [self.progressView removeFromSuperview];
                             [self runStackAction];
                             if (self.postSuccess)
                                 self.postSuccess();
                             self.postSuccess = nil;
                             [[EVNavigationManager sharedManager].masterViewController viewWillAppear:NO];
                         }];
    });
}

#pragma mark - Utility

- (void)runStackAction {
    if ([self emptyStack]) {
        self.progressView.status = EVStatusBarStatusNone;
        return;
    }
    EVStatusBarManagerActionBlock action = [self.actionStack lastObject];
    action();
    [self.actionStack removeLastObject];
}

- (BOOL)mustWait {
    return (fabs([self.lastStatusChange timeIntervalSinceNow]) < 0.5);
}

- (EVStatusBarStatus)currentStatus {
    return self.progressView.status;
}

- (BOOL)emptyStack {
    return ([self.actionStack count] == 0);
}

- (BOOL)controllersShouldHideDropShadows {
    return ([self currentStatus] != EVStatusBarStatusNone);
}

#pragma mark - Frames

- (CGRect)startingFrame {
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    statusBarFrame.origin.y += statusBarFrame.size.height+5;
    return statusBarFrame;
}

@end
