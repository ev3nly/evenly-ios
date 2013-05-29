//
//  EVKeyboardTracker.h
//  Evenly
//
//  Created by Joseph Hankin on 4/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVKeyboardTracker : NSObject

+ (instancetype)sharedTracker;

@property (nonatomic, readonly) CGRect keyboardFrame;
@property (nonatomic, readonly) BOOL keyboardIsShowing;

- (void)registerForNotifications;

@end
