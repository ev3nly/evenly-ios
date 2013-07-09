//
//  EVReward.h
//  Evenly
//
//  Created by Joseph Hankin on 7/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVObject.h"

@interface EVReward : EVObject

@property (nonatomic, strong) id source;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic) NSInteger selectedOptionIndex;
@property (nonatomic) BOOL willShare;

- (void)redeemWithSuccess:(void (^)(EVReward *reward))success failure:(void (^)(NSError *error))failure;

@end
