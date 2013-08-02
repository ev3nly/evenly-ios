//
//  EVWalletNotificationDetailCell.h
//  Evenly
//
//  Created by Joseph Hankin on 8/2/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPendingDetailCell.h"

#define UNCONFIRMED_NOTIFICATION_CELL_HEIGHT 300.0

@class EVWalletNotificationViewController;

@interface EVWalletNotificationDetailCell : EVPendingDetailCell

@property (nonatomic, weak) EVWalletNotificationViewController *notificationController;
@property (nonatomic, strong) UIButton *actionButton;

@end
