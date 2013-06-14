//
//  EVImages.m
//  Evenly
//
//  Created by Joseph Hankin on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVImages.h"

@interface EVImages ()

+ (UIImage *)imageWithColorOverlay:(UIColor *)overlayColor fromImage:(UIImage *)image;
+ (NSString *)stringFromColor:(UIColor *)color;
+ (NSCache *)drawingCache;

@end

@implementation EVImages

+ (UIImage *)resizableTombstoneBackground {
    return [[UIImage imageNamed:@"FeedContainer"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
}

+ (UIImage *)blueButtonBackground {
    return [[UIImage imageNamed:@"btn_blue"] resizableImageWithCapInsets:UIEdgeInsetsMake(21, 3, 21, 3)];
}

+ (UIImage *)blueButtonBackgroundPress {
    return [[UIImage imageNamed:@"btn_blue-active"] resizableImageWithCapInsets:UIEdgeInsetsMake(21, 3, 21, 3)];
}

+ (UIImage *)grayButtonBackground {
    return [[UIImage imageNamed:@"btn_gray"] resizableImageWithCapInsets:UIEdgeInsetsMake(21, 3, 21, 3)];
}

+ (UIImage *)grayButtonBackgroundPress {
    return [[UIImage imageNamed:@"btn_gray-active"] resizableImageWithCapInsets:UIEdgeInsetsMake(21, 3, 21, 3)];
}

#pragma mark - Privacy

+ (UIImage *)friendsIcon {
    return [UIImage imageNamed:@"Privacy-Friends"];
}

+ (UIImage *)globeIcon {
    return [UIImage imageNamed:@"Privacy-Globe"];
}

+ (UIImage *)lockIcon {
    return [UIImage imageNamed:@"Privacy-Lock"];
}

+ (UIImage *)dropdownArrow {
    return [UIImage imageNamed:@"Privacy-Dropdown"];
}

+ (UIImage *)checkIcon {
    return [UIImage imageNamed:@"Privacy-Check"];
}

#pragma mark - Image Coloring

+ (UIImage *)overlayImage:(UIImage *)image withColor:(UIColor *)overlayColor identifier:(NSString *)imageIdentifier
{
    if (!image)
        return nil;
    if (!imageIdentifier)
        return [self imageWithColorOverlay:overlayColor fromImage:image];
    imageIdentifier = [NSString stringWithFormat:@"%@-%@", imageIdentifier, [self stringFromColor:overlayColor]];
    
    UIImage *overlayedImage = [[self drawingCache] objectForKey:imageIdentifier];
    if (!overlayedImage) {
        overlayedImage = [self imageWithColorOverlay:overlayColor fromImage:image];
        [[self drawingCache] setObject:overlayedImage forKey:imageIdentifier];
    }
    
    return overlayedImage;
}

+ (UIImage *)imageWithColorOverlay:(UIColor *)overlayColor fromImage:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [overlayColor setFill];
    
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextSetShadow(context, CGSizeMake(0, 5), 2.0);
    CGContextClipToMask(context, imageRect, image.CGImage);
    CGContextFillRect(context, imageRect);
    
    UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return coloredImage;
}

+ (NSString *)stringFromColor:(UIColor *)color
{
    float red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return [NSString stringWithFormat:@"r:%f-g:%f-b:%f-a:%f", red, green, blue, alpha];
}

+ (NSCache *)drawingCache
{
    static NSCache *cache = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        cache = [[NSCache alloc] init];
    });
    return cache;
}

@end
