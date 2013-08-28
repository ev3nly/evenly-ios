//
//  EVMainMenuCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVMainMenuCell.h"

#define MARKETING_VIEW_PADDING 5

@implementation EVMainMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      self.frame.size.height,
                                                                      self.frame.size.height)];
        self.iconView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:self.iconView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame),
                                                               0,
                                                               self.frame.size.width - CGRectGetMaxX(self.iconView.frame),
                                                               self.frame.size.height)];
        self.label.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        self.label.textColor = [EVColor sidePanelTextColor];
        self.label.backgroundColor = [UIColor clearColor];
        [self.label setFont:[EVFont boldFontOfSize:20.0]];
        [self.contentView addSubview:self.label];
        
        UIView *stripe = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  self.frame.size.height - 1,
                                                                  self.frame.size.width,
                                                                  1)];
        stripe.backgroundColor = [EVColor sidePanelStripeColor];
        stripe.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:stripe];
    }
    return self;
}

- (void)setMarketingView:(UIView *)marketingView {
    [_marketingView removeFromSuperview];
    _marketingView = marketingView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.label sizeToFit];
    [self.label setFrame:[self labelFrame]];
    
    if (self.marketingView) {
        [self.marketingView setFrame:[self marketingViewFrame]];
        [self.contentView addSubview:self.marketingView];
    }
}

- (CGRect)labelFrame {
    return CGRectMake(CGRectGetMaxX(self.iconView.frame),
                      (self.contentView.frame.size.height - self.label.frame.size.height) / 2.0,
                      self.label.frame.size.width,
                      self.label.frame.size.height);
}

- (CGRect)marketingViewFrame {
    return CGRectMake(CGRectGetMaxX(self.label.frame),
                      0,
                      self.contentView.frame.size.width - CGRectGetMaxX(self.label.frame),
                      self.contentView.frame.size.height);
}

@end
