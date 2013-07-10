//
//  EVGroupRequestRecord.m
//  Evenly
//
//  Created by Joseph Hankin on 6/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestRecord.h"
#import "EVGroupRequest.h"
#import "EVGroupRequestTier.h"
#import "EVUser.h"
#import "EVSerializer.h"

@implementation EVGroupRequestRecord

- (id)initWithGroupRequest:(EVGroupRequest *)groupRequest {
    self = [super init];
    if (self) {
        self.groupRequest = groupRequest;
    }
    return self;
}

- (id)initWithGroupRequest:(EVGroupRequest *)groupRequest properties:(NSDictionary *)properties {
    self = [self initWithGroupRequest:groupRequest];
    if (self) {
        [self setProperties:properties];
    }
    return self;
}

- (void)setProperties:(NSDictionary *)properties {
    [super setProperties:properties];
    
    self.completed = [properties[@"completed"] boolValue];
    self.numberOfPayments = [properties[@"number_of_payments"] intValue];
    if ([[properties[@"user"][@"id"] stringValue] isEqualToString:[EVCIA me].dbid])
        self.user = [EVCIA me];
    else
        self.user = (EVObject<EVExchangeable> *)[EVSerializer serializeDictionary:properties[@"user"]];
    self.amountPaid = [NSDecimalNumber decimalNumberWithString:properties[@"amount_paid"]];

    if (properties[@"tier_id"] != [NSNull null]) {
        self.tier = [self.groupRequest tierWithID:[properties[@"tier_id"] stringValue]];
    }
    
    if (properties[@"payments"] && properties[@"payments"] != [NSNull null]) {
        NSMutableArray *tmpPayments = [NSMutableArray array];
        for (NSDictionary *dictionary in properties[@"payments"]) {
            [tmpPayments addObject:(EVPayment *)[EVSerializer serializeDictionary:dictionary]];
        }
        self.payments = [NSArray arrayWithArray:tmpPayments];
    }
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.tier)
        [params setObject:self.tier.dbid forKey:@"tier_id"];
    if (self.user.dbid)
        [params setObject:self.user.dbid forKey:@"user_id"];
    else
        [params setObject:self.user.email forKey:@"user_id"];
    
//    [params setObject:[NSNumber numberWithBool:self.completed] forKey:@"completed"];
    return params;
}

- (NSDecimalNumber *)amountOwed {
    if (!self.tier)
        return [NSDecimalNumber zero];
    return [self.tier.price decimalNumberBySubtracting:self.amountPaid];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"GCR <0x%x>: %@    - Completed? %@", (int)self, self.user, (self.completed ? @"YES" : @"NO")];
}

@end
