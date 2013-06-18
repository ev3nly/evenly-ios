//
//  EVHistoryCell.h
//  Evenly
//
//  Created by Justin Brunet on 6/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupTableViewCell.h"

@interface EVHistoryCell : EVGroupTableViewCell

+ (float)heightGivenSubtitle:(NSString *)subtitle;
- (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle amount:(NSDecimalNumber *)amount;

@end
