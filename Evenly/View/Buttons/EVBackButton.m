//
//  EVBackButton.m
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVBackButton.h"

@implementation EVBackButton

+ (id)button {
    UIImage *image = [EVImages navBarBackButton];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    UIButton *button = [[self alloc] initWithFrame:CGRectMake(0, 0, image.size.width + edgeInsets.left + edgeInsets.right, image.size.height)];
    [button setImage:image forState:UIControlStateNormal];
    [button setImageEdgeInsets:edgeInsets];
    [button setAdjustsImageWhenHighlighted:NO];
    [button setShowsTouchWhenHighlighted:YES];
    return button;
}

@end
