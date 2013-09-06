//
//  EVGroupRequestDetailCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestPendingHeaderCell.h"
#define PENDING_STORY_DATE_BUFFER 6

#define MEMO_LABEL_FONT [EVFont defaultFontOfSize:15]
#define MEMO_LABEL_WIDTH 198.0

@implementation EVGroupRequestPendingHeaderCell

+ (CGFloat)cellHeightForStory:(EVStory *)story memo:(NSString *)memo {
    if (EV_IS_EMPTY_STRING(memo))
        return [self cellHeightForStory:story];
    
    CGFloat height = [self cellHeightForStory:story];
    CGSize memoSize = [memo _safeBoundingRectWithSize:CGSizeMake(MEMO_LABEL_WIDTH, FLT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName: MEMO_LABEL_FONT}
                                              context:NULL].size;
    height += memoSize.height + PENDING_STORY_DATE_BUFFER;
    if ((int)height % 2 != 0)
        height++;
    return floorf(height);
}

+ (CGFloat)cellHeightForStory:(EVStory *)story {
    float superHeight = [EVTransactionDetailCell cellHeightForStory:story];
    NSString *dateString = [[self timeIntervalFormatter] stringForTimeIntervalFromDate:[NSDate date]
                                                                                toDate:[story publishedAt]];
    float dateHeight = [dateString _safeBoundingRectWithSize:CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, 100000)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName: EV_STORY_CELL_DATE_LABEL_FONT}
                                                     context:NULL].size.height;
    float height = (superHeight + dateHeight - EV_STORY_CELL_VERTICAL_RULE_HEIGHT);
    if ((int)height % 2 != 0)
        height++;
    return floorf(height);
}

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.memoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.memoLabel.font = MEMO_LABEL_FONT;
        self.memoLabel.backgroundColor = [UIColor clearColor];
        self.memoLabel.textColor = [EVColor lightLabelColor];
        self.memoLabel.textAlignment = NSTextAlignmentCenter;
        self.memoLabel.numberOfLines = 0;
        self.memoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.memoLabel];
        
        self.position = EVGroupedTableViewCellPositionTop;
        [self.likeButton removeFromSuperview];
        [self switchAvatars];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.memoLabel.frame = [self memoLabelFrame];
    self.dateLabel.frame = [self dateLabelFrame];
}

#pragma mark - Setters

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

- (CGRect)horizontalRuleFrame {
    return CGRectZero;
}

- (CGRect)memoLabelFrame {
    CGSize labelSize = [self.memoLabel multiLineSizeForWidth:MEMO_LABEL_WIDTH];
    return CGRectMake(CGRectGetMidX(self.contentView.bounds) - labelSize.width/2,
                      CGRectGetMaxY(self.storyLabel.frame) + PENDING_STORY_DATE_BUFFER,
                      labelSize.width,
                      labelSize.height);
}

- (CGRect)dateLabelFrame {
    float dateBuffer = EV_IS_EMPTY_STRING(self.memoLabel.text) ? 4 : PENDING_STORY_DATE_BUFFER;
    CGSize labelSize = [self.dateLabel multiLineSizeForWidth:self.bounds.size.width];
    return CGRectMake(CGRectGetMidX(self.contentView.bounds) - labelSize.width/2,
                      CGRectGetMaxY(self.memoLabel.frame) + dateBuffer,
                      labelSize.width,
                      labelSize.height);
}

- (CGRect)likeButtonFrame {
    return CGRectZero;
}

@end
