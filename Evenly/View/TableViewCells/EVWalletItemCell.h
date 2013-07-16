//
//  EVWalletItemCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVWalletCell.h"

@interface EVWalletItemCell : EVWalletCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) EVWalletStamp *stamp;

@end

@interface EVWalletHistoryCell : EVWalletItemCell

@end