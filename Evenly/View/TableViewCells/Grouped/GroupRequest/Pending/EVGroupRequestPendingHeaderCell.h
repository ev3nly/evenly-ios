//
//  EVGroupRequestDetailCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVTransactionDetailCell.h"

@interface EVGroupRequestPendingHeaderCell : EVTransactionDetailCell

@property (nonatomic, strong) UILabel *memoLabel;

+ (CGFloat)cellHeightForStory:(EVStory *)story memo:(NSString *)memo;

@end
