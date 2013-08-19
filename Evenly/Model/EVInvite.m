//
//  EVInvite.m
//  Evenly
//
//  Created by Sean Yu on 4/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVInvite.h"

@implementation EVInvite

+ (NSString *)controllerName {
    return @"invites";
}

+ (void)createWithEmail:(NSString *)email success:(void (^)(EVObject *object))success failure:(void(^)(NSError *error))failure {
    [self createWithParams:@{@"email": email} success:success failure:failure];
}

+ (void)createWithEmails:(NSArray *)emails success:(void (^)(EVObject *object))success failure:(void(^)(NSError *error))failure {
    [self createWithParams:@{@"emails" : emails} success:success failure:failure];
}

+ (void)createWithPhoneNumber:(NSString *)phoneNumber success:(void (^)(EVObject *object))success failure:(void(^)(NSError *error))failure {
    [self createWithParams:@{ @"phone_number" : phoneNumber} success:success failure:failure];
}

@end
