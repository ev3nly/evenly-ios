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
    EVGettingStartedStepConfirmEmail,
    EVGettingStartedStepConnectFacebook,
    EVGettingStartedStepAddCard,
    EVGettingStartedStepInviteFriends,
    EVGettingStartedStepSendExchange,
    EVGettingStartedStepAddBank
} EVGettingStartedStep;

@interface EVGettingStartedCell : EVGroupedTableViewCell

@property (nonatomic, assign) EVGettingStartedStep step;

+ (float)cellHeight;

@end
