//
//  UIColor+EVAdditions.m
//  Evenly
//
//  Created by Justin Brunet on 6/13/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "UIColor+EVAdditions.h"

@implementation UIColor (EVAdditions)

- (NSString *)stringRepresentation {
    float red, green, blue, alpha;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    return [NSString stringWithFormat:@"r:%f-g:%f-b:%f-a:%f", red, green, blue, alpha];
}

@end
