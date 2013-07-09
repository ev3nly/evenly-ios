//
//  EVFacebookInviteCell.m
//  Evenly
//
//  Created by Justin Brunet on 7/2/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVFacebookInviteCell.h"
#import <FacebookSDK/FacebookSDK.h>

@interface EVFacebookInviteCell ()

@property (nonatomic, strong) FBProfilePictureView *profilePicture;

@end

@implementation EVFacebookInviteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

    }
    return self;
}

- (void)loadProfilePicture {
    self.profilePicture = [FBProfilePictureView new];
    self.profilePicture.pictureCropping = FBProfilePictureCroppingSquare;
    [self addSubview:self.profilePicture];
    [super loadProfilePicture];
}

- (void)setName:(NSString *)name profileID:(NSString *)profileID {
    if (![profileID isEqualToString:self.profilePicture.profileID]) {
        [self.profilePicture removeFromSuperview];
        [self loadProfilePicture];
    }
    self.nameLabel.text = name;
    self.profilePicture.profileID = profileID;
    self.identifier = profileID;
}

@end
