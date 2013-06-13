//
//  EVSignInViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/13/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"

@class EVTextField;

@interface EVSignInViewController : EVViewController <UITextFieldDelegate>

@property (nonatomic, strong) EVTextField *emailField;
@property (nonatomic, strong) EVTextField *passwordField;
@property (nonatomic, strong) void (^authenticationSuccess)(void);

@end
