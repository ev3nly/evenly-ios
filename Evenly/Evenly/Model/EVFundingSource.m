//
//  EVFundingSource.m
//  Evenly
//
//  Created by Joseph Hankin on 4/30/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVFundingSource.h"

@implementation EVFundingSource

- (void)setProperties:(NSDictionary *)properties {
    [super setProperties:properties];
    self.uri = [properties valueForKey:@"uri"];
    self.active = [[properties valueForKey:@"status"] isEqualToString:@"active"];
}

- (NSDictionary *)dictionaryRepresentation {
    return @{ @"uri" : self.uri };
}

- (void)tokenizeWithSuccess:(void (^)(void))success failure:(void (^)(NSError *))failure {
    // abstract
}

- (void)activateWithSuccess:(void(^)(void))success failure:(void(^)(NSError *))failure {
    NSMutableURLRequest *request = [[self class] requestWithMethod:@"PUT"
                                                              path:[NSString stringWithFormat:@"%@/%@", self.dbid, @"activate"]
                                                        parameters:nil];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
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

@end
