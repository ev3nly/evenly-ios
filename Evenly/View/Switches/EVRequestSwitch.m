//
//  EVRequestSwitch.m
//  Evenly
//
//  Created by Joseph Hankin on 6/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRequestSwitch.h"

@implementation EVRequestSwitch

+ (CGSize)size {
    return [UIImage imageNamed:@"Request-Slider-Well"].size;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.label removeFromSuperview];
        self.label = nil;
        
        self.friendOption = [EVRequestSwitchOption friendOption];
        [self addSubview:self.friendOption];
        self.groupOption = [EVRequestSwitchOption groupOption];
        [self addSubview:self.groupOption];
        
        self.on = NO;
        [self layoutForState];
    }
    return self;
}

- (void)updateBackgroundImage {
    self.backgroundImageView.image = [UIImage imageNamed:@"Request-Slider-Well"];
}

- (UIImage *)handleImage {
    return [UIImage imageNamed:@"Request-Slider-White"];
}

- (void)layoutForState {
    [super layoutForState];
    self.friendOption.highlighted = !self.on;
    self.groupOption.highlighted = self.on;    
}
@end
