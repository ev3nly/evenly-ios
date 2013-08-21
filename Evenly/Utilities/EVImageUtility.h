//
//  EVImageUtility.h
//  Evenly
//
//  Created by Joseph Hankin on 4/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ABContact;

@interface EVImageUtility : NSObject

+ (CGRect)frameForImage:(UIImage *)image givenBoundingFrame:(CGRect)boundingFrame;
+ (CGSize)sizeForImage:(UIImage *)image constrainedToSize:(CGSize)constraintSize;
+ (CGSize)sizeForImage:(UIImage *)image withInnerBoundingSize:(CGSize)boundingSize;

#pragma mark - Orientation Fixing
+ (UIImage *)orientedImageFromImage:(UIImage *)image;

#pragma mark - Image Resizing
+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size;

#pragma mark - Image Making
+ (UIImage *)captureView:(UIView *)view;
+ (UIImage *)imageForContact:(ABContact *)contact;

#pragma mark - Image Coloring
+ (UIImage *)overlayImage:(UIImage *)image withColor:(UIColor *)overlayColor identifier:(NSString *)imageIdentifier;
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
