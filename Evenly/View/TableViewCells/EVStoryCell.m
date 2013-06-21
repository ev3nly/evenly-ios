//
//  EVStoryCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVStoryCell.h"

#define EV_STORY_CELL_BACKGROUND_MARGIN 12.0
#define EV_STORY_CELL_LABEL_WIDTH 200.0
#define EV_STORY_CELL_LABEL_HEIGHT 44.0

#define EV_STORY_CELL_HORIZONTAL_RULE_Y (self.tombstoneBackground.frame.size.height - [self bottomSectionHeight])
#define EV_STORY_CELL_VERTICAL_RULE_X (self.tombstoneBackground.image.size.width/2)

#define EV_STORY_CELL_INCOME_ICON_BUFFER 8

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

static TTTTimeIntervalFormatter *_timeIntervalFormatter;

+ (TTTTimeIntervalFormatter *)timeIntervalFormatter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
    });
    return _timeIntervalFormatter;
}

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self loadBackground];
        [self loadAvatarView];
        [self loadStoryLabel];
        [self loadRules];
        [self loadDateLabel];
        [self loadLikeButton];
        [self loadIncomeIcon];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tombstoneBackground.frame = [self tombstoneBackgroundFrame];
    self.avatarView.frame = [self avatarViewFrame];
    self.storyLabel.frame = [self storyLabelFrame];
    self.horizontalRule.frame = [self horizontalRuleFrame];
    self.verticalRule.frame = [self verticalRuleFrame];
    self.dateLabel.frame = [self dateLabelFrame];
    self.likeButton.frame = [self likeButtonFrame];
    self.incomeIcon.frame = [self incomeIconFrame];
}

#pragma mark - Loading

- (void)loadBackground {
    UIImage *image = [EVImages resizableTombstoneBackground];
    self.tombstoneBackground = [[UIImageView alloc] initWithImage:image];
    self.tombstoneBackground.userInteractionEnabled = YES;
    [self.contentView addSubview:self.tombstoneBackground];
}

- (void)loadAvatarView {
    self.avatarView = [[EVAvatarView alloc] initWithFrame:self.bounds];
    [self.tombstoneBackground addSubview:self.avatarView];
}

- (void)loadStoryLabel {
    self.storyLabel = [UILabel new];
    self.storyLabel.backgroundColor = [UIColor clearColor];
    self.storyLabel.numberOfLines = 3;
    self.storyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.storyLabel.font = [EVFont defaultFontOfSize:15.0];
    [self.tombstoneBackground addSubview:self.storyLabel];
}

- (void)loadRules {
    self.horizontalRule = [UIView new];
    self.horizontalRule.backgroundColor = [EVColor newsfeedStripeColor];
    [self.tombstoneBackground addSubview:self.horizontalRule];
    
    self.verticalRule = [UIView new];
    self.verticalRule.backgroundColor = [EVColor newsfeedStripeColor];
    [self.tombstoneBackground addSubview:self.verticalRule];
}

- (void)loadDateLabel {
    self.dateLabel = [UILabel new];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    self.dateLabel.font = EV_STORY_CELL_DATE_LABEL_FONT;
    self.dateLabel.textColor = [EVColor newsfeedButtonLabelColor];
    self.dateLabel.backgroundColor = [UIColor clearColor];
    [self.tombstoneBackground addSubview:self.dateLabel];
}

