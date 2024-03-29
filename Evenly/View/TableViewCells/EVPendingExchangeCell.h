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

+ (CGSize)sizeForInteraction:(EVObject *)object;

- (void)configureForInteraction:(EVObject *)object;

@end

@interface EVNoPendingExchangesCell : EVPendingExchangeCell

@end
