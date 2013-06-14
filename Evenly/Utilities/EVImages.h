//
//  EVImages.h
//  Evenly
//
//  Created by Joseph Hankin on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVImages : NSObject

+ (UIImage *)resizableTombstoneBackground;

#pragma mark - Button Backgrounds

+ (UIImage *)blueButtonBackground;
+ (UIImage *)blueButtonBackgroundPress;
+ (UIImage *)grayButtonBackground;
+ (UIImage *)grayButtonBackgroundPress;

#pragma mark - Icons

+ (UIImage *)friendsIcon;
+ (UIImage *)globeIcon;
+ (UIImage *)lockIcon;
+ (UIImage *)dropdownArrow;
+ (UIImage *)checkIcon;

#pragma mark - Image Coloring

+ (UIImage *)overlayImage:(UIImage *)image withColor:(UIColor *)overlayColor identifier:(NSString *)imageIdentifier;

@end
