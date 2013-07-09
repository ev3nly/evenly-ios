//
//  EVContactInviteCell.m
//  Evenly
//
//  Created by Justin Brunet on 7/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVContactInviteCell.h"

@interface EVContactInviteCell ()

@property (nonatomic, strong) UIImageView *profilePicture;

@end

@implementation EVContactInviteCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)loadProfilePicture {
    self.profilePicture = [UIImageView new];
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

@end
