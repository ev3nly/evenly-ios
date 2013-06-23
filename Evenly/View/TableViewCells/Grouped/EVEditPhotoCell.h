//
//  EVEditPhotoCell.h
//  Evenly
//
//  Created by Justin Brunet on 6/21/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"
#import "EVAvatarView.h"

@interface EVEditPhotoCell : EVGroupedTableViewCell

@property (nonatomic, strong) EVAvatarView *avatarView;

+ (float)cellHeight;

@end
