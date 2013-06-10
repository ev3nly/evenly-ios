//
//  EVFloatingPaymentButton.m
//  Evenly
//
//  Created by Joseph Hankin on 6/10/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVFloatingPaymentButton.h"

#define EV_FLOATING_PAYMENT_BUTTON_TEXT_MARGIN 12.0
#define EV_FLOATING_PAYMENT_BUTTON_ARROW_MARGIN 25.0

@implementation EVFloatingPaymentButton

- (id)init
{
    UIImage *leftBgImage = [UIImage imageNamed:@"Action_Request"];
    UIImage *bgImage = [UIImage imageNamed:@"Action_Payment"];
    self = [super initWithFrame:CGRectMake(leftBgImage.size.width, 0, bgImage.size.width, bgImage.size.height)];
    if (self) {
        
        [self setBackgroundImage:bgImage forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"Action_PaymentActive"] forState:UIControlStateHighlighted];
        
        [self.arrowImageView setImage:[UIImage imageNamed:@"FeedActionRightArrow"]];
        [self.label setText:@"PAYMENT"];
        
        [self setNeedsLayout];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat x, y, width, height;
    
    [self.label sizeToFit];
    x = EV_FLOATING_PAYMENT_BUTTON_TEXT_MARGIN;
    width = self.label.frame.size.width;
    height = self.label.frame.size.height;
    y = (int)((self.frame.size.height - height) / 2.0);
    self.label.frame = CGRectMake(x, y, width, height);

    width = self.arrowImageView.image.size.width;
    x = self.frame.size.width - EV_FLOATING_PAYMENT_BUTTON_ARROW_MARGIN - width;
    height = self.arrowImageView.image.size.height;
    y = (int)((self.frame.size.height - height) / 2.0) - 10.0;
    self.arrowImageView.frame = CGRectMake(x, y, width, height);
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
