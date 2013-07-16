//
//  EVColor.m
//  Evenly
//
//  Created by Joseph Hankin on 3/27/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVColor.h"

@implementation EVColor

#pragma mark - Default Brand Colors

+ (UIColor *)creamColor {
    return EV_RGB_COLOR(0.9765, 0.9686, 0.9647);
}

+ (UIColor *)lightGreenColor {
    return EV_RGB_COLOR(8, 192, 173 );
}

+ (UIColor *)lightRedColor {
    return EV_RGB_COLOR(255, 105, 80);
}

+ (UIColor *)darkColor {
    return EV_RGB_COLOR(36, 45, 50);
}

+ (UIColor *)lightColor {
    return EV_RGB_COLOR(249, 247, 246);
}

+ (UIColor *)blueColor {
    return EV_RGB_COLOR(0, 133, 214);
}

#pragma mark - Side Panels

+ (UIColor *)sidePanelBackgroundColor {
    return EV_RGB_COLOR(242, 242, 242);
    return [EVColor creamColor];
    return [UIColor whiteColor];// EV_RGB_COLOR(0.1412, 0.1765, 0.1961);
}

+ (UIColor *)sidePanelHeaderBackgroundColor {
    return EV_RGB_COLOR(222, 222, 221);
}

+ (UIColor *)sidePanelSelectedColor {
    return EV_RGB_COLOR(230, 230, 230);
}

+ (UIColor *)sidePanelStripeColor {
    return EV_RGB_COLOR(215, 215, 215);
}

+ (UIColor *)sidePanelTextColor {
    return EV_RGB_COLOR(75, 75, 75);
}

+ (UIColor *)sidePanelIconColor {
    return [EVColor blueColor];
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

#pragma mark - Text

+ (UIColor *)darkLabelColor {
    return EV_RGB_COLOR(0x28, 0x27, 0x26);
}

+ (UIColor *)lightLabelColor {
    return EV_RGB_COLOR(160, 160, 160);
}

+ (UIColor *)placeholderColor {
    return EV_RGB_COLOR(0xd0, 0xce, 0xce);
}

+ (UIColor *)inputTextColor {
    return EV_RGB_COLOR(0x99, 0x96, 0x94);    
}

#pragma mark - Request Switch

+ (UIColor *)requestGrayBackground {
    return EV_RGB_COLOR(0.9451, 0.9451, 0.9451);
}

+ (UIColor *)highlightedTextColor {
    return EV_RGB_COLOR(0.4, 0.4, 0.4);
}

#pragma mark - Progress Bar

+ (UIColor *)progressBarDisabledColor {
    return EV_RGB_COLOR(0.9843, 0.9765, 0.9804);
}

@end
