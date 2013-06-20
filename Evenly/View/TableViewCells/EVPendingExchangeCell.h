//
//  EVPendingExchangeCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVWalletCell.h"
#import "EVAvatarView.h"

@interface EVPendingExchangeCell : EVWalletCell

@property (nonatomic, strong) EVAvatarView *avatarView;
@property (nonatomic, strong) UILabel *label;

+ (CGSize)sizeForInteraction:(EVObject *)object;

@end

@interface EVNoPendingExchangesCell : EVPendingExchangeCell

@end
