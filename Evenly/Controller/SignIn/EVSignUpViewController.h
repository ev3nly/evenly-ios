//
//  EVSignUpViewController.h
//  Evenly
//
//  Created by Justin Brunet on 6/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVEditProfileViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "TTTAttributedLabel.h"

typedef enum {
    EVSignUpCellRowPhotoNameEmail,
    EVSignUpCellRowPhoneNumber,
    EVSignUpCellRowPassword,
    EVSignUpCellRowCOUNT
} EVSignUpCellRow;

@interface EVSignUpViewController : EVEditProfileViewController <UITextFieldDelegate, TTTAttributedLabelDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) void (^authenticationSuccess)(void);

- (id)initWithSignUpSuccess:(void (^)(void))success;
- (id)initWithSignUpSuccess:(void (^)(void))success user:(EVUser *)user;

@end
