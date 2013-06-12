//
//  EVImages.m
//  Evenly
//
//  Created by Joseph Hankin on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVImages.h"

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

@end
