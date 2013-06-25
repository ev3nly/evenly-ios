//
//  EVSignUpViewController.h
//  Evenly
//
//  Created by Justin Brunet on 6/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVEditProfileViewController.h"

typedef enum {
    EVSignUpCellRowPhoto,
    EVSignUpCellRowName,
    EVSignUpCellRowEmail,
    EVSignUpCellRowPhoneNumber,
    EVSignUpCellRowPassword,
    EVSignUpCellRowConfirmPassword,
    EVSignUpCellRowCOUNT
} EVSignUpCellRow;

@interface EVSignUpViewController : EVEditProfileViewController <UITextFieldDelegate>

@end
