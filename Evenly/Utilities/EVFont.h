//
//  EVFont.h
//  Evenly
//
//  Created by Joseph Hankin on 3/30/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVFont : NSObject


+ (UIFont *)defaultFontOfSize:(CGFloat)fontSize;
+ (UIFont *)boldFontOfSize:(CGFloat)fontSize;
+ (UIFont *)blackFontOfSize:(CGFloat)fontSize;

+ (UIFont *)romanFontOfSize:(CGFloat)fontSize;
+ (UIFont *)obliqueFontOfSize:(CGFloat)fontSize;
+ (UIFont *)bookFontOfSize:(CGFloat)fontSize;

+ (UIFont *)defaultFont;
+ (UIFont *)walletHeaderFont;

+ (UIFont *)darkExchangeFormFont;
+ (UIFont *)lightExchangeFormFont;

+ (UIFont *)defaultButtonFont;

@end
