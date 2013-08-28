//
//  EVGroupRequestUserCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestUserCell.h"

#define SIDE_MARGIN 20.0
#define TOP_MARGIN 10
#define AVATAR_HEIGHT 44
#define NAME_LABEL_BUFFER 10

@interface EVGroupRequestUserCell ()

- (void)loadAvatarView;
- (void)loadNameLabel;
- (void)loadTierLabel;

@end

@implementation EVGroupRequestUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadAvatarView];
        [self loadNameLabel];
        [self loadTierLabel];
    }
    return self;
}


- (void)loadAvatarView {
    self.avatarView = [[EVAvatarView alloc] initWithFrame:[self avatarViewFrame]];
    [self.contentView addSubview:self.avatarView];
}

- (void)loadNameLabel {
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.font = [EVFont blackFontOfSize:GROUP_REQUEST_USER_CELL_LARGE_FONT_SIZE];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.adjustsLetterSpacingToFitWidth = YES;
    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:self.nameLabel];
}

- (void)loadTierLabel {
    self.tierLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.tierLabel.font = [EVFont defaultFontOfSize:GROUP_REQUEST_USER_CELL_SMALL_FONT_SIZE];
    self.tierLabel.textColor = [EVColor lightLabelColor];
    self.tierLabel.backgroundColor = [UIColor clearColor];
    self.tierLabel.adjustsLetterSpacingToFitWidth = YES;
    self.tierLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:self.tierLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.avatarView.frame = [self avatarViewFrame];
    self.nameLabel.frame = [self nameLabelFrame];
}

#pragma mark - Frames

- (CGRect)avatarViewFrame {
    return CGRectMake(SIDE_MARGIN,
                      TOP_MARGIN,
                      AVATAR_HEIGHT,
                      AVATAR_HEIGHT);
}

- (CGRect)nameLabelFrame {
    float xOrigin = CGRectGetMaxX(self.avatarView.frame) + NAME_LABEL_BUFFER;
    return CGRectMake(CGRectGetMaxX(self.avatarView.frame) + NAME_LABEL_BUFFER,
                      0,
                      self.contentView.frame.size.width - xOrigin - SIDE_MARGIN,
                      self.contentView.frame.size.height);
}

@end
