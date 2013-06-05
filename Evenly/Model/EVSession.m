//
//  EVSession.m
//  Evenly
//
//  Created by Sean Yu on 4/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVSession.h"
#import "EVNetworkManager.h"
#import "EVPINUtility.h"
#import "EVCIA.h"

#import "AESCrypt.h"

NSString *const EVSessionUserExplicitlySignedOutNotification = @"EVSessionUserExplicitlySignedOutNotification";

static EVSession *_sharedSession = nil;

@implementation EVSession

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedPINAttempts:) name:EVPINUtilityTooManyFailedAttemptsNotification object:nil];
    }
    return self;
}

- (void)setProperties:(NSDictionary *)properties {
    [super setProperties:properties];
    
    self.authenticationToken = [properties valueForKey:@"authentication_token"];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (NSString *)controllerName {
    return @"sessions";
}

+ (EVSession *)sharedSession
{
    return _sharedSession;
}

+ (void)setSharedSession:(EVSession *)session {
    _sharedSession = session;
    if (_sharedSession)
        [[EVNetworkManager sharedInstance].httpClient setDefaultHeader:@"Authorization" value:_sharedSession.authenticationToken];
    else
        [[EVNetworkManager sharedInstance].httpClient clearAuthorizationHeader];
}

+ (void)createWithEmail:(NSString *)email
               password:(NSString *)password
                success:(void (^)(void))success
                failure:(void (^)(NSError *error))failure
{
    NSString *key = @"9fa8uwf8ahwf982fha928fha4938hf";
    NSString *encryptedPassword = [AESCrypt encrypt:password password:key];
    
    [self createWithParams:@{@"email": email, @"password": encryptedPassword} success:^(EVObject *object){
      
        [EVSession setSharedSession:(EVSession *)object];
        if (success)
            success();
        
    } failure:failure];
}

+ (void)signOutWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    [[EVCIA sharedInstance] setSession:nil];
    [[EVCIA sharedInstance] setMe:nil];
    
    [EVUser setMe:nil];
    [EVSession setSharedSession:nil];
    if (success)
        success();
    
    [EVAnalyticsUtility trackEvent:EVAnalyticsSignedOut];
}

- (void)destroyWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    [super destroyWithSuccess:^(void){
        
        if (self == [EVSession sharedSession])
            [EVSession setSharedSession:nil];
        if (success)
            success();
        
    } failure:failure];
}

- (void)failedPINAttempts:(NSNotification *)notification {
    [self destroyWithSuccess:NULL failure:NULL];
}

@end
