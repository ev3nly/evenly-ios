//
//  EVDashboardUserCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestUserCell.h"

@class EVWalletStamp;

@interface EVDashboardUserCell : EVGroupRequestUserCell

@property (nonatomic, strong) UILabel *owesLabel;
@property (nonatomic, strong) UILabel *owesAmountLabel;
@property (nonatomic, strong) UILabel *paidLabel;
@property (nonatomic, strong) UILabel *paidAmountLabel;
@property (nonatomic, strong) EVWalletStamp *paidStamp;

@end
