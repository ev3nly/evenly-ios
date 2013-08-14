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

@interface EVGettingStartedViewController : EVModalViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) EVGettingStartedType type;

@end
