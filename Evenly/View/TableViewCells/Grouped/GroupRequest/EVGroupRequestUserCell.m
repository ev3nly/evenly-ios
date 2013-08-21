//
//  EVGroupRequestUserCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestUserCell.h"

#define RIGHT_PADDING 10.0

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
    self.avatarView = [[EVAvatarView alloc] initWithFrame:[self avatarFrame]];
    [self.contentView addSubview:self.avatarView];
}

- (CGRect)avatarFrame {
    return CGRectMake(8, 10, 44, 44);
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
    if (!EV_IS_EMPTY_STRING(self.tierLabel.text))
    {
        
    }
    else
    {
        [self.nameLabel setFrame:CGRectMake(GROUP_REQUEST_USER_CELL_LABELS_LEFT_MARGIN,
                                            0,
                                            self.contentView.frame.size.width - GROUP_REQUEST_USER_CELL_LABELS_LEFT_MARGIN - RIGHT_PADDING,
                                            self.contentView.frame.size.height)];
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
