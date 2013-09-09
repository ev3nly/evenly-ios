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
    
    if (properties[@"description"] && [properties[@"description"] isKindOfClass:[NSString class]])
        self.memo = properties[@"description"];
    
    if (properties[@"from"])
    {
        NSDictionary *fromDictionary = properties[@"from"];
        if ([fromDictionary[@"type"] isEqual:@"User"])
        {
            if ([[fromDictionary[@"id"] stringValue] isEqualToString:[EVCIA me].dbid])
                self.from = [EVCIA me];
            else
                self.from = [[EVUser alloc] initWithDictionary:fromDictionary];
            
        }
        else
            self.from = [[EVContact alloc] initWithDictionary:fromDictionary];
    }
    
    if (properties[@"to"])
    {
        NSDictionary *toDictionary = properties[@"to"];
        if ([toDictionary[@"type"] isEqual:@"User"])
        {
            if ([[toDictionary[@"id"] stringValue] isEqualToString:[EVCIA me].dbid])
                self.to = [EVCIA me];
            else
                self.to = [[EVUser alloc] initWithDictionary:toDictionary];
        }
        else
            self.to = [[EVContact alloc] initWithDictionary:toDictionary];
    }
    
    if (properties[@"amount"] && properties[@"amount"] != [NSNull null]) {
        NSString *amountString = nil;
        if ([properties[@"amount"] respondsToSelector:@selector(stringValue)])
            amountString = [properties[@"amount"] stringValue];
        else if ([properties[@"amount"] isKindOfClass:[NSString class]])
            amountString = properties[@"amount"];
        
        if (properties[@"amount_sign"] && [properties[@"amount_sign"] isEqualToString:@"-"]) {
            amountString = [NSString stringWithFormat:@"-%@", amountString];
        }
        self.amount = [EVStringUtility amountFromAmountString:amountString];
    }
    
    if (properties[@"details"])
        self.details = properties[@"details"];
    if (properties[@"title"])
        self.title = properties[@"title"];
}

@end
