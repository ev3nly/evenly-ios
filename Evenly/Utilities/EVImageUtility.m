//
//  EVImageUtility.m
//  Evenly
//
//  Created by Joseph Hankin on 4/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVImageUtility.h"
#import <QuartzCore/QuartzCore.h>
#import <AddressBook/AddressBook.h>
#import "ABContactsHelper.h"

@interface EVImageUtility ()

+ (UIImage *)imageWithColorOverlay:(UIColor *)overlayColor fromImage:(UIImage *)image;
+ (NSCache *)drawingCache;

@end

@implementation EVImageUtility

#pragma mark - Sizing

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

+ (CGSize)sizeForImage:(UIImage *)image withInnerBoundingSize:(CGSize)boundingSize {
    CGSize imageSize = image.size;
    CGSize imageViewSize;
    
    CGFloat wRatio = imageSize.width / boundingSize.width;
    CGFloat hRatio = imageSize.height / boundingSize.height;
    
    if (wRatio > hRatio)
        imageViewSize = CGSizeMake(floorf(boundingSize.width * (imageSize.width/imageSize.height)), boundingSize.height);
    else
        imageViewSize = CGSizeMake(boundingSize.width, floorf(boundingSize.height * (imageSize.height/imageSize.width)));

    return imageViewSize;
}

#pragma mark - Orientation Fixing

+ (UIImage *)orientedImageFromImage:(UIImage *)image {    
    if (image.imageOrientation == UIImageOrientationUp)
        return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark - Image Resizing

+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size {    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width,size.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

#pragma mark - Image Making

+ (UIImage *)captureView:(UIView *)view {
    
    CALayer *layer;
    layer = view.layer;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenImage;
}

static NSCache *_contactPhotoCache;

+ (UIImage *)imageForContact:(ABContact *)contact {
    if (!_contactPhotoCache)
        _contactPhotoCache = [NSCache new];
    UIImage *image = [_contactPhotoCache objectForKey:[self identifierForContact:contact]];
    if (image)
        return image;
    
    ABAddressBookRef addressBook = [ABContactsHelper addressBook];
    NSArray *peopleWithSameLastName = (__bridge NSArray *)ABAddressBookCopyPeopleWithName(addressBook, ABRecordCopyValue(contact.record, kABPersonLastNameProperty));
    
    if ([peopleWithSameLastName count] > 0) {
        for (id untypedPerson in peopleWithSameLastName) {
            ABRecordRef person = (__bridge ABRecordRef)untypedPerson;
            NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
            NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
            if ([firstName isEqualToString:contact.firstname] && [lastName isEqualToString:contact.lastname]) {
                NSData *imageData = (__bridge NSData *)ABPersonCopyImageData(person);
                if (imageData) {
                    image = [UIImage imageWithData:imageData];
                    break;
                }
            }
        }
    }
    if (image)
        [_contactPhotoCache setObject:image forKey:[self identifierForContact:contact]];
    return image;
}

+ (NSString *)identifierForContact:(ABContact *)contact {
    return [NSString stringWithFormat:@"%@-%@", contact.compositeName, contact.creationDate];
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
