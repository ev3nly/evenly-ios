//
//  EVBackButton.m
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVBackButton.h"

#define DEFAULT_TAPPABLE_SIZE 44

@implementation EVBackButton

+ (id)button {
    UIImage *image = [EVImages navBarBackButton];
    UIButton *button = [[self alloc] initWithFrame:CGRectMake(0, 0, DEFAULT_TAPPABLE_SIZE, DEFAULT_TAPPABLE_SIZE)];
    [button setImage:image forState:UIControlStateNormal];

    CGSize insetSize = CGSizeMake(DEFAULT_TAPPABLE_SIZE - image.size.width, (DEFAULT_TAPPABLE_SIZE - image.size.height)/2);
    [button setImageEdgeInsets:UIEdgeInsetsMake(insetSize.height, 0, insetSize.height, insetSize.width)];

    [button setAdjustsImageWhenHighlighted:NO];
    [button setShowsTouchWhenHighlighted:YES];
    return button;
}

@end
