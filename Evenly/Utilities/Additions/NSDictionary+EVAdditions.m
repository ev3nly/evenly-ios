//
//  NSDictionary+EVAdditions.m
//  Polltergeist
//
//  Created by Joseph Hankin on 2/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "NSDictionary+EVAdditions.h"

@implementation NSDictionary (EVAdditions)

- (BOOL)isEmpty {
    if ([self count] == 0)
        return YES;
    
    BOOL isEmpty;
    for (id key in [self allKeys]) {
        id value = [self objectForKey:key];
        if ([value isKindOfClass:[NSDictionary class]])
            isEmpty = [(NSDictionary *)value isEmpty];
        else if ([value isKindOfClass:[NSArray class]])
            isEmpty = ([(NSArray *)value count] == 0);
        else
            return NO;
        if (!isEmpty)
            return NO;
    }
    return YES;
}


@end

@implementation NSMutableDictionary (EVAdditions)

- (void)removeObject:(id)anObject {
    [self removeObjectsForKeys:[self allKeysForObject:anObject]];
}

@end
