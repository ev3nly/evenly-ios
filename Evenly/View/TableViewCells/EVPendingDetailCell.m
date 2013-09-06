//
//  EVPendingDetailCell.m
//  Evenly
//
//  Created by Justin Brunet on 6/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPendingDetailCell.h"
#import "EVPendingDetailViewController.h"

#define PENDING_BUTTON_TOP_BUFFER 10
#define PENDING_BUTTON_SIDE_BUFFER ([EVUtilities userHasIOS7] ? 20 : 10)
#define PENDING_BUTTON_BUTTON_BUFFER 10
#define PENDING_BOTTOM_SECTION_HEIGHT ([EVImages grayButtonBackground].size.height + PENDING_BUTTON_TOP_BUFFER*2)
#define PENDING_DATE_BOTTOM_SECTION_BUFFER 0
#define PENDING_STORY_DATE_BUFFER 6

@interface EVPendingDetailCell ()

@end

@implementation EVPendingDetailCell

+ (CGFloat)cellHeightForStory:(EVStory *)story {
    float superHeight = [EVTransactionDetailCell cellHeightForStory:story];
    NSString *dateString = [[self timeIntervalFormatter] stringForTimeIntervalFromDate:[NSDate date]
                                                                                toDate:[story publishedAt]];
    float dateHeight = [dateString _safeBoundingRectWithSize:CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, 100000)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName: EV_STORY_CELL_DATE_LABEL_FONT}
                                                     context:NULL].size.height;
    float differenceInBottomSectionHeight = (PENDING_BOTTOM_SECTION_HEIGHT - EV_STORY_CELL_VERTICAL_RULE_HEIGHT);
    float cellHeight = (int)(superHeight + dateHeight + PENDING_DATE_BOTTOM_SECTION_BUFFER + differenceInBottomSectionHeight);
    if ((int)cellHeight % 2 != 0)
        cellHeight++;
    return cellHeight;
}

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.likeButton removeFromSuperview];
        [self switchAvatars];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.rejectButton.frame = [self rejectButtonFrame];
    self.confirmButton.frame = [self confirmButtonFrame];
    self.cancelButton.frame = [self rejectButtonFrame];
    self.remindButton.frame = [self confirmButtonFrame];
}

#pragma mark - View Loading

- (void)loadRejectButton {
    self.rejectButton = [UIButton new];
    [self.rejectButton setBackgroundImage:[EVImages grayButtonBackground] forState:UIControlStateNormal];
    [self.rejectButton setBackgroundImage:[EVImages grayButtonBackgroundPress] forState:UIControlStateHighlighted];
    [self.rejectButton addTarget:self.parent action:@selector(denyRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.rejectButton setTitle:@"REJECT" forState:UIControlStateNormal];
    [self.rejectButton setTitleColor:[EVColor darkLabelColor] forState:UIControlStateNormal];
    self.rejectButton.titleLabel.font = [EVFont defaultButtonFont];
    [self.contentView addSubview:self.rejectButton];
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
    [self.contentView addSubview:self.confirmButton];
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
    [self.contentView addSubview:self.cancelButton];
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
    [self.contentView addSubview:self.remindButton];
    self.remindButton.frame = [self confirmButtonFrame];
}

#pragma mark - Setters

- (void)setStory:(EVStory *)story {
    [self.rejectButton removeFromSuperview];
    [self.confirmButton removeFromSuperview];
    [self.cancelButton removeFromSuperview];
    [self.remindButton removeFromSuperview];
    self.rejectButton = nil;
    self.confirmButton = nil;
    self.cancelButton = nil;
    self.remindButton = nil;
    
    [super setStory:story];
    //    [self switchAvatars];
    [self configureButtonsForStoryType:story.transactionType];
}

- (void)disableAllButtons {
    self.rejectButton.enabled = NO;
    self.confirmButton.enabled = NO;
    self.cancelButton.enabled = NO;
    self.remindButton.enabled = NO;
}

- (void)enableAllButtons {
    self.rejectButton.enabled = YES;
    self.confirmButton.enabled = YES;
    self.cancelButton.enabled = YES;
    self.remindButton.enabled = YES;
}

#pragma mark - Utility

- (void)configureButtonsForStoryType:(EVStoryTransactionType)storyType {
    if (storyType == EVStoryTransactionTypePendingIncoming) {
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
    CGSize labelSize = [self.dateLabel.text _safeBoundingRectWithSize:CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, 100000)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName: self.dateLabel.font}
                                                              context:NULL].size;
    return CGRectMake(CGRectGetMidX(self.contentView.bounds) - labelSize.width/2,
                      CGRectGetMaxY(self.storyLabel.frame) + PENDING_STORY_DATE_BUFFER,
                      labelSize.width,
                      labelSize.height);
}

- (CGRect)likeButtonFrame {
    return CGRectZero;
}

- (CGRect)rejectButtonFrame {
    return CGRectMake(PENDING_BUTTON_SIDE_BUFFER,
                      self.horizontalRuleFrame.origin.y + PENDING_BUTTON_TOP_BUFFER,
                      (self.contentView.bounds.size.width - PENDING_BUTTON_SIDE_BUFFER*2 - PENDING_BUTTON_BUTTON_BUFFER)/2,
                      [self bottomSectionHeight] - PENDING_BUTTON_TOP_BUFFER*2);
}

- (CGRect)confirmButtonFrame {
    CGRect leftButtonFrame = self.rejectButton ? self.rejectButton.frame : self.cancelButton.frame;
    return CGRectMake(CGRectGetMaxX(leftButtonFrame) + PENDING_BUTTON_BUTTON_BUFFER,
                      leftButtonFrame.origin.y,
                      leftButtonFrame.size.width,
                      leftButtonFrame.size.height);
}

- (float)bottomSectionHeight {
    return PENDING_BOTTOM_SECTION_HEIGHT;
}

@end
