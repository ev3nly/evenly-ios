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
#import "EVStory.h"

#define EV_STORY_CELL_VERTICAL_RULE_HEIGHT 36.0
#define EV_STORY_CELL_BACKGROUND_MARGIN 12.0

@interface EVStoryCell : UITableViewCell

+ (CGFloat)cellHeight;

@property (nonatomic, weak) EVStory *story;
@property (nonatomic, strong) UIImageView *tombstoneBackground;
@property (nonatomic, strong) UIImageView *typeIndicator;
@property (nonatomic, strong) EVAvatarView *avatarView;
@property (nonatomic, strong) UILabel *storyLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) EVLikeButton *likeButton;

- (void)loadStoryLabel;
- (CGRect)avatarViewFrame;
- (CGRect)storyLabelFrame;
- (CGRect)horizontalRuleFrame;

@end
