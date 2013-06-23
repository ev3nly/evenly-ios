//
//  EVGroupRequestProgressBar.m
//  Evenly
//
//  Created by Joseph Hankin on 6/23/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVProgressBar.h"
#import "EVProgressBarBackground.h"
#import "EVProgressBarForeground.h"

@interface EVProgressBar ()

@property (nonatomic, strong) EVProgressBarBackground *background;
@property (nonatomic, strong) EVProgressBarForeground *foreground;
@end

@implementation EVProgressBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.background = [[EVProgressBarBackground alloc] initWithFrame:self.bounds];
        [self addSubview:self.background];
        
        self.foreground = [[EVProgressBarForeground alloc] initWithFrame:CGRectMake(0, 0, 0, self.frame.size.height)];
        [self addSubview:self.foreground];
        
        self.enabled = NO;
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    [self.background setEnabled:enabled];
    [self.foreground setHidden:!enabled];
}

- (void)setProgress:(float)progress {
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    _progress = progress;
    if (_progress > 0.0)
        self.enabled = YES;
    [UIView animateWithDuration:(animated ? 0.5 : 0.0) animations:^{
        [self.foreground setFrame:CGRectMake(0, 0, _progress * self.frame.size.width, self.frame.size.height)];
    }];
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
