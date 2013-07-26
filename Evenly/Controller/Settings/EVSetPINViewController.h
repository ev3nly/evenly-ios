//
//  EVSetPINViewController.h
//  Evenly
//
//  Created by Justin Brunet on 6/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVEnterPINViewController.h"

typedef enum {
    EVEnterPINStateEnterOld,
    EVEnterPINStateEnterNew,
    EVEnterPINStateConfirmNew
} EVEnterPINState;

@interface EVSetPINViewController : EVEnterPINViewController

@end
