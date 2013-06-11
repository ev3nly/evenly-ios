//
//  EVStoryCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVStoryCell.h"
#import "EVStory.h"

#import <FormatterKit/TTTTimeIntervalFormatter.h>

#define EV_STORY_CELL_BACKGROUND_MARGIN 12.0
#define EV_STORY_CELL_INTERIOR_MARGIN 10.0
#define EV_STORY_CELL_LABEL_WIDTH 200.0
#define EV_STORY_CELL_LABEL_HEIGHT 44.0

#define EV_STORY_CELL_HORIZONTAL_RULE_Y 64.0
#define EV_STORY_CELL_VERTICAL_RULE_X 148.0


static TTTTimeIntervalFormatter *_timeIntervalFormatter;

@interface EVStoryCell ()

@property (nonatomic, strong) UIView *horizontalRule;
@property (nonatomic, strong) UIView *verticalRule;

- (void)loadBackground;
- (void)loadAvatarView;
- (void)loadStoryLabel;
- (void)loadRules;
- (void)loadDateLabel;
- (void)loadLikeButton;

@end

@implementation EVStoryCell

+ (CGFloat)cellHeight {
    return 112.0;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        });
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self loadBackground];
        [self loadAvatarView];
        [self loadStoryLabel];
        [self loadRules];
        [self loadDateLabel];
        [self loadLikeButton];
        
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
    self.tombstoneBackground.userInteractionEnabled = YES;
    [self.contentView addSubview:self.tombstoneBackground];
}

- (void)loadAvatarView {
    self.avatarView = [[EVAvatarView alloc] initWithFrame:CGRectMake(EV_STORY_CELL_INTERIOR_MARGIN,
                                                                     EV_STORY_CELL_INTERIOR_MARGIN, [EVAvatarView avatarSize].width, [EVAvatarView avatarSize].height)];
    [self.tombstoneBackground addSubview:self.avatarView];
}

- (void)loadStoryLabel {
    self.storyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarView.frame) + EV_STORY_CELL_INTERIOR_MARGIN,
                                                                EV_STORY_CELL_INTERIOR_MARGIN,
                                                                EV_STORY_CELL_LABEL_WIDTH,
                                                                EV_STORY_CELL_LABEL_HEIGHT)];
    self.storyLabel.backgroundColor = [UIColor clearColor];
    self.storyLabel.numberOfLines = 3;
    self.storyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.storyLabel.font = [EVFont defaultFontOfSize:15.0];
    [self.tombstoneBackground addSubview:self.storyLabel];
}

- (void)loadRules {
    self.horizontalRule = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   EV_STORY_CELL_HORIZONTAL_RULE_Y,
                                                                   self.tombstoneBackground.frame.size.width,
                                                                   1)];
    self.horizontalRule.backgroundColor = [EVColor newsfeedStripeColor];
    [self.tombstoneBackground addSubview:self.horizontalRule];
    
    self.verticalRule = [[UIView alloc] initWithFrame:CGRectMake(EV_STORY_CELL_VERTICAL_RULE_X,
                                                                 EV_STORY_CELL_HORIZONTAL_RULE_Y,
                                                                 1,
                                                                 self.tombstoneBackground.frame.size.height - EV_STORY_CELL_HORIZONTAL_RULE_Y)];
    self.verticalRule.backgroundColor = [EVColor newsfeedStripeColor];
    [self.tombstoneBackground addSubview:self.verticalRule];
}

- (void)loadDateLabel {
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                               EV_STORY_CELL_HORIZONTAL_RULE_Y,
                                                               EV_STORY_CELL_VERTICAL_RULE_X,
                                                               self.tombstoneBackground.frame.size.height - EV_STORY_CELL_HORIZONTAL_RULE_Y)];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    self.dateLabel.font = [EVFont boldFontOfSize:14];
    self.dateLabel.textColor = [EVColor newsfeedButtonLabelColor];
    self.dateLabel.backgroundColor = [UIColor clearColor];
    [self.tombstoneBackground addSubview:self.dateLabel];
}

- (void)loadLikeButton {
    CGRect rect = CGRectMake(EV_STORY_CELL_VERTICAL_RULE_X,
                             EV_STORY_CELL_HORIZONTAL_RULE_Y,
                             EV_STORY_CELL_VERTICAL_RULE_X,
                             self.tombstoneBackground.frame.size.height - EV_STORY_CELL_HORIZONTAL_RULE_Y);
    rect = CGRectInset(rect, 1, 1);
    self.likeButton = [[EVLikeButton alloc] initWithFrame:rect];
    [self.likeButton setTitle:@"Like"];
    [self.likeButton addTarget:self action:@selector(likeButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.tombstoneBackground addSubview:self.likeButton];
}

- (void)likeButtonPress:(id)sender {
    self.likeButton.selected = !self.likeButton.selected;
    if (self.likeButton.selected)
        [self.likeButton setTitle:@"You like this"];
    else
        [self.likeButton setTitle:@"Like"];
}

- (void)setStory:(EVStory *)story {
    _story = story;
    self.storyLabel.attributedText = [story attributedString];
    self.dateLabel.text = [_timeIntervalFormatter stringForTimeIntervalFromDate:[NSDate date]
                                                                         toDate:[story createdAt]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
