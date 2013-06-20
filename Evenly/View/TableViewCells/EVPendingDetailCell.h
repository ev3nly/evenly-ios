//
//  EVPendingDetailCell.h
//  Evenly
//
//  Created by Justin Brunet on 6/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVTransactionDetailCell.h"

@class EVPendingDetailViewController;

@interface EVPendingDetailCell : EVTransactionDetailCell

@property (nonatomic, weak) EVPendingDetailViewController *parent;

@end
