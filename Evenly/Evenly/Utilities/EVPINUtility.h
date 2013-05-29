//
//  EVPINUtility.h
//  Evenly
//
//  Created by Joseph Hankin on 4/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

#define EV_MAX_PIN_ATTEMPTS 5

extern NSString *const EVPINUtilityTooManyFailedAttemptsNotification;

@interface EVPINUtility : NSObject

+ (instancetype)sharedUtility;

- (void)setPIN:(NSString *)pin;
- (BOOL)pinIsSet;
- (int)failedPINAttemptCount;
- (BOOL)isValidPIN:(NSString *)pin;
- (void)clearStoredPIN;

@end
