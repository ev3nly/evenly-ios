//
//  EVGroupRequestTier.h
//  Evenly
//
//  Created by Joseph Hankin on 6/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVObject.h"

@class EVGroupRequest;
@interface EVGroupRequestTier : EVObject

@property (nonatomic, weak) EVGroupRequest *groupRequest;
@property (nonatomic, strong) NSDecimalNumber *price;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, readonly) NSString *optionString;

- (id)initWithGroupRequest:(EVGroupRequest *)groupRequest properties:(NSDictionary *)properties;

@end
