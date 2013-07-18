//
//  EVHamburgerFooter.m
//  Evenly
//
//  Created by Joseph Hankin on 7/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVMainMenuFooter.h"

@implementation EVMainMenuFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIColor *color = EV_RGB_COLOR(200, 200, 200);
        UIImage *image = [EVImageUtility overlayImage:[EVImages grayLogo] withColor:color identifier:@"footerLogo"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setFrame:CGRectMake(0, 0, 20, 21)];
        [imageView setCenter:CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0 + 2)];
        [self addSubview:imageView];
        
        UIView *stripe = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  self.frame.size.height / 2.0,
                                                                  CGRectGetMinX(imageView.frame) - 5.0,
                                                                  1)];
        [stripe setBackgroundColor:color];
        [self addSubview:stripe];
        
        stripe = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5.0,
                                                          self.frame.size.height / 2.0,
                                                          CGRectGetMinX(imageView.frame) - 5.0,
                                                          1)];
        [stripe setBackgroundColor:color];
        [self addSubview:stripe];
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
