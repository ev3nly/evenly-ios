//
//  EVSession.h
//  Evenly
//
//  Created by Sean Yu on 4/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVObject.h"

extern NSString *const EVSessionUserExplicitlySignedOutNotification;

@interface EVSession : EVObject

@property (nonatomic, strong) NSString *authenticationToken;

+ (EVSession *)sharedSession;
+ (void)setSharedSession:(EVSession *)session;

+ (void)createWithEmail:(NSString *)email
               password:(NSString *)password
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *error))failure;

+ (void)signOutWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure;

@end
