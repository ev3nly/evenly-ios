//
//  EVDashboardUserCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/20/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"
#import "EVAvatarView.h"

@interface EVDashboardUserCell : EVGroupedTableViewCell

@property (nonatomic, strong) EVAvatarView *avatarView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *tierLabel;

@property (nonatomic, strong) UILabel *owesLabel;
@property (nonatomic, strong) UILabel *owesAmountLabel;
@property (nonatomic, strong) UILabel *paidLabel;
@property (nonatomic, strong) UILabel *paidAmountLabel;

@end
