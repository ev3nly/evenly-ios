//
//  EVGroupChargeRecord.h
//  Evenly
//
//  Created by Joseph Hankin on 6/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVObject.h"

@class EVGroupCharge;
@class EVGroupChargeTier;
@class EVUser;

@interface EVGroupChargeRecord : EVObject

@property (nonatomic, weak) EVGroupCharge *groupCharge;
@property (nonatomic, weak) EVGroupChargeTier *tier;
@property (nonatomic, strong) NSDecimalNumber *amountPaid;
@property (nonatomic) NSInteger numberOfPayments;
@property (nonatomic) BOOL completed;
@property (nonatomic, strong) EVUser *user;

- (id)initWithGroupCharge:(EVGroupCharge *)groupCharge;

@end
