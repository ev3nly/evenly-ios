//
//  EVImageUtility.m
//  Evenly
//
//  Created by Joseph Hankin on 4/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVImageUtility.h"

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


@end
