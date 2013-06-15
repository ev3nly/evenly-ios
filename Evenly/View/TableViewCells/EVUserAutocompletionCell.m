//
//  EVUserAutocompletionCell.m
//  Evenly
//
//  Created by Justin Brunet on 6/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVUserAutocompletionCell.h"

@implementation EVUserAutocompletionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, self.contentView.frame.size.width -5, self.contentView.frame.size.height / 2.0 - 5)];
        self.nameLabel.autoresizingMask = EV_AUTORESIZE_TO_FIT | UIViewAutoresizingFlexibleBottomMargin;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:14];
        self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.nameLabel align];
        [self.contentView addSubview:self.nameLabel];
        
        self.emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.contentView.frame.size.height / 2.0, self.contentView.frame.size.width -5, self.contentView.frame.size.height / 2.0 - 2)];
        self.emailLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.emailLabel.backgroundColor = [UIColor clearColor];
        self.emailLabel.textColor = [EVColor lightLabelColor];
        self.emailLabel.font = [UIFont systemFontOfSize:14];
        self.emailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.emailLabel align];
        [self.contentView addSubview:self.emailLabel];
        
        self.stripe = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
        self.stripe.backgroundColor = [EVColor newsfeedStripeColor];
        self.stripe.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.stripe];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
