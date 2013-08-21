//
//  EVHistoryCell.h
//  Evenly
//
//  Created by Justin Brunet on 6/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"

@interface EVHistoryCell : EVGroupedTableViewCell

+ (float)heightGivenSubtitle:(NSString *)subtitle;
- (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle amount:(NSDecimalNumber *)amount;

@end
