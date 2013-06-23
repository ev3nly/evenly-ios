//
//  EVPendingDetailCell.m
//  Evenly
//
//  Created by Justin Brunet on 6/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPendingDetailCell.h"
#import "EVPendingDetailViewController.h"

#define PENDING_BUTTON_BUFFER 10
#define PENDING_BOTTOM_SECTION_HEIGHT ([EVImages grayButtonBackground].size.height + PENDING_BUTTON_BUFFER*2)
#define PENDING_DATE_BOTTOM_SECTION_BUFFER 12
#define PENDING_STORY_DATE_BUFFER 6

@interface EVPendingDetailCell ()

@property (nonatomic, strong) UIButton *rejectButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *remindButton;

@end

@implementation EVPendingDetailCell

+ (CGFloat)cellHeightForStory:(EVStory *)story {
    float superHeight = [EVTransactionDetailCell cellHeightForStory:story];
    NSString *dateString = [[self timeIntervalFormatter] stringForTimeIntervalFromDate:[NSDate date]
                                                                          toDate:[story publishedAt]];
    float dateHeight = [dateString sizeWithFont:EV_STORY_CELL_DATE_LABEL_FONT
                              constrainedToSize:CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, 100000)
                                  lineBreakMode:NSLineBreakByTruncatingTail].height;
    float differenceInBottomSectionHeight = (PENDING_BOTTOM_SECTION_HEIGHT - EV_STORY_CELL_VERTICAL_RULE_HEIGHT);
    return (superHeight + dateHeight + PENDING_DATE_BOTTOM_SECTION_BUFFER + differenceInBottomSectionHeight);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.likeButton removeFromSuperview];
        [self switchAvatars];
    }
    return self;
}

- (void)loadRejectButton {
    self.rejectButton = [UIButton new];
    [self.rejectButton setBackgroundImage:[EVImages grayButtonBackground] forState:UIControlStateNormal];
    [self.rejectButton setBackgroundImage:[EVImages grayButtonBackgroundPress] forState:UIControlStateHighlighted];
    [self.rejectButton addTarget:self.parent action:@selector(denyRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.rejectButton setTitle:@"REJECT" forState:UIControlStateNormal];
    [self.rejectButton setTitleColor:[EVColor darkLabelColor] forState:UIControlStateNormal];
    self.rejectButton.titleLabel.font = [EVFont defaultButtonFont];
    [self.tombstoneBackground addSubview:self.rejectButton];
    self.rejectButton.frame = [self rejectButtonFrame];
}

- (void)loadConfirmButton {
    self.confirmButton = [UIButton new];
    [self.confirmButton setBackgroundImage:[EVImages blueButtonBackground] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[EVImages blueButtonBackgroundPress] forState:UIControlStateHighlighted];
    [self.confirmButton addTarget:self.parent action:@selector(confirmRequest) forControlEvents:UIControlEventTouchUpInside];
    
    [self.confirmButton setTitle:@"PAY" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [EVFont defaultButtonFont];
    [self.tombstoneBackground addSubview:self.confirmButton];
    self.confirmButton.frame = [self confirmButtonFrame];
}

- (void)loadCancelButton {
    self.cancelButton = [UIButton new];
    [self.cancelButton setBackgroundImage:[EVImages grayButtonBackground] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[EVImages grayButtonBackgroundPress] forState:UIControlStateHighlighted];
    [self.cancelButton addTarget:self.parent action:@selector(cancelRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[EVColor darkLabelColor] forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [EVFont defaultButtonFont];
    [self.tombstoneBackground addSubview:self.cancelButton];
    self.cancelButton.frame = [self rejectButtonFrame];
}

- (void)loadRemindButton {
    self.remindButton = [UIButton new];
    [self.remindButton setBackgroundImage:[EVImages blueButtonBackground] forState:UIControlStateNormal];
    [self.remindButton setBackgroundImage:[EVImages blueButtonBackgroundPress] forState:UIControlStateHighlighted];
    [self.remindButton addTarget:self.parent action:@selector(remindRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.remindButton setTitle:@"REMIND" forState:UIControlStateNormal];
    [self.remindButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.remindButton.titleLabel.font = [EVFont defaultButtonFont];
    [self.tombstoneBackground addSubview:self.remindButton];
    self.remindButton.frame = [self confirmButtonFrame];
}

#pragma mark - Setters

- (void)setStory:(EVStory *)story {
    [super setStory:story];
//    [self switchAvatars];
    [self configureButtonsForStoryType:story.storyType];
}

#pragma mark - Utility

- (void)configureButtonsForStoryType:(EVStoryType)storyType {
    if (storyType == EVStoryTypePendingIncoming) {
        [self loadCancelButton];
        [self loadRemindButton];
    } else {
        [self loadRejectButton];
        [self loadConfirmButton];
    }
}

- (void)switchAvatars {
    id leftAvatar = self.avatarView.avatarOwner;
    id rightAvatar = self.rightAvatarView.avatarOwner;
    self.avatarView.avatarOwner = rightAvatar;
    self.rightAvatarView.avatarOwner = leftAvatar;
}

#pragma mark - Frames

- (CGRect)verticalRuleFrame {
    return CGRectZero;
}

- (CGRect)dateLabelFrame {
    CGSize labelSize = [self.dateLabel.text sizeWithFont:self.dateLabel.font
                                       constrainedToSize:CGSizeMake(self.bounds.size.width, 100000)
                                           lineBreakMode:self.dateLabel.lineBreakMode];
    return CGRectMake(CGRectGetMidX(self.tombstoneBackground.bounds) - labelSize.width/2,
                      CGRectGetMaxY(self.storyLabel.frame) + PENDING_STORY_DATE_BUFFER,
                      labelSize.width,
                      labelSize.height);
}

- (CGRect)likeButtonFrame {
    return CGRectZero;
}

- (CGRect)rejectButtonFrame {
    return CGRectMake(PENDING_BUTTON_BUFFER,
                      self.horizontalRuleFrame.origin.y + PENDING_BUTTON_BUFFER,
                      (self.tombstoneBackground.bounds.size.width - PENDING_BUTTON_BUFFER*3)/2,
                      [self bottomSectionHeight] - PENDING_BUTTON_BUFFER*2);
}

- (CGRect)confirmButtonFrame {
    CGRect leftButtonFrame = self.rejectButton ? self.rejectButton.frame : self.cancelButton.frame;
    return CGRectMake(CGRectGetMaxX(leftButtonFrame) + PENDING_BUTTON_BUFFER,
                      leftButtonFrame.origin.y,
                      leftButtonFrame.size.width,
                      leftButtonFrame.size.height);
}

- (float)bottomSectionHeight {
    return PENDING_BOTTOM_SECTION_HEIGHT;
}

@end
