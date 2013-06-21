//
//  EVGroupCharge.m
//  Evenly
//
//  Created by Joseph Hankin on 4/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupCharge.h"
#import "EVSerializer.h"
#import "EVGroupChargeTier.h"

@implementation EVGroupCharge

+ (NSString *)controllerName {
    return @"group-charges";
}

- (void)setProperties:(NSDictionary *)properties {
    [super setProperties:properties];
    
    self.title = properties[@"title"];
    self.memo = properties[@"description"];
    
    if (![properties[@"from"] isKindOfClass:[NSString class]]) {
        EVObject *fromObject = [EVSerializer serializeDictionary:properties[@"from"]];
        if ([fromObject conformsToProtocol:@protocol(EVExchangeable)])
            self.from = (EVObject<EVExchangeable> *)fromObject;
    }
    
    NSMutableArray *tiers = [NSMutableArray array];
    for (NSDictionary *dictionary in properties[@"tiers"]) {
        [tiers addObject:[EVSerializer serializeDictionary:dictionary]];
    }
    self.tiers = [NSArray arrayWithArray:tiers];
    
    NSMutableArray *records = [NSMutableArray array];
    for (NSDictionary *dictionary in properties[@"records"]) {
        [records addObject:[EVSerializer serializeDictionary:dictionary]];
    }
    self.records = records;
    
    self.completed = [properties[@"completed"] boolValue];
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

- (EVGroupChargeTier *)tierWithID:(NSString *)tierID {
    EVGroupChargeTier *tier = nil;
    for (tier in self.tiers) {
        if ([tier.dbid isEqualToString:tierID]) {
            break;
        }
    }
    return tier;
}

- (UIImage *)avatar {
    return self.from.avatar;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<0x%x> Group Charge %@\n--------------\nTitle: %@\nDescription: %@\nTiers: %@\nRecords: %@\n",
            (int)self, self.dbid, self.title, self.memo, self.tiers, self.records];
}

@end