- (void)loadLikeButton {
    self.likeButton = [[EVLikeButton alloc] initWithFrame:CGRectZero];
    [self.likeButton setTitle:@"Like"];
    [self.likeButton addTarget:self action:@selector(likeButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.tombstoneBackground addSubview:self.likeButton];
}

- (void)loadIncomeIcon {
    self.incomeIcon = [[UIImageView alloc] initWithImage:[EVImages incomeIcon]];
    [self.tombstoneBackground addSubview:self.incomeIcon];
}

#pragma mark - Button Handling

- (void)likeButtonPress:(id)sender {
    self.likeButton.selected = !self.likeButton.selected;
    [self.story setLiked:!self.story.liked];
    [self.likeButton setTitle:[self.story likeButtonString]];
}

#pragma mark - Setters

- (void)setStory:(EVStory *)story {
    _story = story;
    
//    if ([[story.subject dbid] isEqualToString:[EVCIA me].dbid] && story.target)
//        self.avatarView.avatarOwner = story.target;
//    else
        self.avatarView.avatarOwner = story.subject;
    
    self.storyLabel.attributedText = [story attributedString];
    self.dateLabel.text = [[[self class] timeIntervalFormatter] stringForTimeIntervalFromDate:[NSDate date]
                                                                         toDate:[story publishedAt]];
    self.incomeIcon.image = [self iconForStoryType:story.storyType];
    [self.likeButton setSelected:story.liked];
    [self.likeButton setTitle:[story likeButtonString]];
}

#pragma mark - Utility

- (UIImage *)iconForStoryType:(EVStoryType)type {
    switch (type) {
        case EVStoryTypeNotInvolved:
            return [EVImages transferIcon];
        case EVStoryTypeIncoming:
            return [EVImages incomeIcon];
        case EVStoryTypeOutgoing:
            return [EVImages paymentIcon];
        case EVStoryTypePendingIncoming:
            return [EVImages pendingIncomeIcon];
        case EVStoryTypePendingOutgoing:
            return [EVImages pendingPaymentIcon];
        case EVStoryTypeWithdrawal:
            return [EVImages transferIcon];
        default:
            return nil;
    }
}

#pragma mark - Frames

- (CGRect)tombstoneBackgroundFrame {
    return CGRectMake(EV_STORY_CELL_BACKGROUND_MARGIN,
                      EV_STORY_CELL_BACKGROUND_MARGIN,
                      self.tombstoneBackground.image.size.width,
                      self.bounds.size.height - EV_STORY_CELL_BACKGROUND_MARGIN);
}

- (CGRect)avatarViewFrame {
    return CGRectMake(EV_STORY_CELL_INTERIOR_MARGIN,
                      EV_STORY_CELL_INTERIOR_MARGIN,
                      self.avatarView.size.width,
                      self.avatarView.size.height);
}

- (CGRect)storyLabelFrame {
    return CGRectMake(CGRectGetMaxX(self.avatarView.frame) + EV_STORY_CELL_INTERIOR_MARGIN,
                      EV_STORY_CELL_INTERIOR_MARGIN,
                      EV_STORY_CELL_LABEL_WIDTH,
                      EV_STORY_CELL_LABEL_HEIGHT);
}

- (CGRect)horizontalRuleFrame {
    return CGRectMake(0,
                      EV_STORY_CELL_HORIZONTAL_RULE_Y,
                      self.tombstoneBackground.frame.size.width,
                      1);
}

- (CGRect)verticalRuleFrame {
    return CGRectMake(EV_STORY_CELL_VERTICAL_RULE_X,
                      EV_STORY_CELL_HORIZONTAL_RULE_Y,
                      1,
                      EV_STORY_CELL_VERTICAL_RULE_HEIGHT);
}

- (CGRect)dateLabelFrame {
    return CGRectMake(0,
                      EV_STORY_CELL_HORIZONTAL_RULE_Y,
                      EV_STORY_CELL_VERTICAL_RULE_X,
                      self.tombstoneBackground.frame.size.height - EV_STORY_CELL_HORIZONTAL_RULE_Y);
}

- (CGRect)likeButtonFrame {
    CGRect rect = CGRectMake(EV_STORY_CELL_VERTICAL_RULE_X,
                             EV_STORY_CELL_HORIZONTAL_RULE_Y,
                             EV_STORY_CELL_VERTICAL_RULE_X,
                             self.tombstoneBackground.frame.size.height - EV_STORY_CELL_HORIZONTAL_RULE_Y);
    rect = CGRectInset(rect, 1, 1);
    return rect;
}

- (CGRect)incomeIconFrame {
    CGSize iconSize = self.incomeIcon.image.size;
    return CGRectMake(self.tombstoneBackground.bounds.size.width - iconSize.width - EV_STORY_CELL_INCOME_ICON_BUFFER,
                      EV_STORY_CELL_INCOME_ICON_BUFFER,
                      iconSize.width,
                      iconSize.height);
}

- (float)bottomSectionHeight {
    return EV_STORY_CELL_VERTICAL_RULE_HEIGHT;
}

@end
