//
//  EVWalletCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVSidePanelCell.h"

@interface EVWalletCell : EVSidePanelCell

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;

@end

@interface EVWalletSectionHeader : EVSidePanelCell

@property (nonatomic, strong) UILabel *label;

@end