//
//  EVEditPhotoCell.m
//  Evenly
//
//  Created by Justin Brunet on 6/21/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVEditPhotoCell.h"

#define LABEL_X_ORIGIN 10
#define AVATAR_LENGTH 80
#define AVATAR_BUFFER 10
#define SIDE_BUFFER 10

@interface EVEditPhotoCell ()

@end

@implementation EVEditPhotoCell

+ (float)cellHeight {
    return (AVATAR_BUFFER + AVATAR_LENGTH + AVATAR_BUFFER);
}

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureTextLabel];
        [self loadAvatarView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = [self textLabelFrame];
    self.avatarView.frame = [self avatarViewFrame];
}

#pragma mark - View Setup

- (void)configureTextLabel {
    self.textLabel.text = @"Photo";
    self.textLabel.textColor = [EVColor darkLabelColor];
    self.textLabel.font = [EVFont blackFontOfSize:16];
    self.textLabel.backgroundColor = [UIColor clearColor];
}

- (void)loadAvatarView {
    self.avatarView = [[EVAvatarView alloc] initWithFrame:CGRectZero];
    self.avatarView.size = CGSizeMake(AVATAR_LENGTH, AVATAR_LENGTH);
    [self addSubview:self.avatarView];
}

#pragma mark - Frames

- (CGRect)textLabelFrame {
    return CGRectMake(LABEL_X_ORIGIN,
                      0,
                      100,
                      self.bounds.size.height);
}

- (CGRect)avatarViewFrame {
    return CGRectMake(self.bounds.size.width - SIDE_BUFFER - AVATAR_BUFFER - AVATAR_LENGTH,
                      AVATAR_BUFFER,
                      AVATAR_LENGTH,
                      AVATAR_LENGTH);
}

@end
