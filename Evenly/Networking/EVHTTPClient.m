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
#import "AFURLConnectionOperation.h"

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

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        self.parameterEncoding = AFJSONParameterEncoding;
        NSString *headerValue = [NSString stringWithFormat:@"iOS-v%@b%@", EV_APP_VERSION, EV_APP_BUILD];
        [self setDefaultHeader:@"Client-Version" value:headerValue];
#ifndef DEBUG
#ifdef _AFNETWORKING_PIN_SSL_CERTIFICATES_
        [self setDefaultSSLPinningMode:AFSSLPinningModePublicKey];
#endif
#else
        //        [self setDefaultSSLPinningMode:AFSSLPinningModeNone];
        
        NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                                diskCapacity:0
                                                                    diskPath:nil];
        [NSURLCache setSharedURLCache:sharedCache];
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
