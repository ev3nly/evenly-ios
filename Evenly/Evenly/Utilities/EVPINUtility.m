//
//  EVPINUtility.m
//  Evenly
//
//  Created by Joseph Hankin on 4/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPINUtility.h"
#import "KeychainItemWrapper.h"
#import "EVSession.h"

NSString *const EVPINUtilityTooManyFailedAttemptsNotification = @"EVPINUtilityTooManyFailedAttemptsNotification";

static NSString *const kIvyPINKeychainItemName = @"Ivy PIN";

static EVPINUtility *_sharedUtility;
static int _failedPINAttemptCount;

@interface EVPINUtility ()

@property (nonatomic, strong) KeychainItemWrapper *keychainItem;
@property (nonatomic, readonly) NSString *pin;

@end

@implementation EVPINUtility

+ (instancetype)sharedUtility {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUtility = [[EVPINUtility alloc] init];
        _failedPINAttemptCount = 0;
    });
    return _sharedUtility;
}

- (id)init {
    self = [super init];
    if (self) {
        self.keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:kIvyPINKeychainItemName accessGroup:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userExplicitlySignedOut:)
                                                     name:EVSessionUserExplicitlySignedOutNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)userExplicitlySignedOut:(NSNotification *)notification {
    [self clearStoredPIN];
}

- (void)setPIN:(NSString *)pin {
    [self.keychainItem setObject:pin forKey:(__bridge id)kSecValueData];
}

- (NSString *)pin {
    return [self.keychainItem objectForKey:(__bridge id)kSecValueData];
}

- (BOOL)isValidPIN:(NSString *)pin {
    NSString *savedPin = [self pin];
    BOOL isValid = [pin isEqualToString:savedPin];
    if (!isValid)
        _failedPINAttemptCount++;
    else
        _failedPINAttemptCount = 0;

    if (_failedPINAttemptCount == EV_MAX_PIN_ATTEMPTS) {
        [self clearStoredPIN];
        [[NSNotificationCenter defaultCenter] postNotificationName:EVPINUtilityTooManyFailedAttemptsNotification object:nil];
    }
    
    return isValid;
}

- (BOOL)pinIsSet {
    return !EV_IS_EMPTY_STRING([self pin]);
}

- (int)failedPINAttemptCount {
    return _failedPINAttemptCount;
}

- (void)clearStoredPIN {
    [self.keychainItem resetKeychainItem];
}

@end
