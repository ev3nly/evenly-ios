//
//  EVWalletNotificationDetailCell.m
//  Evenly
//
//  Created by Joseph Hankin on 8/2/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVWalletNotificationDetailCell.h"

#define PENDING_BUTTON_BUFFER 10
#define TEXT_BUFFER 10

@implementation EVWalletNotificationDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.actionButton = [UIButton new];
        [self.actionButton setBackgroundImage:[EVImages blueButtonBackground] forState:UIControlStateNormal];
        [self.actionButton setBackgroundImage:[EVImages blueButtonBackgroundPress] forState:UIControlStateHighlighted];
        [self.actionButton addTarget:self.notificationController action:@selector(sendConfirmationEmail:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.actionButton setTitle:@"RESEND CONFIRMATION EMAIL" forState:UIControlStateNormal];
        [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.actionButton.titleLabel.font = [EVFont defaultButtonFont];
        [self.contentView addSubview:self.actionButton];
        self.actionButton.frame = [self buttonFrame];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.actionButton.frame = [self buttonFrame];
}

- (CGRect)buttonFrame {
    return CGRectMake(PENDING_BUTTON_BUFFER,
                      self.horizontalRuleFrame.origin.y + PENDING_BUTTON_BUFFER,
                      (self.contentView.bounds.size.width - PENDING_BUTTON_BUFFER*2),
                      [self bottomSectionHeight] - PENDING_BUTTON_BUFFER*2);
}

- (CGRect)storyLabelFrame {
    
    
    float yOrigin = CGRectGetMaxY(self.avatarView.frame) + TEXT_BUFFER;
    float maxWidth = self.contentView.frame.size.width - 2*TEXT_BUFFER;
    float labelHeight = 0;
    if (self.storyLabel.attributedText)
        labelHeight = [self.storyLabel.attributedText boundingRectWithSize:CGSizeMake(maxWidth, 100000)
                                                                     options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                     context:NULL].size.height;
    float xOrigin = CGRectGetMidX(self.contentView.bounds) - maxWidth/2;
    return CGRectMake(xOrigin,
                      yOrigin,
                      maxWidth,
                      labelHeight);
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
