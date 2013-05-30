//
//  EVHTTPClient.h
//  Evenly
//
//  Created by Joseph Hankin on 3/30/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "AFNetworking.h"

@interface EVJSONRequestOperation : AFJSONRequestOperation

@end

@interface EVHTTPClient : AFHTTPClient

+ (Class)errorHandlerClass;
+ (void)setErrorHandlerClass:(Class)errorHandlerClass;

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                                              hijackFailure:(BOOL)override;

@end
