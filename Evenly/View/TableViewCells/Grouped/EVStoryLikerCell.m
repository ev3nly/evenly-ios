//
//  EVStoryLikerCell.m
//  Evenly
//
//  Created by Joseph Hankin on 9/16/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVStoryLikerCell.h"

#define AVATAR_VIEW_DIMENSION 30.0
#define AVATAR_MARGIN ([EVUtilities userHasIOS7] ? 20.0 : 10.0)
#define AVATAR_SPACING 8.0

@implementation EVStoryLikerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatarView = [[EVAvatarView alloc] initWithFrame:CGRectMake(0, 0, AVATAR_VIEW_DIMENSION, AVATAR_VIEW_DIMENSION)];
        [self.contentView addSubview:self.avatarView];
        
        self.likerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.likerLabel setAttributedText:nil];
        [self.contentView addSubview:self.likerLabel];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.likerLabel setAttributedText:nil];
    [self.avatarView setAvatarOwner:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.avatarView.frame = [self avatarViewFrame];
    self.likerLabel.frame = [self likerLabelFrame];
}

- (void)setLiker:(EVUser *)liker {
    _liker = liker;
    [self.avatarView setAvatarOwner:liker];
    NSAttributedString *attrString = [EVStringUtility attributedStringForLiker:liker];
    [self.likerLabel setAttributedText:attrString];
    [self.likerLabel sizeToFit];
    [self setNeedsLayout];
}

#pragma mark - Frames

- (CGRect)avatarViewFrame {
    return CGRectMake(AVATAR_MARGIN,
                      (self.contentView.frame.size.height - AVATAR_VIEW_DIMENSION) / 2.0,
                      AVATAR_VIEW_DIMENSION,
                      AVATAR_VIEW_DIMENSION);
}

- (CGRect)likerLabelFrame {
    return CGRectMake(CGRectGetMaxX(self.avatarView.frame) + AVATAR_SPACING,
                      (self.contentView.frame.size.height - self.likerLabel.frame.size.height) / 2.0,
                      self.likerLabel.frame.size.width,
                      self.likerLabel.frame.size.height);
}

@end
