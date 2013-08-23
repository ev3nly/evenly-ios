//
//  EVWalletCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVSidePanelCell.h"

#define EV_WALLET_CELL_MARGIN 12.0

@class EVWalletStamp;

@interface EVWalletCell : EVSidePanelCell

@property (nonatomic, strong) UIView *containerView;

@end

@interface EVWalletSectionHeader : UIView

@property (nonatomic, strong) UILabel *label;

@end
