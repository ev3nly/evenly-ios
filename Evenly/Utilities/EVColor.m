//
//  EVColor.m
//  Evenly
//
//  Created by Joseph Hankin on 3/27/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVColor.h"

@implementation EVColor

+ (UIColor *)creamColor {
    return EV_RGB_COLOR(0.9765, 0.9686, 0.9647);
}

+ (UIColor *)lightGreenColor {
    return EV_RGB_COLOR(0.1294, 0.7490, 0.6784);
}

+ (UIColor *)lightRedColor {
    return EV_RGB_COLOR(0.9882, 0.4157, 0.3373);
}

#pragma mark - Side Panels

+ (UIColor *)sidePanelBackgroundColor {
    return EV_RGB_COLOR(0.1412, 0.1765, 0.1961);
}

+ (UIColor *)sidePanelSelectedColor {
    return EV_RGB_COLOR(0.1255, 0.1569, 0.1765);
}

+ (UIColor *)sidePanelStripeColor {
    return EV_RGB_COLOR(0.1804, 0.2118, 0.2314);
}

#pragma mark - Newsfeed

+ (UIColor *)newsfeedStripeColor {
    return EV_RGB_COLOR(0.9020, 0.8941, 0.8902);
}

+ (UIColor *)newsfeedNounColor {
    return EV_RGB_COLOR(0.1569, 0.1529, 0.1490);
}

+ (UIColor *)newsfeedTextColor {
    return EV_RGB_COLOR(0.6, 0.5882, 0.5804);
}

+ (UIColor *)newsfeedButtonLabelColor {
    return EV_RGB_COLOR(0.5686, 0.5647, 0.5569);
}

+ (UIColor *)newsfeedButtonHighlightColor {
    return EV_RGB_COLOR(0.9725, 0.9725, 0.9725);
}

@end
