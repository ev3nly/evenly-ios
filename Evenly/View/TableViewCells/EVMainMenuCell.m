//
//  EVMainMenuCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVMainMenuCell.h"

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
        self.label.textColor = [UIColor whiteColor];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
