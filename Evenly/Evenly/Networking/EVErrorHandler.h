//
//  EVErrorHandler.h
//  Evenly
//
//  Created by Sean Yu on 4/10/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVError.h"

@interface EVErrorHandler : NSObject

+ (void)handleError:(EVError *)error
       forOperation:(EVJSONRequestOperation *)operation
withOriginalSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))originalSuccess
    originalFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))originalFailure;

@end
