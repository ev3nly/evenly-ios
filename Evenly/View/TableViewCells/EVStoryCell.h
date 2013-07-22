//
//  EVStoryCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVGroupedTableViewCell.h"
#import "EVAvatarView.h"
#import "EVLikeButton.h"
#import "EVStory.h"

#import <FormatterKit/TTTTimeIntervalFormatter.h>

#define EV_STORY_CELL_VERTICAL_RULE_HEIGHT 36.0
#define EV_STORY_CELL_BACKGROUND_MARGIN 12.0
#define EV_STORY_CELL_INTERIOR_MARGIN 10.0
#define EV_STORY_CELL_DATE_LABEL_FONT [EVFont boldFontOfSize:14]
#define EV_STORY_CELL_VERTICAL_RULE_HEIGHT 36.0

@interface EVStoryCell : EVGroupedTableViewCell

+ (CGFloat)cellHeightForStory:(EVStory *)story;
+ (TTTTimeIntervalFormatter *)timeIntervalFormatter;

@property (nonatomic, weak) EVStory *story;
@property (nonatomic, strong) EVAvatarView *avatarView;
@property (nonatomic, strong) UILabel *storyLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIView *horizontalRule;
@property (nonatomic, strong) UIView *verticalRule;
@property (nonatomic, strong) EVLikeButton *likeButton;
@property (nonatomic, strong) UIImageView *incomeIcon;

- (void)loadStoryLabel;
- (UIImage *)iconForStoryType:(EVStoryTransactionType)type;

- (CGRect)avatarViewFrame;
- (CGRect)storyLabelFrame;
- (CGRect)horizontalRuleFrame;
- (CGRect)verticalRuleFrame;
- (CGRect)dateLabelFrame;
- (CGRect)likeButtonFrame;
- (float)bottomSectionHeight;

@end
