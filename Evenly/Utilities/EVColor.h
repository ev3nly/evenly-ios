//
//  EVColor.h
//  Evenly
//
//  Created by Joseph Hankin on 3/27/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVColor : NSObject

+ (UIColor *)creamColor;
+ (UIColor *)lightGreenColor;
+ (UIColor *)lightRedColor;

#pragma mark - Side Panels

+ (UIColor *)sidePanelBackgroundColor;
+ (UIColor *)sidePanelSelectedColor;
+ (UIColor *)sidePanelStripeColor;

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

@end
