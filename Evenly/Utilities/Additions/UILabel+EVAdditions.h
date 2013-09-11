//
//  UILabel+EVAdditions.h
//  Evenly
//
//  Created by Justin Brunet on 6/26/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (EVAdditions)

- (void)fadeToText:(NSString *)text;
- (void)fadeToText:(NSString *)text duration:(float)duration;
- (void)fadeToText:(NSString *)text withColor:(UIColor *)color duration:(float)duration;
- (UILabel *)roughCopy;

- (CGSize)multiLineSizeForWidth:(float)width;

@end
