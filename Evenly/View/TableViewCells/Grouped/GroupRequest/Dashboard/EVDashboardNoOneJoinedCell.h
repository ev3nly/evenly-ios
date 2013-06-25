//
//  EVDashboardNoOneJoinedCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"
#import "EVBlueButton.h"

@interface EVDashboardNoOneJoinedCell : EVGroupedTableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) EVBlueButton *inviteButton;

@end
