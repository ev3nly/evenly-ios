//
//  EVSidePanelCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVSidePanelCell.h"

@implementation EVSidePanelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UIView *stripe = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  self.frame.size.height - 1,
                                                                  self.frame.size.width,
                                                                  1)];
        stripe.backgroundColor = [EVColor sidePanelStripeColor];
        stripe.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:stripe];
        self.stripe = stripe;
        self.shouldHighlight = YES;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (self.shouldHighlight)
    {
        [self setBackgroundColor:(highlighted ? [EVColor sidePanelSelectedColor] : [UIColor clearColor])];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
