//
//  EVSignInViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/13/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVSignInViewController.h"
#import "EVFormView.h"
#import "EVFormRow.h"
#import "EVTextField.h"

#import "EVSession.h"

@interface EVSignInViewController ()

@end

@implementation EVSignInViewController

- (id)init {
    return [self initWithAuthenticationSuccess:NULL];
}

- (id)initWithAuthenticationSuccess:(void (^)(void))success {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = @"Sign In";
        self.authenticationSuccess = success;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    EVFormRow *emailRow = [[EVFormRow alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    [emailRow.fieldLabel setText:@"Email"];
    self.emailField = [[EVTextField alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    self.emailField.font = [EVFont defaultFontOfSize:16];
    self.emailField.placeholderColor = [EVColor placeholderColor];
    self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailField.textAlignment = NSTextAlignmentRight;
    self.emailField.placeholder = @"example@college.edu";
    self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailField.delegate = self;
    [emailRow setContentView:self.emailField];

    EVFormRow *passwordRow = [[EVFormRow alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    [passwordRow.fieldLabel setText:@"Password"];
    self.passwordField = [[EVTextField alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    self.passwordField.font = [EVFont defaultFontOfSize:16];
    self.passwordField.placeholderColor = [EVColor placeholderColor];
    self.passwordField.textAlignment = NSTextAlignmentRight;
    self.passwordField.placeholder = @"at least 8 characters";
    self.passwordField.secureTextEntry = YES;
    self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordField.delegate = self;

    [(EVTextField *)self.emailField setNext:self.passwordField];

    [passwordRow setContentView:self.passwordField];

    EVFormView *formView = [[EVFormView alloc] initWithFrame:CGRectMake(10, 10, 300, 50)];
    [self.view addSubview:formView];
    [formView setFormRows:@[ emailRow, passwordRow ]];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([(EVTextField *)textField next]) {
        [[(EVTextField *)textField next] becomeFirstResponder];
        return NO;
    } else if (textField == self.passwordField) {
        [textField resignFirstResponder];
        [self signIn];
        return NO;
    }
    return YES;
}

- (void)signIn {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [EVSession createWithEmail:self.emailField.text password:self.passwordField.text success:^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        DLog(@"Logged in.");
        [[EVCIA sharedInstance] cacheNewSession];

        if (self.authenticationSuccess)
            self.authenticationSuccess();
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        DLog(@"Failure?! %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
