//
//  EVRewardsExhaustedView.m
//  Evenly
//
//  Created by Joseph Hankin on 8/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRewardsExhaustedView.h"

#define MARGINS 20.0

@implementation EVRewardsExhaustedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = EV_RGB_ALPHA_COLOR(36, 45, 50, 0.9);
        
        self.topLabel = [self configuredLabel];
        self.topLabel.text = @"Sorry!  You've used all your\nrewards for the day.";
        [self addSubview:self.topLabel];
        
        self.sadFace = [[UIImageView alloc] initWithImage:[EVImages noRewardsSadFace]];
        [self addSubview:self.sadFace];
        
        self.bottomLabel = [self configuredLabel];
        self.bottomLabel.text = @"Send more payments tomorrow for additional chances to win.";
        [self addSubview:self.bottomLabel];
        
    }
    return self;

}

- (UILabel *)configuredLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [EVFont bookFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    return label;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.sadFace.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    
    self.topLabel.frame = CGRectMake(MARGINS,
                                     MARGINS,
                                     self.frame.size.width - 2*MARGINS,
                                     CGRectGetMinY(self.sadFace.frame) - 2*MARGINS);
    self.bottomLabel.frame = CGRectMake(MARGINS,
                                        CGRectGetMaxY(self.sadFace.frame) + MARGINS,
                                        self.frame.size.width - 2*MARGINS,
                                        self.frame.size.height - 2*MARGINS - CGRectGetMaxY(self.sadFace.frame));
    
}

@end
