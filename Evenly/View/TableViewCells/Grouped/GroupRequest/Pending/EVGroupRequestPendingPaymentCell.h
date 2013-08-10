//
//  EVGroupRequestPendingPaymentOptionCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestPaymentOptionCell.h"
#import "EVGrayButton.h"
#import "EVBlueButton.h"

@interface EVGroupRequestPendingPaymentCell : EVGroupedTableViewCell

@property (nonatomic, strong) EVBlueButton *payInFullButton;
@property (nonatomic, strong) EVGrayButton *payPartialButton;
@property (nonatomic, strong) EVGrayButton *declineButton;

- (void)setRecord:(EVGroupRequestRecord *)record;
- (CGFloat)heightForRecord:(EVGroupRequestRecord *)record;

@end