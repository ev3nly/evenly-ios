//
//  EVGroupRequestPendingPaymentOptionCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestPendingPaymentCell.h"
#import "EVGroupRequestRecord.h"
#import "EVGroupRequestTier.h"

#define BUTTON_HEIGHT 44.0
#define TOP_BOTTOM_MARGIN 10.0
#define LEFT_RIGHT_MARGIN 10.0

#define PAY_IN_FULL_TEXT @"PAY"
#define PAY_PARTIAL_TEXT @"PAY PARTIAL"
#define DECLINE_TEXT @"REJECT"

@implementation EVGroupRequestPendingPaymentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.payInFullButton = [[EVBlueButton alloc] initWithFrame:CGRectZero];
        [self.payInFullButton setTitle:PAY_IN_FULL_TEXT forState:UIControlStateNormal];
        [self.contentView addSubview:self.payInFullButton];
        
        self.declineButton = [[EVGrayButton alloc] initWithFrame:CGRectZero];
        [self.declineButton setTitle:DECLINE_TEXT forState:UIControlStateNormal];
        [self.contentView addSubview:self.declineButton];
    }
    return self;
}

- (void)setRecord:(EVGroupRequestRecord *)record {
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
    
    [self.declineButton setFrame:CGRectMake(LEFT_RIGHT_MARGIN, TOP_BOTTOM_MARGIN, (self.contentView.frame.size.width - 3*LEFT_RIGHT_MARGIN)/ 2, BUTTON_HEIGHT)];
    [self.payInFullButton setFrame:CGRectMake(CGRectGetMaxX(self.declineButton.frame) + LEFT_RIGHT_MARGIN, TOP_BOTTOM_MARGIN, (self.contentView.frame.size.width - 3*LEFT_RIGHT_MARGIN)/ 2, BUTTON_HEIGHT)];
}

- (CGFloat)heightForRecord:(EVGroupRequestRecord *)record {
    return TOP_BOTTOM_MARGIN*2 + BUTTON_HEIGHT;
}

@end
