//
//  EVExchange.h
//  Evenly
//
//  Created by Sean Yu on 4/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVObject.h"
#import "EVUser.h"
#import "EVReward.h"

@interface EVExchange : EVObject

@property (nonatomic, strong) NSDecimalNumber *amount;
@property (nonatomic, strong) NSString *memo;
@property (nonatomic, strong) EVObject<EVExchangeable> *to;
@property (nonatomic, strong) EVObject<EVExchangeable> *from;
@property (nonatomic, readonly) BOOL isIncoming;
@property (nonatomic, readonly) UIImage *avatar;

@property (nonatomic, strong) EVReward *reward;

@end