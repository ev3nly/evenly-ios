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

        self.stripe = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               self.frame.size.height - [EVUtilities scaledDividerHeight],
                                                               self.frame.size.width,
                                                               [EVUtilities scaledDividerHeight])];
        self.stripe.backgroundColor = [EVColor sidePanelStripeColor];
        [self addSubview:self.stripe];

        self.shouldHighlight = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.stripe.frame = CGRectMake(0,
                                   self.frame.size.height - [EVUtilities scaledDividerHeight],
                                   self.frame.size.width,
                                   [EVUtilities scaledDividerHeight]);
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
