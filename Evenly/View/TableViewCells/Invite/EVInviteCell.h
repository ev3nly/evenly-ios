//
//  EVInviteCell.h
//  Evenly
//
//  Created by Justin Brunet on 7/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"

@interface EVInviteCell : EVGroupedTableViewCell

@property (nonatomic, strong) UIView *profilePicture;
@property (nonatomic, strong) UIImageView *defaultAvatar;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *inviteButton;

@property (nonatomic, assign) BOOL shouldInvite;
@property (nonatomic, strong) void (^handleSelection)(NSString *profileID);
@property (nonatomic, strong) void (^handleDeselection)(NSString *profileID);

@property (nonatomic, strong) id identifier;

+ (float)cellHeight;
- (void)loadProfilePicture;

@end
