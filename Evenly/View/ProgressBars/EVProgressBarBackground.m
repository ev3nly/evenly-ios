//
//  EVProgressBarBackground.m
//  Evenly
//
//  Created by Joseph Hankin on 6/23/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVProgressBarBackground.h"

@implementation EVProgressBarBackground

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:(rect.size.height / 2)];
    if (self.enabled) {
        [[UIColor whiteColor] setStroke];
        [[EVColor newsfeedStripeColor] setFill];
    } else {
        [[EVColor newsfeedStripeColor] setStroke];
        [[EVColor progressBarDisabledColor] setFill];
    }
    path.lineWidth = 2.0;
    [path addClip];
    [path fill];
    [path stroke];
}

@end
