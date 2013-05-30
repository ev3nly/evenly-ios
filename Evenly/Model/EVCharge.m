//
//  EVCharge.m
//  Evenly
//
//  Created by Sean Yu on 4/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVCharge.h"

@implementation EVCharge

+ (NSString *)controllerName {
    return @"charges";
}

- (void)completeWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    [self action:@"complete" method:@"PUT" parameters:nil success:success failure:failure];
}

- (void)denyWithSuccess:(void (^)(void))success
                failure:(void (^)(NSError *error))failure {
    [self action:@"deny" method:@"PUT" parameters:nil success:success failure:failure];
}

- (void)remindWithSuccess:(void (^)(void))success
                  failure:(void (^)(NSError *error))failure {
    [self action:@"remind" method:@"POST" parameters:nil success:success failure:failure];
}

- (void)cancelWithSuccess:(void (^)(void))success
                  failure:(void (^)(NSError *error))failure {
    [self action:@"cancel" method:@"PUT" parameters:nil success:success failure:failure];
}

@end
