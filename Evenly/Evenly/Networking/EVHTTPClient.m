//
//  EVHTTPClient.m
//  Evenly
//
//  Created by Joseph Hankin on 3/30/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVHTTPClient.h"
#import "EVErrorHandler.h"
#import "EVConstants.h"

@interface EVJSONRequestOperation(private)

@end

@implementation EVJSONRequestOperation

+ (BOOL)canProcessRequest:(NSURLRequest *)request {
    return [AFHTTPRequestOperation canProcessRequest:request];
}

- (void)connection:(NSURLConnection __unused*)connection didFailWithError:(NSError *)error {
    [super connection:connection didFailWithError:error];
    if ([[error domain] isEqualToString:@"NSURLErrorDomain"] && [error code] == NSURLErrorUserCancelledAuthentication)
    {
        DLog(@"SSL PINNING ERROR FOR CONNECTION %@: %@", connection, error);
    }
}

@end

@implementation EVHTTPClient

- (id)init {
    self = [super initWithBaseURL:[NSURL URLWithString:EV_API_URL]];
    if (self) {
        self.parameterEncoding = AFJSONParameterEncoding;
        
        [self setDefaultHeader:@"Ios-Version" value:EV_APP_VERSION];
        [self setDefaultHeader:@"Ios-Build" value:EV_APP_BUILD];
    #ifndef DEBUG
        [self setDefaultSSLPinningMode:AFSSLPinningModePublicKey];
    #else
//        [self setDefaultSSLPinningMode:AFSSLPinningModeNone];
    #endif
    }
    return self;
}

static Class _errorHandlerClass = nil;
+ (Class)errorHandlerClass {
    if (_errorHandlerClass == nil)
        _errorHandlerClass = [EVErrorHandler class];
    return _errorHandlerClass;
}

+ (void)setErrorHandlerClass:(Class)errorHandlerClass {
    _errorHandlerClass = errorHandlerClass;
}

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                                              hijackFailure:(BOOL)override {
    
    AFHTTPRequestOperation *operation = nil;

    if (!override)
        operation = [super HTTPRequestOperationWithRequest:urlRequest success:success failure:failure];
    else {
        void (^modifiedFailure)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
            EVError *trueError = [EVError errorWithCode:operation.response.statusCode andDictionary:[(AFJSONRequestOperation *)operation responseJSON]];
            DLog(@"\nError %i: %@\n%@", trueError.code, trueError.message, trueError.errors);
            [[self.class errorHandlerClass] handleError:trueError
                                           forOperation:(EVJSONRequestOperation *)operation
                                    withOriginalSuccess:success
                                        originalFailure:failure];
        };
        operation = [super HTTPRequestOperationWithRequest:urlRequest success:success failure:modifiedFailure];
    }
    return operation;
}

@end
