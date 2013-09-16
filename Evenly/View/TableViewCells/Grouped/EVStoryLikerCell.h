//
//  EVStoryLikerCell.h
//  Evenly
//
//  Created by Joseph Hankin on 9/16/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"
#import "EVAvatarView.h"

@class EVUser;

@interface EVStoryLikerCell : EVGroupedTableViewCell

@property (nonatomic, strong) EVUser *liker;
@property (nonatomic, strong) EVAvatarView *avatarView;
@property (nonatomic, strong) UILabel *likerLabel;

@end
