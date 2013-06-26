//
//  EVGroupRequestPaymentOptionCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"

@class EVGroupRequestRecord;

@interface EVGroupRequestPaymentOptionCell : EVGroupedTableViewCell

@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) NSMutableArray *optionButtons;

- (void)setRecord:(EVGroupRequestRecord *)record;
- (CGFloat)heightForRecord:(EVGroupRequestRecord *)record;

@end