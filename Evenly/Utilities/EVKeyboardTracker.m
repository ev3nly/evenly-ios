//
//  EVKeyboardTracker.m
//  Evenly
//
//  Created by Joseph Hankin on 4/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVKeyboardTracker.h"

@implementation EVKeyboardTracker

#pragma mark Singleton

+ (instancetype)sharedTracker
{
    static EVKeyboardTracker *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        _keyboardFrame = CGRectNull;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidChangeFrame:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];
}

- (BOOL)keyboardIsShowing {
    return !(CGRectEqualToRect(_keyboardFrame, CGRectNull));
}

#pragma mark Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
}

- (void)keyboardDidShow:(NSNotification *)notification {
    CGRect keyboardFrame = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardFrame = [self adjustScreenBasedRect:keyboardFrame forInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
}

- (void)keyboardDidHide:(NSNotification *)notification {
    _keyboardFrame = CGRectNull;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification {
    CGRect keyboardFrame = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardFrame = [self adjustScreenBasedRect:keyboardFrame forInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

#pragma mark Helper Methods

- (UIWindow *)mainWindow {
    return [[[UIApplication sharedApplication] delegate] window];
}

- (CGRect)adjustScreenBasedRect:(CGRect)rect forInterfaceOrientation:(UIInterfaceOrientation)orientation {
    UIWindow *mainWindow = [self mainWindow];
    CGRect unrotatedWindowRect = [mainWindow convertRect:rect fromWindow:nil];
    CGRect newRect = CGRectZero;
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            newRect.size.width = unrotatedWindowRect.size.height;
            newRect.size.height = unrotatedWindowRect.size.width;
            newRect.origin.x = 0.0f;
            newRect.origin.y = applicationFrame.size.width - newRect.size.height;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            newRect.size.width = unrotatedWindowRect.size.width;
            newRect.size.height = unrotatedWindowRect.size.height;
            newRect.origin.x = 0.0f;
            newRect.origin.y = applicationFrame.size.height - newRect.size.height;
            break;
        case UIInterfaceOrientationPortrait:
            newRect = unrotatedWindowRect;
            newRect.origin.y = applicationFrame.size.height - newRect.size.height;
            break;
        default:
            break;
    }
    return newRect;
}

@end
