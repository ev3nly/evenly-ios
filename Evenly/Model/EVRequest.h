//
//  EVRequest.h
//  Evenly
//
//  Created by Sean Yu on 4/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchange.h"

@interface EVRequest : EVExchange

- (void)completeWithSuccess:(void (^)(void))success
                    failure:(void (^)(NSError *error))failure;

- (void)denyWithSuccess:(void (^)(void))success
                failure:(void (^)(NSError *error))failure;

- (void)remindWithSuccess:(void (^)(void))success
                  failure:(void (^)(NSError *error))failure;

- (void)cancelWithSuccess:(void (^)(void))success
                  failure:(void (^)(NSError *error))failure;

@end
