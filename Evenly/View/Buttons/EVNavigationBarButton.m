//
//  EVNavigationBarButton.m
//  Evenly
//
//  Created by Joseph Hankin on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVNavigationBarButton.h"

#define EV_NAVIGATION_BAR_BUTTON_MINIMUM_WIDTH 45.0

@interface EVNavigationBarButton ()

- (UIFont *)buttonFont;
- (UIEdgeInsets)frameEdgeInsets;

@end

@implementation EVNavigationBarButton

+ (instancetype)buttonWithTitle:(NSString *)title
{
    return [[self alloc] initWithTitle:title];
}

- (id)initWithTitle:(NSString *)title
{
    CGSize size = [title sizeWithFont:[self buttonFont]];
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    rect = UIEdgeInsetsInsetRect(rect, [self frameEdgeInsets]);
    rect.size.width = MAX(rect.size.width, EV_NAVIGATION_BAR_BUTTON_MINIMUM_WIDTH);
    self = [self initWithFrame:rect];
    [self setTitle:title forState:UIControlStateNormal];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[EVImages barButtonItemBackground] forState:UIControlStateNormal];
        [self setBackgroundImage:[EVImages barButtonItemBackgroundPress] forState:UIControlStateHighlighted];
        
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:[self buttonFont]];
    }
    return self;
}

- (CGSize)sizeForTitle:(NSString *)title {
    
}

#pragma mark - Private Methods

- (UIFont *)buttonFont {
    return [EVFont blackFontOfSize:13];
}

- (UIEdgeInsets)frameEdgeInsets {
    return UIEdgeInsetsMake(-5, -8, -5, -8);
}

#pragma mark - Overrides

- (UIEdgeInsets)titleEdgeInsets {
    return UIEdgeInsetsMake(5, 8, 5, 8);
}


@end
