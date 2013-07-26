//
//  EVColor.h
//  Evenly
//
//  Created by Joseph Hankin on 3/27/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVColor : NSObject

#pragma mark - Default Brand Colors

+ (UIColor *)creamColor;
+ (UIColor *)lightGreenColor;
+ (UIColor *)lightRedColor;
+ (UIColor *)darkColor;
+ (UIColor *)lightColor;
+ (UIColor *)blueColor;

#pragma mark - Side Panels

+ (UIColor *)sidePanelBackgroundColor;
+ (UIColor *)sidePanelHeaderBackgroundColor;
+ (UIColor *)sidePanelSelectedColor;
+ (UIColor *)sidePanelStripeColor;
+ (UIColor *)sidePanelTextColor;
+ (UIColor *)sidePanelIconColor;

#pragma mark - Newsfeed

+ (UIColor *)newsfeedStripeColor;
+ (UIColor *)newsfeedNounColor;
+ (UIColor *)newsfeedTextColor;
+ (UIColor *)newsfeedButtonLabelColor;
+ (UIColor *)newsfeedButtonHighlightColor;

#pragma mark - Text

+ (UIColor *)darkLabelColor;
+ (UIColor *)lightLabelColor;
+ (UIColor *)placeholderColor;
+ (UIColor *)inputTextColor;

#pragma mark - Request Switch

+ (UIColor *)requestGrayBackground;
+ (UIColor *)highlightedTextColor;

#pragma mark - Progress Bar

+ (UIColor *)progressBarDisabledColor;

#pragma mark - Debugging

+ (UIColor *)randomColor;

#pragma mark - Rewards

typedef enum {
    EVRewardsSliderColorBlue,
    EVRewardsSliderColorGray,
    EVRewardsSliderColorGreen
} EVRewardsSliderColor;

+ (UIColor *)colorForRewardsSliderColor:(EVRewardsSliderColor)colorFlag;

@end
