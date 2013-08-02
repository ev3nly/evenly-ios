//
//  EVFloatingButton.m
//  Evenly
//
//  Created by Joseph Hankin on 6/10/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVFloatingButton.h"

@implementation EVFloatingButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.arrowImageView];
        
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor whiteColor];
        self.label.font = [EVFont blackFontOfSize:13];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
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
