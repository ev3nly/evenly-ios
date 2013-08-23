//
//  EVHistoryItem.m
//  Evenly
//
//  Created by Joseph Hankin on 8/22/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVHistoryItem.h"

@implementation EVHistoryItem

- (void)setProperties:(NSDictionary *)properties {
    [super setProperties:properties];
    
    // Source Object
    if (properties[@"source_type"] && properties[@"source_id"]) {
        self.source = @{ @"type" : properties[@"source_type"],
                         @"id" : properties[@"source_id"] };
    }
    
    if (properties[@"amount"] && properties[@"amount"] != [NSNull null]) {
        if ([properties[@"amount"] isKindOfClass:[NSDecimalNumber class]])
            self.amount = properties[@"amount"];
        else if ([properties[@"amount"] respondsToSelector:@selector(stringValue)])
            self.amount = [NSDecimalNumber decimalNumberWithString:[properties[@"amount"] stringValue]];
    }
    
    if (properties[@"description"] && [properties[@"description"] isKindOfClass:[NSString class]])
        self.memo = properties[@"description"];
    
    if (properties[@"from"])
    {
        NSDictionary *fromDictionary = properties[@"from"];
        if ([fromDictionary[@"type"] isEqual:@"User"])
            self.from = [[EVUser alloc] initWithDictionary:fromDictionary];
        else
            self.from = [[EVContact alloc] initWithDictionary:fromDictionary];
    }
    
    if (properties[@"to"])
    {
        NSDictionary *toDictionary = properties[@"to"];
        if ([toDictionary[@"type"] isEqual:@"User"])
            self.from = [[EVUser alloc] initWithDictionary:toDictionary];
        else
            self.from = [[EVContact alloc] initWithDictionary:toDictionary];
    }
}

@end
