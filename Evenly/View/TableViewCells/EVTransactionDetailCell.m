//
//  EVTransactionDetailCell.m
//  Evenly
//
//  Created by Justin Brunet on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVTransactionDetailCell.h"

#define AVATAR_LENGTH 80
#define AVATAR_TOP_BUFFER 20
#define AVATAR_SIDE_BUFFER 20
#define TEXT_BUFFER 10

@implementation EVTransactionDetailCell

+ (CGFloat)cellHeightForStory:(EVStory *)story {
    float labelHeight = [story.attributedString boundingRectWithSize:CGSizeMake(AVATAR_LENGTH*2 + AVATAR_SIDE_BUFFER*2, 100000)
                                                                     options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                     context:NULL].size.height;
    return EV_STORY_CELL_BACKGROUND_MARGIN + AVATAR_TOP_BUFFER + AVATAR_LENGTH + TEXT_BUFFER + labelHeight + TEXT_BUFFER + EV_STORY_CELL_VERTICAL_RULE_HEIGHT;
}

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadRightAvatarView];
        self.avatarView.cornerRadius = 8.0;
        [self.avatarView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftAvatarTapped)]];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.rightAvatarView.frame = [self rightAvatarViewFrame];
}

#pragma mark - Loading

- (void)loadStoryLabel {
    [super loadStoryLabel];
    self.storyLabel.textAlignment = NSTextAlignmentCenter;
    self.storyLabel.numberOfLines = 0;
    self.storyLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

- (void)loadRightAvatarView {
    self.rightAvatarView = [[EVAvatarView alloc] initWithFrame:self.bounds];
    self.rightAvatarView.cornerRadius = 8.0;
    [self.tombstoneBackground addSubview:self.rightAvatarView];
    [self.rightAvatarView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightAvatarTapped)]];
}

#pragma mark - Gesture Handling

- (void)leftAvatarTapped {
    [self.delegate avatarTappedForUser:self.story.subject];
}

- (void)rightAvatarTapped {
    [self.delegate avatarTappedForUser:self.story.target];
}

#pragma mark - Setters

- (void)setStory:(EVStory *)story {
    [super setStory:story];

    self.avatarView.avatarOwner = story.subject;
    self.rightAvatarView.avatarOwner = story.target;
}

#pragma mark - Frames

- (CGRect)avatarViewFrame {
    self.avatarView.size = CGSizeMake(AVATAR_LENGTH, AVATAR_LENGTH);
    float xOrigin = CGRectGetMidX(self.tombstoneBackground.bounds) - self.avatarView.size.width - AVATAR_SIDE_BUFFER;
    if (!self.story.target)
        xOrigin = CGRectGetMidX(self.tombstoneBackground.bounds) - self.avatarView.size.width/2;
    return CGRectMake(xOrigin,
                      AVATAR_TOP_BUFFER,
                      self.avatarView.size.width,
                      self.avatarView.size.height);
}

- (CGRect)rightAvatarViewFrame {
    if (!self.story.target)
        return CGRectZero;
    self.rightAvatarView.size = CGSizeMake(AVATAR_LENGTH, AVATAR_LENGTH);
    return CGRectMake(CGRectGetMidX(self.tombstoneBackground.bounds) + AVATAR_SIDE_BUFFER,
                      AVATAR_TOP_BUFFER,
                      self.avatarView.size.width,
                      self.avatarView.size.height);
}

- (CGRect)storyLabelFrame {
    float yOrigin = CGRectGetMaxY(self.avatarView.frame) + TEXT_BUFFER;
    float maxWidth = (AVATAR_LENGTH*2 + AVATAR_SIDE_BUFFER*2);
    float labelHeight = [self.storyLabel.attributedText boundingRectWithSize:CGSizeMake(maxWidth, 100000)
                                                                     options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                     context:NULL].size.height;
    float xOrigin = CGRectGetMidX(self.tombstoneBackground.bounds) - maxWidth/2;
    return CGRectMake(xOrigin,
                      yOrigin,
                      maxWidth,
                      labelHeight);
}

- (CGRect)incomeIconFrame {
    if (!self.story.target)
        return CGRectZero;
    return CGRectMake(CGRectGetMidX(self.tombstoneBackground.bounds) - self.incomeIcon.image.size.width/2,
                      CGRectGetMidY(self.avatarView.frame) - self.incomeIcon.image.size.height/2,
                      self.incomeIcon.image.size.width,
                      self.incomeIcon.image.size.height);
}

@end
