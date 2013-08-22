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
    EV_RETURN_STATIC_RGB_COLOR(0.9765, 0.9686, 0.9647);
}

+ (UIColor *)lightGreenColor {
    EV_RETURN_STATIC_RGB_COLOR(8, 192, 173);
}

+ (UIColor *)lightRedColor {
    EV_RETURN_STATIC_RGB_COLOR(255, 105, 80);
}

+ (UIColor *)darkColor {
    EV_RETURN_STATIC_RGB_COLOR(36, 45, 50);
}

+ (UIColor *)lightColor {
    EV_RETURN_STATIC_RGB_COLOR(249, 247, 246);
}

+ (UIColor *)blueColor {
    EV_RETURN_STATIC_RGB_COLOR(0, 127, 216);
}

#pragma mark - Side Panels

+ (UIColor *)sidePanelBackgroundColor {
    EV_RETURN_STATIC_RGB_COLOR(250, 250, 250);
}

+ (UIColor *)sidePanelHeaderBackgroundColor {
    EV_RETURN_STATIC_RGB_COLOR(222, 222, 221);
}

+ (UIColor *)sidePanelSelectedColor {
    EV_RETURN_STATIC_RGB_COLOR(230, 230, 230);
}

+ (UIColor *)sidePanelStripeColor {
    EV_RETURN_STATIC_RGB_COLOR(215, 215, 215);
}

+ (UIColor *)sidePanelTextColor {
    EV_RETURN_STATIC_RGB_COLOR(75, 75, 75);
}

+ (UIColor *)sidePanelIconColor {
    return [EVColor blueColor];
}

#pragma mark - Newsfeed

+ (UIColor *)newsfeedStripeColor {
    if ([UIScreen mainScreen].scale == 2) {
        EV_RETURN_STATIC_RGB_COLOR(0.86, 0.85, 0.84);
    }
    else {
        EV_RETURN_STATIC_RGB_COLOR(0.9020, 0.8941, 0.8902);
    }
}

+ (UIColor *)newsfeedNounColor {
    EV_RETURN_STATIC_RGB_COLOR(0.1569, 0.1529, 0.1490);
}

+ (UIColor *)newsfeedTextColor {
    EV_RETURN_STATIC_RGB_COLOR(0.6, 0.5882, 0.5804);
}

+ (UIColor *)newsfeedButtonLabelColor {
    EV_RETURN_STATIC_RGB_COLOR(0.5686, 0.5647, 0.5569);
}

+ (UIColor *)newsfeedButtonHighlightColor {
    EV_RETURN_STATIC_RGB_COLOR(246, 246, 246);
}

#pragma mark - Text

+ (UIColor *)darkLabelColor {
    EV_RETURN_STATIC_RGB_COLOR(0x28, 0x27, 0x26);
}

+ (UIColor *)lightLabelColor {
    EV_RETURN_STATIC_RGB_COLOR(160, 160, 160);
}

+ (UIColor *)mediumLabelColor {
    EV_RETURN_STATIC_RGB_COLOR(115, 115, 115);
}

+ (UIColor *)placeholderColor {
    EV_RETURN_STATIC_RGB_COLOR(0xd0, 0xce, 0xce);
}

+ (UIColor *)inputTextColor {
    EV_RETURN_STATIC_RGB_COLOR(0x99, 0x96, 0x94);    
}

#pragma mark - Request Switch

+ (UIColor *)requestGrayBackground {
    EV_RETURN_STATIC_RGB_COLOR(0.9451, 0.9451, 0.9451);
}

+ (UIColor *)highlightedTextColor {
    EV_RETURN_STATIC_RGB_COLOR(0.4, 0.4, 0.4);
}

#pragma mark - Progress Bar

+ (UIColor *)progressBarDisabledColor {
    EV_RETURN_STATIC_RGB_COLOR(0.9843, 0.9765, 0.9804);
}

#pragma mark - Debugging
#define ARC4RANDOM_MAX      0x100000000

+ (UIColor *)randomColor {
    return EV_RGB_COLOR(((double)arc4random() / ARC4RANDOM_MAX),
                        ((double)arc4random() / ARC4RANDOM_MAX),
                        ((double)arc4random() / ARC4RANDOM_MAX));
}

#pragma mark - Rewards

+ (UIColor *)colorForRewardsSliderColor:(EVRewardsSliderColor)colorFlag {
    NSArray *colors = @[ [EVColor blueColor], [EVColor lightColor], [EVColor lightGreenColor] ];
    return [colors objectAtIndex:colorFlag];
}


@end
