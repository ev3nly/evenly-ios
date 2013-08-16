//
//  EVGettingStartedCell.h
//  Evenly
//
//  Created by Justin Brunet on 8/13/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"

typedef enum {
    EVGettingStartedStepSignUp,
    EVGettingStartedStepConnectFacebook,
    EVGettingStartedStepConfirmEmail,
    EVGettingStartedStepAddCard,
    EVGettingStartedStepInviteFriends,
    EVGettingStartedStepSendPayment,
    EVGettingStartedStepSendRequest,
    EVGettingStartedStepAddBank
} EVGettingStartedStep;

typedef void(^EVGettingStartedCellAction)(EVGettingStartedStep step);

@interface EVGettingStartedCell : EVGroupedTableViewCell

@property (nonatomic, assign) EVGettingStartedStep step;
@property (nonatomic, strong) EVGettingStartedCellAction action;
@property (nonatomic, assign) BOOL completed;

+ (float)cellHeight;

@end
