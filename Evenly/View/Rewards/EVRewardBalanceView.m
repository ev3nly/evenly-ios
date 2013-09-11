//
//  EVRewardBalanceView.m
//  Evenly
//
//  Created by Joseph Hankin on 8/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRewardBalanceView.h"

@interface EVRewardBalanceView ()

#define X_MARGIN 15.0
#define Y_MARGIN 5.0
#define TITLE_LABEL_WIDTH 170.0

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *stripe;

@end

@implementation EVRewardBalanceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [EVColor lightColor];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_MARGIN, Y_MARGIN, TITLE_LABEL_WIDTH, self.frame.size.height - 2*Y_MARGIN)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [EVColor mediumLabelColor];
        self.titleLabel.font = [EVFont defaultFontOfSize:18];
        self.titleLabel.text = @"Evenly Cash Balance";
        [self addSubview:self.titleLabel];
        
        self.balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + X_MARGIN,
                                                                    Y_MARGIN,
                                                                    self.frame.size.width - X_MARGIN*2 - CGRectGetMaxX(self.titleLabel.frame),
                                                                    self.frame.size.height - 2*Y_MARGIN)];
        self.balanceLabel.backgroundColor = [UIColor clearColor];
        self.balanceLabel.textColor = [EVColor mediumLabelColor];
        self.balanceLabel.font = [EVFont blackFontOfSize:18];
        self.balanceLabel.text = [EVStringUtility amountStringForAmount:[EVCIA me].balance];
        self.balanceLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.balanceLabel];
        
        self.stripe = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - [EVUtilities scaledDividerHeight], self.frame.size.width, [EVUtilities scaledDividerHeight])];
        self.stripe.backgroundColor = [EVColor newsfeedStripeColor];
        [self addSubview:self.stripe];
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
