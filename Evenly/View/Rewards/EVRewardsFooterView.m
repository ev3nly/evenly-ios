//
//  EVRewardsFooterView.m
//  Evenly
//
//  Created by Joseph Hankin on 7/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRewardsFooterView.h"

@implementation EVRewardsFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *superview = [[UIView alloc] initWithFrame:CGRectZero];
        
        self.logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"small_smile"]];
        [superview addSubview:self.logoView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        [superview addSubview:self.label];
        
        self.label.textColor = [EVColor newsfeedButtonLabelColor];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [EVFont boldFontOfSize:15];
        self.label.text = @"Enjoy!";
        [self.label sizeToFit];
        [self.label setFrame:CGRectMake(self.logoView.frame.size.width, 1, self.label.frame.size.width, self.logoView.frame.size.height)];
        
        [superview setFrame:CGRectMake(0, 0, CGRectGetMaxX(self.label.frame), self.logoView.frame.size.height)];
        [superview setCenter:CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0)];
        [self addSubview:superview];
        [superview align];
        superview.autoresizingMask = EV_AUTORESIZE_TO_CENTER;

        self.backgroundColor = [UIColor whiteColor];
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
