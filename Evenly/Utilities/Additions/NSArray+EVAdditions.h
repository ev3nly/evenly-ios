//
//  NSArray+EVAdditions.h
//  Polltergeist
//
//  Created by Joseph Hankin on 11/28/12.
//  Copyright (c) 2012 Joseph Hankin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (EVAdditions)

- (NSArray *)reversedArray;
- (NSArray *)arrayByRemovingObject:(id)object;
- (NSArray *)map:(id (^)(id object))block;
- (NSArray *)filter:(BOOL (^)(id object))block;
- (NSArray *)flatten;

/** Returns a random object from the receiver, or nil if the receiver is empty. */
- (id)randomObject;

/**
 * When passed an argument that is equal to an element in the receiver, this method returns the object at the following index position.
 * If the receiver is empty, this method returns nil.
 * If the receiver has only one object, this method will return the argument.
 * If the argument is at position n-1 in the receiver (of count n), this method will return the object at position 0.
 * If the argument is not in the receiver, this method raises an exception.
 */
- (id)nextObjectAfter:(id)inObject;

@end

@interface NSMutableArray (EVAdditions)

/* 
 Shift an object from one index to another, moving everything else in the process.
 Suitable for use in tableView:moveRowAtIndexPath:toIndexPath:
 */
- (void)moveObjectFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

/** Reverses the elements of the array. */
- (void)reverse;

/** Randomizes the order of the elements of the array. */
- (void)shuffle;

@end
