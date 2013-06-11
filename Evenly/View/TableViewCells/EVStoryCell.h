//
//  EVStoryCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVAvatarView.h"
#import "EVLikeButton.h"

@class EVStory;

@interface EVStoryCell : UITableViewCell

+ (CGFloat)cellHeight;

@property (nonatomic, weak) EVStory *story;
@property (nonatomic, strong) UIView *tombstoneBackground;
@property (nonatomic, strong) UIImageView *typeIndicator;
@property (nonatomic, strong) EVAvatarView *avatarView;
@property (nonatomic, strong) UILabel *storyLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) EVLikeButton *likeButton;

@end
