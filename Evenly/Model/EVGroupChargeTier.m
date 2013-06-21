//
//  EVGroupChargeTier.m
//  Evenly
//
//  Created by Joseph Hankin on 6/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupChargeTier.h"

@implementation EVGroupChargeTier

- (void)setProperties:(NSDictionary *)properties {
    [super setProperties:properties];
    
    self.price = [NSDecimalNumber decimalNumberWithString:properties[@"price"]];
    self.name = properties[@"name"];
}

- (void)validate {
    BOOL isValid;
    
    if (!self.price || [self.price isEqualToNumber:[NSDecimalNumber notANumber]] || [self.price isEqualToNumber:[NSNumber numberWithInt:0]])
        isValid = NO;
    else
        isValid = YES;
    
    self.valid = isValid;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    [mutableDictionary setObject:[self.price stringValue] forKey:@"price"];
    setValueForKeyIfNonNil(self.name, @"name");
    return mutableDictionary;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Group Charge Tier <0x%x>: %@ - %@", (int)self, self.name, self.price];
}

@end
