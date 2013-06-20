//
//  EVGroupCharge.m
//  Evenly
//
//  Created by Joseph Hankin on 4/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupCharge.h"
#import "EVGroupChargeTier.h"
#import "EVSerializer.h"

@implementation EVGroupCharge

+ (NSString *)controllerName {
    return @"group-charges";
}

- (void)setProperties:(NSDictionary *)properties {
    [super setProperties:properties];
    
    if (![properties[@"from"] isKindOfClass:[NSString class]]) {
        EVObject *fromObject = [EVSerializer serializeDictionary:properties[@"from"]];
        if ([fromObject conformsToProtocol:@protocol(EVExchangeable)])
            self.from = (EVObject<EVExchangeable> *)fromObject;
    }
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    
    setValueForKeyIfNonNil(self.title, @"title");
    setValueForKeyIfNonNil(self.memo, @"description");
    
    NSMutableArray *array = [NSMutableArray array];
    for (EVGroupChargeTier *tier in self.tiers) {
        [array addObject:[tier dictionaryRepresentation]];
    }
    [mutableDictionary setObject:array forKey:@"tiers"];
    
    array = [NSMutableArray array];
    for (EVObject<EVExchangeable> *member in self.members) {
        if ([member isKindOfClass:[EVUser class]]) {
            [array addObject:[member dbid]];
        } else {
            [array addObject:[member email]];
        }
    }
    if ([array count])
        [mutableDictionary setObject:array forKey:@"record_data"];
    return mutableDictionary;
}

@end
