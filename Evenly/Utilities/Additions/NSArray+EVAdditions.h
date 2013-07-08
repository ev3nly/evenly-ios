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
- (NSArray *)map:(id (^)(id object))block;

@end

@interface NSMutableArray (EVAdditions)

/* 
 Shift an object from one index to another, moving everything else in the process.
 Suitable for use in tableView:moveRowAtIndexPath:toIndexPath:
 */
- (void)moveObjectFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

- (void)reverse;

@end
