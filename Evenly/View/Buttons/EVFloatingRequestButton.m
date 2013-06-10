//
//  EVFloatingRequestButton.m
//  Evenly
//
//  Created by Joseph Hankin on 6/10/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVFloatingRequestButton.h"

@implementation EVFloatingRequestButton

#define EV_FLOATING_REQUEST_BUTTON_ARROW_MARGIN 14.0
#define EV_FLOATING_REQUEST_BUTTON_TEXT_MARGIN 12.0

- (id)init
{
    UIImage *bgImage = [UIImage imageNamed:@"Action_Request"];
    self = [super initWithFrame:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    if (self) {
        
        [self setBackgroundImage:bgImage forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"Action_RequestActive"] forState:UIControlStateHighlighted];
        
        [self.arrowImageView setImage:[UIImage imageNamed:@"FeedActionLeftArrow"]];
        [self.label setText:@"REQUEST"];
        
        [self setNeedsLayout];        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat x, y, width, height;
    
    x = EV_FLOATING_REQUEST_BUTTON_ARROW_MARGIN;
    width = self.arrowImageView.image.size.width;
    height = self.arrowImageView.image.size.height;
    y = (int)((self.frame.size.height - height) / 2.0);
    self.arrowImageView.frame = CGRectMake(x, y, width, height);
    
    [self.label sizeToFit];
    
    x = self.frame.size.width - EV_FLOATING_REQUEST_BUTTON_TEXT_MARGIN - self.label.frame.size.width;
    width = self.label.frame.size.width;
    height = self.label.frame.size.height;
    y = (int)((self.frame.size.height - height) / 2.0);
    self.label.frame = CGRectMake(x, y, width, height);
}

@end
