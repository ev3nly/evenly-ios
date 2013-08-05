//
//  NSDate+EVAdditions.h
//  Evenly
//
//  Created by Joseph Hankin on 8/5/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (EVAdditions)

- (BOOL)isEarlierThan:(NSDate *)otherDate;
- (BOOL)isLaterThan:(NSDate *)otherDate;

@end
