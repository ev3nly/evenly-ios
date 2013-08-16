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

@property (nonatomic, strong) UIButton *rejectButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *remindButton;

- (void)disableAllButtons;
- (void)enableAllButtons;

@end
