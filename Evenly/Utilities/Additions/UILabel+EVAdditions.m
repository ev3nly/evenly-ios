//
//  UILabel+EVAdditions.m
//  Evenly
//
//  Created by Justin Brunet on 6/26/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "UILabel+EVAdditions.h"

@implementation UILabel (EVAdditions)

- (void)fadeToText:(NSString *)text {
    [self fadeToText:text withColor:self.textColor duration:0.2];
}

- (void)fadeToText:(NSString *)text duration:(float)duration {
    [self fadeToText:text withColor:self.textColor duration:duration];
}

- (void)fadeToText:(NSString *)text withColor:(UIColor *)color duration:(float)duration {
    UILabel *newLabel = [self roughCopy];
    newLabel.text = text;
    newLabel.alpha = 0;
    newLabel.textColor = color;
    [self.superview addSubview:newLabel];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         newLabel.alpha = 1;
                         self.alpha = 0;
                     } completion:^(BOOL finished) {
                         self.text = text;
                         self.alpha = 1;
                         self.textColor = color;
                         [newLabel removeFromSuperview];
                     }];
}

- (UILabel *)roughCopy {
    UILabel *roughCopy = [[UILabel alloc] initWithFrame:self.frame];
    roughCopy.text = self.text;
    roughCopy.textAlignment = self.textAlignment;
    roughCopy.textColor = self.textColor;
    roughCopy.backgroundColor = self.backgroundColor;
    roughCopy.font = self.font;
    roughCopy.lineBreakMode = self.lineBreakMode;
    roughCopy.numberOfLines = self.numberOfLines;
    roughCopy.autoresizingMask = self.autoresizingMask;
    roughCopy.attributedText = self.attributedText;
    roughCopy.userInteractionEnabled = self.userInteractionEnabled;
    roughCopy.adjustsFontSizeToFitWidth = self.adjustsFontSizeToFitWidth;
    roughCopy.adjustsLetterSpacingToFitWidth = self.adjustsLetterSpacingToFitWidth;
    return roughCopy;
}

@end
