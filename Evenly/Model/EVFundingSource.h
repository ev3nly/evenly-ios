//
//  EVFundingSource.h
//  Evenly
//
//  Created by Joseph Hankin on 4/30/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVObject.h"

@interface EVFundingSource : EVObject

@property (nonatomic, strong) NSString *uri;
@property (nonatomic, getter = isActive) BOOL active;

- (void)tokenizeWithSuccess:(void(^)(void))success failure:(void(^)(NSError *error))failure;
- (void)activateWithSuccess:(void(^)(void))success failure:(void(^)(NSError *error))failure;

@end
