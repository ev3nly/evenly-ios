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

- (void)setProperties:(NSDictionary *)properties {
    [super setProperties:properties];
    
    self.completed = [properties[@"completed"] boolValue];
    self.numberOfPayments = [properties[@"number_of_payments"] intValue];
    self.user = (EVUser *)[EVSerializer serializeDictionary:properties[@"user"]];
    
    if (properties[@"tier_id"] != [NSNull null]) {
        self.tier = [self.groupRequest tierWithID:properties[@"tier_id"]];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"GCR <0x%x>: %@    - Completed? %@", (int)self, self.user, (self.completed ? @"YES" : @"NO")];
}

@end
