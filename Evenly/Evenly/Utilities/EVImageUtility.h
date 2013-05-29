//
//  EVImageUtility.h
//  Evenly
//
//  Created by Joseph Hankin on 4/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVImageUtility : NSObject

+ (CGRect)frameForImage:(UIImage *)image givenBoundingFrame:(CGRect)boundingFrame;
+ (CGSize)sizeForImage:(UIImage *)image constrainedToSize:(CGSize)constraintSize;

@end
