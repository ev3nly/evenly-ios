//
//  EVColor.m
//  Evenly
//
//  Created by Joseph Hankin on 3/27/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVColor.h"

@implementation EVColor

+ (UIColor *)sidePanelBackgroundColor {
    return EV_RGB_COLOR(0.1412, 0.1765, 0.1961);
}

+ (UIColor *)sidePanelSelectedColor {
    return EV_RGB_COLOR(0.1255, 0.1569, 0.1765);
}

+ (UIColor *)sidePanelStripeColor {
    return EV_RGB_COLOR(0.1804, 0.2118, 0.2314);
}

@end
