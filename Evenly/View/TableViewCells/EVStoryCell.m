//
//  EVStoryCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVStoryCell.h"
#import "EVStory.h"
#import "EVAvatarView.h"

#define EV_STORY_CELL_BACKGROUND_MARGIN 12.0

@interface EVStoryCell ()

@property (nonatomic, strong) UIView *horizontalRule;
@property (nonatomic, strong) UIView *verticalRule;

- (void)loadBackground;
- (void)loadAvatarView;
- (void)loadStoryLabel;
- (void)loadRules;

@end

@implementation EVStoryCell

+ (CGFloat)cellHeight {
    return 112.0;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self loadBackground];
        [self loadAvatarView];
        [self loadStoryLabel];
        [self loadRules];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)loadBackground {
    UIImage *image = [UIImage imageNamed:@"FeedContainer"];
    self.tombstoneBackground = [[UIImageView alloc] initWithImage:image];
    self.tombstoneBackground.frame = CGRectMake(EV_STORY_CELL_BACKGROUND_MARGIN,
                                                EV_STORY_CELL_BACKGROUND_MARGIN,
                                                image.size.width,
                                                image.size.height);
    [self.contentView addSubview:self.tombstoneBackground];
}

- (void)loadAvatarView {
    self.avatarView = [[EVAvatarView alloc] initWithFrame:CGRectMake(10, 10, [EVAvatarView avatarSize].width, [EVAvatarView avatarSize].height)];
    [self.tombstoneBackground addSubview:self.avatarView];
}

- (void)loadStoryLabel {
    self.storyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarView.frame) + 10,
                                                                10,
                                                                200,
                                                                44)];
    self.storyLabel.backgroundColor = [UIColor clearColor];
    self.storyLabel.numberOfLines = 3;
    self.storyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.storyLabel.font = [EVFont defaultFontOfSize:15.0];
    [self.tombstoneBackground addSubview:self.storyLabel];
}

- (void)loadRules {
    self.horizontalRule = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.tombstoneBackground.frame.size.width, 1)];
    self.horizontalRule.backgroundColor = [EVColor newsfeedStripeColor];
    [self.tombstoneBackground addSubview:self.horizontalRule];
    
    self.verticalRule = [[UIView alloc] initWithFrame:CGRectMake(148, 64, 1, self.tombstoneBackground.frame.size.height - 64)];
    self.verticalRule.backgroundColor = [EVColor newsfeedStripeColor];
    [self.tombstoneBackground addSubview:self.verticalRule];
}


- (void)setStory:(EVStory *)story {
    _story = story;
    self.storyLabel.attributedText = [story attributedString];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
