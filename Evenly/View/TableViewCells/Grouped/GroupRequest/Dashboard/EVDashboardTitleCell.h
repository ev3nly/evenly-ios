//
//  EVDashboardTitleCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"

@interface EVDashboardTitleCell : EVGroupedTableViewCell

@property (nonatomic, strong) UILabel *memoLabel;

+ (CGFloat)heightWithMemo:(NSString *)memo;

@end
