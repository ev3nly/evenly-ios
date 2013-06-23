//
//  EVGroupRequestRecord.h
//  Evenly
//
//  Created by Joseph Hankin on 6/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVObject.h"

@class EVGroupRequest;
@class EVGroupRequestTier;
@class EVUser;

@interface EVGroupRequestRecord : EVObject

@property (nonatomic, weak) EVGroupRequest *groupRequest;
@property (nonatomic, weak) EVGroupRequestTier *tier;
@property (nonatomic, strong) NSDecimalNumber *amountPaid;
@property (nonatomic) NSInteger numberOfPayments;
@property (nonatomic) BOOL completed;
@property (nonatomic, strong) EVObject<EVExchangeable> *user;
@property (nonatomic, strong) NSArray *payments;

- (id)initWithGroupRequest:(EVGroupRequest *)groupRequest;

@end
