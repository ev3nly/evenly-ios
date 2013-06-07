//
//  EVPendingTransactionCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVWalletCell.h"
#import "EVAvatarView.h"

@interface EVPendingTransactionCell : EVWalletCell

@property (nonatomic, strong) EVAvatarView *avatarView;

+ (CGSize)sizeForTransaction:(EVExchange *)exchange;

@end
