//
//  EVThrobberSegment.m
//  Evenly
//
//  Created by Joseph Hankin on 8/5/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVThrobberSegment.h"
#import <QuartzCore/QuartzCore.h>

@interface EVThrobberSegment ()

@property (nonatomic, strong) UIView *pillView;

@end

@implementation EVThrobberSegment

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.autoresizesSubviews = YES;
        
        self.pillView = [[UIView alloc] initWithFrame:self.bounds];
        self.pillView.layer.cornerRadius = 2.0;
        self.pillView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        [self addSubview:self.pillView];
        
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self.pillView setBackgroundColor:_color];
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
