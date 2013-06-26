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
#import "EVNavigationBarButton.h"

#import "EVSession.h"

#define LOGO_BUFFER (([UIApplication sharedApplication].keyWindow.bounds.size.height > 480) ? 30 : 14)
#define FORM_VIEW_TAG 9372

@interface EVSignInViewController ()

@property (nonatomic, strong) EVNavigationBarButton *doneButton;
@property (nonatomic, strong) UIImageView *logo;
@property (nonatomic, strong) UIButton *labelButton;

- (void)loadDoneButton;
- (void)loadForm;
- (void)setUpReactions;

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
        self.canDismissManually = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadDoneButton];
    [self loadLogo];
    [self loadForm];
    [self loadLabelButton];
    [self setUpReactions];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(findAndResignFirstResponder)]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [[self.view viewWithTag:FORM_VIEW_TAG] setNeedsLayout];
    [[self.view viewWithTag:FORM_VIEW_TAG] layoutIfNeeded];
    self.labelButton.frame = [self labelButtonFrame];
}

- (void)loadDoneButton {
    self.doneButton = [[EVNavigationBarButton alloc] initWithTitle:@"Done"];
    [self.doneButton addTarget:self action:@selector(doneButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.doneButton];
}

- (void)loadLogo {
    self.logo = [[UIImageView alloc] initWithImage:[EVImages grayLogo]];
    self.logo.frame = CGRectMake(CGRectGetMidX(self.view.bounds) - [EVImages grayLogo].size.width/2,
                                 LOGO_BUFFER,
                                 [EVImages grayLogo].size.width,
                                 [EVImages grayLogo].size.height);
    [self.view addSubview:self.logo];
}

- (void)loadForm {
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
    self.emailField.returnKeyType = UIReturnKeyNext;
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
    self.passwordField.returnKeyType = UIReturnKeyGo;
    
    [(EVTextField *)self.emailField setNext:self.passwordField];
    
    [passwordRow setContentView:self.passwordField];
    
    EVFormView *formView = [[EVFormView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.logo.frame) + LOGO_BUFFER, 300, 50)];
    formView.tag = FORM_VIEW_TAG;
    [self.view addSubview:formView];
    [formView setFormRows:@[ emailRow, passwordRow ]];
}

- (void)loadLabelButton {
    self.labelButton = [UIButton new];
    [self.labelButton addTarget:self action:@selector(forgotPasswordButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.labelButton setTitle:@"Forgot your password?" forState:UIControlStateNormal];
    [self.labelButton setTitleColor:[EVColor lightLabelColor] forState:UIControlStateNormal];
    [self.labelButton setTitleColor:[EVColor darkLabelColor] forState:UIControlStateHighlighted];
    self.labelButton.titleLabel.font = [EVFont blackFontOfSize:15];
    [self.view addSubview:self.labelButton];
}

- (void)setUpReactions {
    RACSignal *formValidSignal = [RACSignal combineLatest:@[self.emailField.rac_textSignal,
                                  self.passwordField.rac_textSignal]
                                                   reduce:^(NSString *email, NSString *password) {
                                                       return @([email isEmail] && [password length] > 0);
                                                   }];
    
    RAC(self.doneButton.enabled) = formValidSignal;
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
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"SIGNING IN..."];
    
    [EVSession createWithEmail:self.emailField.text password:self.passwordField.text success:^{
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
        [EVStatusBarManager sharedManager].completion = ^(void) {
            if (self.authenticationSuccess)
                self.authenticationSuccess();
            [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
        };
        DLog(@"Logged in.");
        [[EVCIA sharedInstance] cacheNewSession];

    } failure:^(NSError *error) {
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
        DLog(@"Failure?! %@", error);
    }];
}

- (void)doneButtonPress:(id)sender {
    [self.view findAndResignFirstResponder];
    [self signIn];
}

- (void)forgotPasswordButtonPressed {
    [[[UIAlertView alloc] initWithTitle:@"Oh no!" message:@"Sorry about that.  Think harder" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    NSLog(@"PASSWORD YAH KNO?!");
}

- (CGRect)labelButtonFrame {
    return CGRectMake(0,
                      CGRectGetMaxY([self.view viewWithTag:FORM_VIEW_TAG].frame) + LOGO_BUFFER,
                      self.view.bounds.size.width,
                      LOGO_BUFFER);
}

@end
