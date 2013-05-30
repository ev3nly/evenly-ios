//
//  NSDictionary+EVAdditions.h
//  Polltergeist
//
//  Created by Joseph Hankin on 2/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDictionary (EVAdditions)

- (BOOL)isEmpty;

@end

@interface NSMutableDictionary (EVAdditions)

/*
 Simply remove an object (i.e., a value) from a mutable dictionary.
 */
- (void)removeObject:(id)anObject;

@end

