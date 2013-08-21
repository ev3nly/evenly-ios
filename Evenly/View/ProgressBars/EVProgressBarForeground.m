//
//  EVProgressBarForeground.m
//  Evenly
//
//  Created by Joseph Hankin on 6/23/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVProgressBarForeground.h"

@interface EVProgressBarForeground ()

@property (nonatomic, strong) UIImageView *backgroundView;

@end

@implementation EVProgressBarForeground

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.autoresizesSubviews = YES;
        
        self.backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.backgroundView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        self.backgroundView.image = [[UIImage imageNamed:@"Progress-Active"] resizableImageWithCapInsets:UIEdgeInsetsMake(9, 10, 9, 10)];
        [self addSubview:self.backgroundView];
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
