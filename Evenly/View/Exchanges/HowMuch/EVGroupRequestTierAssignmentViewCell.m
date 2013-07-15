//
//  EVGroupRequestTierAssignmentViewCell.m
//  Evenly
//
//  Created by Joseph Hankin on 7/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestTierAssignmentViewCell.h"

#define TOP_MARGIN 5.0
#define SPACING_BETWEEN_AVATAR_AND_CAPTION 5.0

@implementation EVGroupRequestTierAssignmentViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubviews];
    }
    return self;
}

- (void)loadSubviews {
    self.avatarView = [[EVAvatarView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.avatarView];
    
    self.captionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.captionLabel.backgroundColor = [UIColor clearColor];
    self.captionLabel.textColor = [EVColor lightColor];
    self.captionLabel.font = [EVFont defaultFontOfSize:13];
    self.captionLabel.textAlignment = NSTextAlignmentCenter;
    self.captionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:self.captionLabel];
    
    self.selectionIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [self.contentView addSubview:self.selectionIndicator];
    
}

- (void)setContact:(EVObject<EVExchangeable> *)contact {
    [self.avatarView setAvatarOwner:contact];
    [self.captionLabel setText:[[contact.name componentsSeparatedByString:@" "] objectAtIndex:0]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize avatarSize = CGSizeMake(55, 55);
    [self.avatarView setFrame:CGRectMake((self.contentView.frame.size.width - avatarSize.width) / 2.0, TOP_MARGIN, avatarSize.width, avatarSize.height)];
    
    [self.captionLabel setFrame:CGRectMake(0,
                                           CGRectGetMaxY(self.avatarView.frame) + SPACING_BETWEEN_AVATAR_AND_CAPTION,
                                           self.contentView.frame.size.width,
                                           self.contentView.frame.size.height - CGRectGetMaxY(self.avatarView.frame) - SPACING_BETWEEN_AVATAR_AND_CAPTION)];
    
    [self.selectionIndicator setFrame:CGRectMake(self.contentView.frame.size.width - self.selectionIndicator.frame.size.width,
                                                 0,
                                                 self.selectionIndicator.frame.size.width,
                                                 self.selectionIndicator.frame.size.height)];
}


@end
