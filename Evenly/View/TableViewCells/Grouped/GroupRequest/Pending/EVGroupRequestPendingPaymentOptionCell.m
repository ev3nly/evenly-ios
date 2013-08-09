//
//  EVGroupRequestPendingPaymentOptionCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestPendingPaymentOptionCell.h"
#import "EVGroupRequestRecord.h"
#import "EVGroupRequestTier.h"

#define BUTTON_HEIGHT 44.0
#define TOP_BOTTOM_MARGIN 10.0
#define LEFT_RIGHT_MARGIN 10.0

#define PAY_IN_FULL_TEXT @"PAY IN FULL"
#define PAY_PARTIAL_TEXT @"PAY PARTIAL"
#define DECLINE_TEXT @"DECLINE REQUEST"

@implementation EVGroupRequestPendingPaymentOptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.payInFullButton = [[EVGrayButton alloc] initWithFrame:CGRectZero];
        [self.payInFullButton setTitle:PAY_IN_FULL_TEXT forState:UIControlStateNormal];
        [self.contentView addSubview:self.payInFullButton];
        
        self.declineButton = [[EVGrayButton alloc] initWithFrame:CGRectZero];
        [self.declineButton setTitle:DECLINE_TEXT forState:UIControlStateNormal];
        [self.contentView addSubview:self.declineButton];
    }
    return self;
}

- (void)setRecord:(EVGroupRequestRecord *)record {
    [super setRecord:record];
    if (record.tier) {
        [self.payInFullButton setTitle:[NSString stringWithFormat:@"PAY %@", [EVStringUtility amountStringForAmount:record.amountOwed]]
                              forState:UIControlStateNormal];
    } else {
        [self.payInFullButton setTitle:PAY_IN_FULL_TEXT forState:UIControlStateNormal];
    }
    
    [self.payInFullButton setEnabled:(record.tier != nil)];
    if ([record numberOfPayments] > 0) {
        [self.declineButton removeFromSuperview];
    } else {
        [self.contentView addSubview:self.declineButton];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat previousY = CGRectGetMaxY(self.headerLabel.frame) + TOP_BOTTOM_MARGIN;
    UIButton *lastButton = [self.optionButtons lastObject];
    if (lastButton) {
        previousY = CGRectGetMaxY(lastButton.frame) + TOP_BOTTOM_MARGIN;
    }
    
    [self.payInFullButton setFrame:CGRectMake(LEFT_RIGHT_MARGIN, previousY, self.contentView.frame.size.width - 2*LEFT_RIGHT_MARGIN, BUTTON_HEIGHT)];
    previousY += BUTTON_HEIGHT + TOP_BOTTOM_MARGIN;
    [self.declineButton setFrame:CGRectMake(LEFT_RIGHT_MARGIN, previousY, self.contentView.frame.size.width - 2*LEFT_RIGHT_MARGIN, BUTTON_HEIGHT)];
}

- (CGFloat)heightForRecord:(EVGroupRequestRecord *)record {
    CGFloat superHeight = [super heightForRecord:record];
    int buttonCount = 2;
    return superHeight + buttonCount*BUTTON_HEIGHT + buttonCount*TOP_BOTTOM_MARGIN;
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
