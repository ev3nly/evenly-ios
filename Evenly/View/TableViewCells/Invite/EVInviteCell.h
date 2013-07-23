//
//  EVInviteCell.h
//  Evenly
//
//  Created by Justin Brunet on 7/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"

#define EV_INVITE_CELL_SIDE_MARGIN 10

@interface EVInviteCell : EVGroupedTableViewCell

@property (nonatomic, strong) UIView *profilePicture;
@property (nonatomic, strong) UIImageView *defaultAvatar;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *inviteButton;

@property (nonatomic, assign) BOOL shouldInvite;
@property (nonatomic, strong) void (^handleSelection)(id identifier);
@property (nonatomic, strong) void (^handleDeselection)(id identifier);

@property (nonatomic, strong) id identifier;

+ (float)cellHeight;
- (void)loadProfilePicture;

- (CGRect)nameLabelFrame;
- (CGRect)inviteButtonFrame;
@end
