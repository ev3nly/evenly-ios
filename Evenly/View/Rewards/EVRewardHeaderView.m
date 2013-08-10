//
//  EVRewardHeaderView.m
//  Evenly
//
//  Created by Joseph Hankin on 8/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRewardHeaderView.h"
#import "EVSwitch.h"

@interface EVRewardHeaderView ()

#define X_MARGIN 15.0
#define Y_MARGIN 5.0
#define BOOST_LABEL_Y_ORIGIN 12.0
#define LABEL_WIDTH 110.0

@property (nonatomic, strong) UILabel *boostLabel;
@property (nonatomic, strong) UILabel *shareLabel;

@property (nonatomic, strong) UIView *stripe;

@end

@implementation EVRewardHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [EVColor lightColor];
        
        self.boostLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_MARGIN, BOOST_LABEL_Y_ORIGIN, LABEL_WIDTH, self.frame.size.height / 2.0 - 2*Y_MARGIN)];
        self.boostLabel.backgroundColor = [UIColor clearColor];
        self.boostLabel.textColor = [EVColor mediumLabelColor];
        self.boostLabel.font = [EVFont boldFontOfSize:12];
        self.boostLabel.text = @"Double your money,";
        [self addSubview:self.boostLabel];
        
        self.shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_MARGIN, CGRectGetMaxY(self.boostLabel.frame), LABEL_WIDTH, self.frame.size.height / 2.0 - 2*Y_MARGIN)];
        self.shareLabel.backgroundColor = [UIColor clearColor];
        self.shareLabel.textColor = [EVColor lightLabelColor];
        self.shareLabel.font = [EVFont defaultFontOfSize:12];
        self.shareLabel.text = @"share on Facebook";
        [self addSubview:self.shareLabel];
        
        self.stripe = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
        self.stripe.backgroundColor = [EVColor newsfeedStripeColor];
        [self addSubview:self.stripe];
        
    }
    return self;
}

- (void)setShareSwitch:(EVSwitch *)shareSwitch {
    [self.shareSwitch removeFromSuperview];
    _shareSwitch = shareSwitch;
    [self setNeedsLayout]; 
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.shareSwitch) {
        [self addSubview:self.shareSwitch];
        [self.shareSwitch setFrame:CGRectMake(self.frame.size.width - self.shareSwitch.frame.size.width - X_MARGIN,
                                              (self.frame.size.height - self.shareSwitch.frame.size.height) / 2.0,
                                              self.shareSwitch.frame.size.width,
                                              self.shareSwitch.frame.size.height)];
    }
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
