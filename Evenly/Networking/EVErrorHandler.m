//
//  EVErrorHandler.m
//  Evenly
//
//  Created by Sean Yu on 4/10/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVErrorHandler.h"

@interface EVErrorHandler(private)

@end

@implementation EVErrorHandler

+ (void)handleError:(EVError *)error
       forOperation:(EVJSONRequestOperation *)operation
withOriginalSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))originalSuccess
    originalFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))originalFailure {
    
    //subclass and override this method!
    
    originalFailure(operation, error);
}

@end
