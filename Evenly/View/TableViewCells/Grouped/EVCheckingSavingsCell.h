//
//  EVCheckingSavingsCell.h
//  Evenly
//
//  Created by Joseph Hankin on 7/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"
#import "EVCheckmarkButton.h"

@interface EVCheckingSavingsCell : EVGroupedTableViewCell

@property (nonatomic, strong) EVCheckmarkButton *checkingButton;
@property (nonatomic, strong) EVCheckmarkButton *savingsButton;

@end
