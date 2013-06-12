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
    return [UIFont fontWithName:@"Avenir" size:fontSize];    
}

+ (UIFont *)boldFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Avenir-Heavy" size:fontSize];
}

+ (UIFont *)blackFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Avenir-Black" size:fontSize];    
}

+ (UIFont *)defaultFont {
    return [UIFont fontWithName:@"Avenir" size:16.0];
}

+ (UIFont *)walletHeaderFont {
    return [UIFont fontWithName:@"Avenir-Black" size:13.0];
}

@end
