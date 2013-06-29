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

@implementation EVGroupRequestPendingPaymentOptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.payInFullButton = [[EVGrayButton alloc] initWithFrame:CGRectZero];
        [self.payInFullButton setTitle:PAY_IN_FULL_TEXT forState:UIControlStateNormal];
        [self.contentView addSubview:self.payInFullButton];
        
        self.payPartialButton = [[EVGrayButton alloc] initWithFrame:CGRectZero];
        [self.payPartialButton setTitle:PAY_PARTIAL_TEXT forState:UIControlStateNormal];
        [self.contentView addSubview:self.payPartialButton];
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
    [self.payPartialButton setEnabled:(record.tier != nil)];
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
    [self.payPartialButton setFrame:CGRectMake(LEFT_RIGHT_MARGIN, previousY, self.contentView.frame.size.width - 2*LEFT_RIGHT_MARGIN, BUTTON_HEIGHT)];
}

- (CGFloat)heightForRecord:(EVGroupRequestRecord *)record {
    CGFloat superHeight = [super heightForRecord:record];
    return superHeight + 2*BUTTON_HEIGHT + 2*TOP_BOTTOM_MARGIN;
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
