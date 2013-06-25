//
//  EVGroupRequestUserCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"
#import "EVAvatarView.h"

#define GROUP_REQUEST_USER_CELL_LARGE_FONT_SIZE 15
#define GROUP_REQUEST_USER_CELL_SMALL_FONT_SIZE 12
#define GROUP_REQUEST_USER_CELL_LABELS_LEFT_MARGIN 64.0

@interface EVGroupRequestUserCell : EVGroupedTableViewCell

@property (nonatomic, strong) EVAvatarView *avatarView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *tierLabel;

@end
