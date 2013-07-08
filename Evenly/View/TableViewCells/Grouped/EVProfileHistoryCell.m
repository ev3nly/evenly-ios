//
//  EVProfileHistoryCell.m
//  Evenly
//
//  Created by Justin Brunet on 6/21/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVProfileHistoryCell.h"
#import "EVAvatarView.h"

#define PROFILE_HISTORY_INTERIOR_MARGIN 10.0
#define PROFILE_HISTORY_LABEL_HEIGHT 44.0
#define PROFILE_HISTORY_INCOME_ICON_BUFFER 8

@interface EVProfileHistoryCell ()

@property (nonatomic, strong) EVAvatarView *avatarView;
@property (nonatomic, strong) UILabel *storyLabel;
@property (nonatomic, strong) UIImageView *incomeIcon;

@end

@implementation EVProfileHistoryCell

+ (CGFloat)cellHeight {
    return (PROFILE_HISTORY_INTERIOR_MARGIN + [EVAvatarView avatarSize].height + PROFILE_HISTORY_INTERIOR_MARGIN);
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
        
        [self loadAvatarView];
        [self loadStoryLabel];
        [self loadIncomeIcon];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.avatarView.frame = [self avatarViewFrame];
    self.incomeIcon.frame = [self incomeIconFrame];
    self.storyLabel.frame = [self storyLabelFrame];
}

#pragma mark - Loading

- (void)loadAvatarView {
    self.avatarView = [[EVAvatarView alloc] initWithFrame:CGRectMake(0, 0, PROFILE_HISTORY_LABEL_HEIGHT, PROFILE_HISTORY_LABEL_HEIGHT)];
    [self addSubview:self.avatarView];
}

- (void)loadStoryLabel {
    self.storyLabel = [UILabel new];
    self.storyLabel.backgroundColor = [UIColor clearColor];
    self.storyLabel.numberOfLines = 3;
    self.storyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.storyLabel.font = [EVFont defaultFontOfSize:15.0];
    [self addSubview:self.storyLabel];
}

- (void)loadIncomeIcon {
    self.incomeIcon = [[UIImageView alloc] initWithImage:[EVImages incomeIcon]];
    [self addSubview:self.incomeIcon];
}

#pragma mark - Setters

- (void)setStory:(EVStory *)story {
    _story = story;
    
    if ([[story.subject dbid] isEqualToString:[EVCIA me].dbid] && story.target)
        self.avatarView.avatarOwner = story.target;
    else
        self.avatarView.avatarOwner = story.subject;
    
    self.storyLabel.attributedText = [story attributedString];
    self.incomeIcon.image = [self iconForStoryType:story.storyType];
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

- (CGRect)avatarViewFrame {
    return CGRectMake(PROFILE_HISTORY_INTERIOR_MARGIN*2,
                      PROFILE_HISTORY_INTERIOR_MARGIN,
                      self.avatarView.size.width,
                      self.avatarView.size.height);
}

- (CGRect)incomeIconFrame {
    CGSize iconSize = self.incomeIcon.image.size;
    return CGRectMake(self.bounds.size.width - iconSize.width - PROFILE_HISTORY_INCOME_ICON_BUFFER - PROFILE_HISTORY_INTERIOR_MARGIN,
                      PROFILE_HISTORY_INCOME_ICON_BUFFER,
                      iconSize.width,
                      iconSize.height);
}

- (CGRect)storyLabelFrame {
    float xOrigin = CGRectGetMaxX(self.avatarView.frame) + PROFILE_HISTORY_INTERIOR_MARGIN*2;
    return CGRectMake(xOrigin,
                      PROFILE_HISTORY_INTERIOR_MARGIN,
                      self.incomeIcon.frame.origin.x - PROFILE_HISTORY_INTERIOR_MARGIN - xOrigin,
                      PROFILE_HISTORY_LABEL_HEIGHT);
}

@end
