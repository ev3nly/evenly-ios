//
//  EVHistoryItemCell.h
//  Evenly
//
//  Created by Joseph Hankin on 7/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"

@interface EVHistoryItemCell : EVGroupedTableViewCell

+ (CGFloat)heightForValueText:(NSString *)valueText;

+ (CGFloat)valueLabelWidth;
+ (UIFont *)valueLabelFont;

+ (CGFloat)cellMinimumHeight;

@property (nonatomic, strong) UILabel *fieldLabel;
@property (nonatomic, strong) UILabel *valueLabel;

@end
