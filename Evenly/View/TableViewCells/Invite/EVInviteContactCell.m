//
//  EVContactInviteCell.m
//  Evenly
//
//  Created by Justin Brunet on 7/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVInviteContactCell.h"

@interface EVInviteContactCell ()

@property (nonatomic, strong) UIImageView *profilePicture;

@end

@implementation EVInviteContactCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadEmailLabel];
    }
    return self;
}

- (void)loadEmailLabel {
    self.emailLabel = [UILabel new];
    self.emailLabel.backgroundColor = [UIColor clearColor];
    self.emailLabel.textColor = [UIColor darkGrayColor];
    self.emailLabel.font = [EVFont defaultFontOfSize:14];
    [self addSubview:self.emailLabel];
}

- (void)loadProfilePicture {
    self.profilePicture = [UIImageView new];
    self.profilePicture.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.profilePicture];
    [super loadProfilePicture];
}

- (void)setName:(NSString *)name profilePicture:(UIImage *)picture {
    self.nameLabel.text = name;
    self.profilePicture.image = picture;
    if (picture)
        [self.defaultAvatar removeFromSuperview];
    else
        [self addSubview:self.defaultAvatar];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!EV_IS_EMPTY_STRING(self.emailLabel.text))
    {
        self.emailLabel.frame = [self emailLabelFrame];
        [self.nameLabel setOrigin:CGPointMake(self.nameLabel.frame.origin.x, self.emailLabel.frame.origin.y - self.nameLabel.frame.size.height)];
    }
}

- (CGRect)emailLabelFrame {
    [self.emailLabel sizeToFit];
    CGFloat xOrigin = CGRectGetMaxX(self.profilePicture.frame) + EV_INVITE_CELL_SIDE_MARGIN;
    return CGRectMake(xOrigin,
                      self.bounds.size.height/2,
                      CGRectGetMinX([self inviteButtonFrame]) - xOrigin,
                      self.emailLabel.bounds.size.height);
}


@end
