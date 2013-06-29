//
//  EVGroupRequestDetailCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestPendingHeaderCell.h"
#define PENDING_STORY_DATE_BUFFER 6

@implementation EVGroupRequestPendingHeaderCell

+ (CGFloat)cellHeightForStory:(EVStory *)story {
    float superHeight = [EVTransactionDetailCell cellHeightForStory:story];
    NSString *dateString = [[self timeIntervalFormatter] stringForTimeIntervalFromDate:[NSDate date]
                                                                                toDate:[story publishedAt]];
    float dateHeight = [dateString sizeWithFont:EV_STORY_CELL_DATE_LABEL_FONT
                              constrainedToSize:CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, 100000)
                                  lineBreakMode:NSLineBreakByTruncatingTail].height;
    return (superHeight + dateHeight - EV_STORY_CELL_VERTICAL_RULE_HEIGHT);
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.position = EVGroupedTableViewCellPositionTop;
        [self.likeButton removeFromSuperview];
        [self switchAvatars];
    }
    return self;
}

- (void)switchAvatars {
    id leftAvatar = self.avatarView.avatarOwner;
    id rightAvatar = self.rightAvatarView.avatarOwner;
    self.avatarView.avatarOwner = rightAvatar;
    self.rightAvatarView.avatarOwner = leftAvatar;
}

- (CGRect)verticalRuleFrame {
    return CGRectZero;
}

- (CGRect)horizontalRuleFrame {
    return CGRectZero;
}

- (CGRect)dateLabelFrame {
    CGSize labelSize = [self.dateLabel.text sizeWithFont:self.dateLabel.font
                                       constrainedToSize:CGSizeMake(self.bounds.size.width, 100000)
                                           lineBreakMode:self.dateLabel.lineBreakMode];
    return CGRectMake(CGRectGetMidX(self.contentView.bounds) - labelSize.width/2,
                      CGRectGetMaxY(self.storyLabel.frame) + PENDING_STORY_DATE_BUFFER,
                      labelSize.width,
                      labelSize.height);
}

- (CGRect)likeButtonFrame {
    return CGRectZero;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
