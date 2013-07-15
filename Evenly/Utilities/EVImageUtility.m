//
//  EVImageUtility.m
//  Evenly
//
//  Created by Joseph Hankin on 4/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVImageUtility.h"
#import <QuartzCore/QuartzCore.h>

@interface EVImageUtility ()

+ (UIImage *)imageWithColorOverlay:(UIColor *)overlayColor fromImage:(UIImage *)image;
+ (NSCache *)drawingCache;

@end

@implementation EVImageUtility

+ (CGRect)frameForImage:(UIImage *)image givenBoundingFrame:(CGRect)boundingFrame
{
    CGRect frame = CGRectMake(0, 0, 0, 0);
    if (!image || CGRectIsEmpty(boundingFrame))
        return frame;
    
    frame.size = [self sizeForImage:image constrainedToSize:boundingFrame.size];
    frame.origin.x = (boundingFrame.size.width - frame.size.width) / 2.0;
    frame.origin.y = (boundingFrame.size.height - frame.size.height) / 2.0;
    return CGRectIntegral(frame);
}

+ (CGSize)sizeForImage:(UIImage *)image constrainedToSize:(CGSize)constraintSize
{
    CGSize imageSize = image.size;
    CGSize maxSize = constraintSize;
    CGSize imageViewSize;
    if (imageSize.width < maxSize.width && imageSize.height < maxSize.height) {
        imageViewSize = imageSize;
    } else {
        CGFloat wRatio = maxSize.width / imageSize.width;
        CGFloat hRatio = maxSize.height / imageSize.height;
        if (wRatio < hRatio) {
            imageViewSize = CGSizeMake(maxSize.width, imageSize.height * wRatio);
        } else {
            imageViewSize = CGSizeMake(imageSize.width * hRatio, maxSize.height);
        }
    }
    return imageViewSize;
}

+ (UIImage *)captureView:(UIView *)view {
    
    CALayer *layer;
    layer = view.layer;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenImage;
}


#pragma mark - Image Coloring

+ (UIImage *)overlayImage:(UIImage *)image withColor:(UIColor *)overlayColor identifier:(NSString *)imageIdentifier
{
    if (!image)
        return nil;
    if (!imageIdentifier)
        return [self imageWithColorOverlay:overlayColor fromImage:image];
    imageIdentifier = [NSString stringWithFormat:@"%@-%@", imageIdentifier, [overlayColor stringRepresentation]];
    
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

+ (NSCache *)drawingCache
{
    static NSCache *cache = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        cache = [[NSCache alloc] init];
    });
    return cache;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    backgroundView.backgroundColor = color;
    
    UIGraphicsBeginImageContext(backgroundView.bounds.size);
    [backgroundView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return backgroundImage;
}

@end
