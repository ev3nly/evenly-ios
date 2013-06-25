//
//  EVGrayButton.m
//  Evenly
//
//  Created by Joseph Hankin on 6/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGrayButton.h"

@implementation EVGrayButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[EVImages grayButtonBackground] forState:UIControlStateNormal];
        [self setBackgroundImage:[EVImages grayButtonBackgroundPress] forState:UIControlStateHighlighted];
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:[EVFont blackFontOfSize:15]];
        [self.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
