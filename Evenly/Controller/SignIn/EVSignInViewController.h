//
//  EVSignInViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/13/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVModalViewController.h"

@class EVTextField;

@interface EVSignInViewController : EVModalViewController <UITextFieldDelegate>

@property (nonatomic, strong) EVTextField *emailField;
@property (nonatomic, strong) EVTextField *passwordField;
@property (nonatomic, strong) void (^authenticationSuccess)(void);

- (id)initWithAuthenticationSuccess:(void (^)(void))success;

@end
