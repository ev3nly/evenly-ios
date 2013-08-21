//
//  NSDate+EVAdditions.m
//  Evenly
//
//  Created by Joseph Hankin on 8/5/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "NSDate+EVAdditions.h"

@implementation NSDate (EVAdditions)

- (BOOL)isEarlierThan:(NSDate *)otherDate {
    return ([self earlierDate:otherDate] == self);
}

- (BOOL)isLaterThan:(NSDate *)otherDate {
    return ([self laterDate:otherDate] == self);
}

@end
