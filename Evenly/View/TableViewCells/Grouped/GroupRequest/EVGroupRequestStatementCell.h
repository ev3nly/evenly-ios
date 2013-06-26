//
//  EVGroupRequestStatementCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"

@class EVGroupRequestRecord;

@interface EVGroupRequestStatementCell : EVGroupedTableViewCell

+ (CGFloat)heightForRecord:(EVGroupRequestRecord *)record;
- (void)configureForRecord:(EVGroupRequestRecord *)record;

@end
