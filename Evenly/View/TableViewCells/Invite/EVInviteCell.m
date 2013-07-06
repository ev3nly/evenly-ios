//
//  EVInviteCell.m
//  Evenly
//
//  Created by Justin Brunet on 7/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVInviteCell.h"
#import <QuartzCore/QuartzCore.h>

#define SIDE_MARGIN 10
#define PICTURE_BUFER 8
#define INVITE_BUTTON_WIDTH 70
#define INVITE_BUTTON_HEIGHT 36

@implementation EVInviteCell

+ (float)cellHeight {
    return 56;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self loadProfilePicture];
        [self loadDefaultAvatar];
        [self loadNameLabel];
        [self loadInviteButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.profilePicture.frame = [self profilePictureFrame];
    self.defaultAvatar.frame = self.profilePicture.frame;
    self.nameLabel.frame = [self nameLabelFrame];
    self.inviteButton.frame = [self inviteButtonFrame];
}

#pragma mark - View Loading

- (void)loadProfilePicture {
    //implement in subclass
    self.profilePicture.layer.cornerRadius = 4.0;
}

- (void)loadDefaultAvatar {
    self.defaultAvatar = [[UIImageView alloc] initWithImage:[EVImages defaultAvatar]];
    self.defaultAvatar.layer.cornerRadius = 4.0;
    self.defaultAvatar.frame = self.profilePicture.frame;
    self.defaultAvatar.clipsToBounds = YES;
    [self insertSubview:self.defaultAvatar belowSubview:self.profilePicture];
}

- (void)loadNameLabel {
    self.nameLabel = [UILabel new];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textColor = [UIColor darkGrayColor];
    self.nameLabel.font = [EVFont blackFontOfSize:14];
    [self addSubview:self.nameLabel];
}

- (void)loadInviteButton {
    self.inviteButton = [UIButton new];
    [self.inviteButton setBackgroundImage:[EVImages inviteButtonBackground] forState:UIControlStateNormal];
    [self.inviteButton setBackgroundImage:[EVImages inviteButtonBackgroundSelected] forState:UIControlStateHighlighted];
    [self.inviteButton addTarget:self action:@selector(inviteTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.inviteButton setTitle:@"INVITE" forState:UIControlStateNormal];
    [self.inviteButton setTitleColor:[EVColor darkLabelColor] forState:UIControlStateNormal];
    [self.inviteButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 0)];
    self.inviteButton.titleLabel.font = [EVFont blackFontOfSize:11];
    [self addSubview:self.inviteButton];
}

#pragma mark - Gesture Handling

- (void)inviteTapped {
    self.shouldInvite = !self.shouldInvite;
}

#pragma mark - Setters

- (void)setShouldInvite:(BOOL)shouldInvite {
    _shouldInvite = shouldInvite;
    
    if (shouldInvite) {
        UIImage *greenCheck = [EVImageUtility overlayImage:[EVImages checkIcon] withColor:[EVColor lightGreenColor] identifier:@"checkIcon"];
        [UIView animateWithDuration:0.3 animations:^{
            [self.inviteButton setTitle:@"" forState:UIControlStateNormal];
            [self.inviteButton setImage:greenCheck forState:UIControlStateNormal];
        }];
        if (self.handleSelection)
            self.handleSelection(self.identifier);
    } else {
        [self.inviteButton setTitle:@"INVITE" forState:UIControlStateNormal];
        [self.inviteButton setImage:nil forState:UIControlStateNormal];
        if (self.handleDeselection)
            self.handleDeselection(self.identifier);
    }
}

#pragma mark - Frames

- (CGRect)profilePictureFrame {
    return CGRectMake(SIDE_MARGIN + PICTURE_BUFER,
                      PICTURE_BUFER,
                      self.bounds.size.height - PICTURE_BUFER*2,
                      self.bounds.size.height - PICTURE_BUFER*2);
}

- (CGRect)nameLabelFrame {
    [self.nameLabel sizeToFit];
    return CGRectMake(CGRectGetMaxX(self.profilePicture.frame) + SIDE_MARGIN,
                      self.bounds.size.height/2 - self.nameLabel.bounds.size.height/2,
                      self.nameLabel.bounds.size.width,
                      self.nameLabel.bounds.size.height);
}

- (CGRect)inviteButtonFrame {
    return CGRectMake(self.bounds.size.width - SIDE_MARGIN - SIDE_MARGIN - INVITE_BUTTON_WIDTH,
                      self.bounds.size.height/2 - INVITE_BUTTON_HEIGHT/2,
                      INVITE_BUTTON_WIDTH,
                      INVITE_BUTTON_HEIGHT);
}

@end
