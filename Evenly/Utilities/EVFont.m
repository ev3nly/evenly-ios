//
//  EVFont.m
//  Evenly
//
//  Created by Joseph Hankin on 3/30/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVFont.h"

@implementation EVFont

+ (UIFont *)defaultFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Avenir-Book" size:fontSize];
}

+ (UIFont *)boldFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Avenir-Roman" size:fontSize];
}

+ (UIFont *)blackFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Avenir-Heavy" size:fontSize];
}

+ (UIFont *)romanFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Avenir-Roman" size:fontSize];
}

+ (UIFont *)obliqueFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Avenir-Oblique" size:fontSize];
}

+ (UIFont *)bookFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Avenir-Book" size:fontSize];
}

+ (UIFont *)defaultFont {
    return [UIFont fontWithName:@"Avenir" size:16.0];
}

+ (UIFont *)walletHeaderFont {
    return [UIFont fontWithName:@"Avenir-Black" size:13.0];
}

+ (UIFont *)darkExchangeFormFont {
    return [self blackFontOfSize:14];
}

+ (UIFont *)lightExchangeFormFont {
    return [self defaultFontOfSize:14];
}

+ (UIFont *)defaultButtonFont {
    return [self blackFontOfSize:15];
}

@end
