//
//  EVGettingStartedViewController.h
//  Evenly
//
//  Created by Justin Brunet on 8/13/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVModalViewController.h"

typedef enum {
    EVGettingStartedTypeAll,
    EVGettingStartedTypePayment,
    EVGettingStartedTypeRequest,
    EVGettingStartedTypeDeposit
} EVGettingStartedType;

@interface EVGettingStartedViewController : EVModalViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) EVGettingStartedType type;
@property (nonatomic, strong) EVViewController *controllerToShow;

- (id)initWithType:(EVGettingStartedType)type;

@end
