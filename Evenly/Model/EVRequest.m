
//
//  EVRequest.m
//  Evenly
//
//  Created by Sean Yu on 4/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRequest.h"
#import "EVPayment.h"

@implementation EVRequest

+ (NSString *)controllerName {
    return @"charges";
}

- (void)completeWithSuccess:(void (^)(EVPayment *payment))success failure:(void (^)(NSError *))failure {
    NSString *path = [NSString stringWithFormat:@"%@/complete", self.dbid];
    NSString *method = @"PUT";
    NSDictionary *parameters = nil;
    
    NSMutableURLRequest *request = [[self class] requestWithMethod:method path:path parameters:parameters];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        EV_PERFORM_ON_MAIN_QUEUE(^{
            EVPayment *payment = [[EVPayment alloc] initWithDictionary:responseObject];
            if (success)
                success(payment);
        });
    };
    AFFailureBlock failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error)  {
        
        if (failure)
            failure(error);
    };
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                              success:successBlock
                                                                              failure:failureBlock];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
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
