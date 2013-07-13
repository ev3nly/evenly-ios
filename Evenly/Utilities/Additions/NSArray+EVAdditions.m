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

- (NSArray *)arrayByRemovingObject:(id)object {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];
    [array removeObject:object];
    return array;
}

- (NSArray *)map:(id (^)(id object))block {
    __block NSMutableArray *mappedArray = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [mappedArray addObject:block(obj)];
    }];
    return (NSArray *)mappedArray;
}

- (NSArray *)filter:(BOOL (^)(id object))block {
    NSPredicate *filterPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return block(evaluatedObject);
    }];
    return [self filteredArrayUsingPredicate:filterPredicate];
}


- (id)randomObject {
	if ([self count] == 0)
		return nil;
	
	NSUInteger i = arc4random() % [self count];
	return [self objectAtIndex:i];
}

- (id)nextObjectAfter:(id)inObject
{
	if ([self count] == 0)
		return nil;
	
	NSUInteger i = [self indexOfObject:inObject];
	if (i == NSNotFound)
		[NSException raise:@"EVNextObjectException" format:@"Tried to find next object after one that didn't exist in the array."];
	
	if ([self count] == 1)
		return inObject;
	
	if (i == ([self count] - 1))
		i = -1;
	
	return [self objectAtIndex:(i+1)];
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

- (void)shuffle {
    // http://en.wikipedia.org/wiki/Knuth_shuffle
	
    for(NSUInteger i = [self count]; i > 1; i--) {
        NSUInteger j = arc4random() % i;
        [self exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
    }
}

@end
