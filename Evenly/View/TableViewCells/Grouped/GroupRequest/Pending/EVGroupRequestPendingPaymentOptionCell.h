//
//  EVGroupRequestPendingPaymentOptionCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestPaymentOptionCell.h"
#import "EVGrayButton.h"

@interface EVGroupRequestPendingPaymentOptionCell : EVGroupRequestPaymentOptionCell

@property (nonatomic, strong) EVGrayButton *payInFullButton;
@property (nonatomic, strong) EVGrayButton *payPartialButton;

@end
