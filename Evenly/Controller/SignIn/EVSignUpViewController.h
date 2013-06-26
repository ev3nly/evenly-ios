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

@property (nonatomic, strong) void (^authenticationSuccess)(void);

- (id)initWithSignUpSuccess:(void (^)(void))success;

@end
