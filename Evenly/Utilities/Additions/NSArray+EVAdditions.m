//
//  NSArray+EVAdditions.m
//  Polltergeist
//
//  Created by Joseph Hankin on 11/28/12.
//  Copyright (c) 2012 Joseph Hankin. All rights reserved.
//

#import "NSArray+EVAdditions.h"

@implementation NSArray (EVAdditions)

- (NSArray *)reversedArray {
    return [[self reverseObjectEnumerator] allObjects];
}

- (NSArray *)map:(id (^)(id object))block {
    __block NSMutableArray *mappedArray = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [mappedArray addObject:block(obj)];
    }];
    return (NSArray *)mappedArray;
}

@end

@implementation NSMutableArray (EVAdditions)

- (void)moveObjectFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    id obj = [self objectAtIndex:fromIndex];
    [self removeObjectAtIndex:fromIndex];
    if (toIndex == [self count])
        [self addObject:obj];
    else
        [self insertObject:obj atIndex:toIndex];
}

- (void)reverse {
    if ([self count] == 0)
        return;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
}

@end
