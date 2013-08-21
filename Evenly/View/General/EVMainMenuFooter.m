//
//  EVHamburgerFooter.m
//  Evenly
//
//  Created by Joseph Hankin on 7/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVMainMenuFooter.h"

#define LOGO_MARGIN 5.0
#define IMAGE_WIDTH 20
#define IMAGE_HEIGHT 21
#define LOGO_X_OFFSET (-EV_RIGHT_OVERHANG_MARGIN/2)

@implementation EVMainMenuFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIColor *color = EV_RGB_COLOR(200, 200, 200);
        UIImage *image = [EVImageUtility overlayImage:[EVImages grayLogo] withColor:color identifier:@"footerLogo"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setFrame:CGRectMake(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT)];
        [imageView setCenter:CGPointMake(self.frame.size.width / 2.0 + LOGO_X_OFFSET, self.frame.size.height / 2.0 + 2)];
        [self addSubview:imageView];
        
        UIView *stripe = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  self.frame.size.height / 2.0,
                                                                  CGRectGetMinX(imageView.frame) - LOGO_MARGIN,
                                                                  1)];
        [stripe setBackgroundColor:color];
        [self addSubview:stripe];
        
        stripe = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + LOGO_MARGIN,
                                                          self.frame.size.height / 2.0,
                                                          frame.size.width - CGRectGetMaxX(imageView.frame) - LOGO_MARGIN,
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
