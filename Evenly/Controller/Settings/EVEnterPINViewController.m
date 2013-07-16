//
//  EVEnterPINViewController.m
//  Evenly
//
//  Created by Justin Brunet on 6/26/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVEnterPINViewController.h"
#import "EVNavigationBarButton.h"
#import "EVNavigationManager.h"

#define SCALE_CONSTANT 300
#define BUFFER_SCALE ((self.view.bounds.size.height-SCALE_CONSTANT)/(504.0-SCALE_CONSTANT))

#define LOGO_TOP_BUFFER (40.0 * BUFFER_SCALE)
#define LOGO_LABEL_BUFFER (20 * BUFFER_SCALE)
#define LABEL_SQUARE_BUFFER (20 * BUFFER_SCALE)
#define SQUARE_HEIGHT 54

#define ENTER_TEXT @"Enter Your Passcode"
#define FAILED_TEXT @"Please Try Again"
#define ONE_MORE_TRY_TEXT @"1 Failure Till Logout"

@interface EVEnterPINViewController ()

@property (nonatomic, strong) UIImageView *logo;

@end

@implementation EVEnterPINViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Enter Passcode";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSignOutBarButton];
    [self loadLogo];
    [self loadInstructionsLabel];
    [self loadPINView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.logo.frame = [self logoFrame];
    self.instructionsLabel.frame = [self instructionsLabelFrame];
    if (!self.pinView.layer.animationKeys)
        self.pinView.frame = [self pinViewFrame];
}

#pragma mark - View Loading

- (void)loadSignOutBarButton {
    EVNavigationBarButton *signOutButton = [[EVNavigationBarButton alloc] initWithTitle:@"Logout"];
    [signOutButton addTarget:self action:@selector(signOutButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:signOutButton];}

- (void)loadLogo {
    self.logo = [[UIImageView alloc] initWithImage:[EVImages securityLogoGray]];
    [self.view addSubview:self.logo];
}

- (void)loadInstructionsLabel {
    self.instructionsLabel = [UILabel new];
    self.instructionsLabel.backgroundColor = [UIColor clearColor];
    self.instructionsLabel.text = ENTER_TEXT;
    self.instructionsLabel.textAlignment = NSTextAlignmentCenter;
    self.instructionsLabel.textColor = [EVColor darkLabelColor];
    self.instructionsLabel.font = [EVFont blackFontOfSize:16];
    [self.view addSubview:self.instructionsLabel];
}

- (void)loadPINView {
    self.pinView = [EVPINView new];
    [self configureHandlerOnPinView:self.pinView];
    [self.view addSubview:self.pinView];
}

#pragma mark - Sign Out

- (void)signOutButtonTapped {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [EVSession signOutWithSuccess:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:EVSessionSignedOutNotification object:nil];
            [[EVNavigationManager sharedManager].masterViewController showLoginViewControllerWithCompletion:^{
                [[EVNavigationManager sharedManager].masterViewController setCenterPanel:[[EVNavigationManager sharedManager] homeViewController]];
            }
                                                                    animated:YES
                                                       authenticationSuccess:^{
                                                       } ];
        } failure:^(NSError *error) {
            DLog(@"Error: %@", error);
        }];
    }];
}

#pragma mark - PIN Handling

- (void)userEnteredPIN:(NSString *)pin {
    if ([[EVPINUtility sharedUtility] isValidPIN:pin])
        [self handleCorrectPin];
    else
        [self handleIncorrectPin];
}

- (void)handleCorrectPin {
    [self.instructionsLabel fadeToText:@"Success!" withColor:[EVColor darkLabelColor] duration:0.3];
    [self fadeInColoredLogoAndDismiss];
}

- (void)handleIncorrectPin {
    NSString *failedText = FAILED_TEXT;
    if ([[EVPINUtility sharedUtility] failedPINAttemptCount] == EV_MAX_PIN_ATTEMPTS-1)
        failedText = ONE_MORE_TRY_TEXT;
    [self.instructionsLabel fadeToText:failedText withColor:[EVColor lightRedColor] duration:0.3];
    
    EVPINView *newView = [EVPINView new];
    [self configureHandlerOnPinView:newView];
    [self.view insertSubview:newView belowSubview:self.pinView];
    newView.frame = self.pinView.frame;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.pinView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self.pinView removeFromSuperview];
                         self.pinView = newView;
                         self.pinView.alpha = 1;
                     }];
    
    if ([[EVPINUtility sharedUtility] failedPINAttemptCount] >= EV_MAX_PIN_ATTEMPTS)
        [self.view findAndResignFirstResponder];
}

- (void)fadeInColoredLogoAndDismiss {
    UIImageView *coloredLogo = [[UIImageView alloc] initWithImage:[EVImages securityLogoColor]];
    coloredLogo.frame = self.logo.frame;
    coloredLogo.alpha = 0;
    [self.view addSubview:coloredLogo];
    [UIView animateWithDuration:0.3
                     animations:^{
                         coloredLogo.alpha = 1;
                     } completion:^(BOOL finished) {
                         EV_DISPATCH_AFTER(0.2, ^{
                             [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                         });
                     }];
}

- (void)configureHandlerOnPinView:(EVPINView *)pinView {
    __weak EVEnterPINViewController *weakSelf = self;
    pinView.handleNewPin = ^(NSString *pin) {
        [weakSelf userEnteredPIN:pin];
    };
}

#pragma mark - Frames

- (CGRect)logoFrame {
    return CGRectMake(CGRectGetMidX(self.view.bounds) - self.logo.image.size.width/2,
                      LOGO_TOP_BUFFER,
                      self.logo.image.size.width,
                      self.logo.image.size.height);
}

- (CGRect)instructionsLabelFrame {
    return CGRectMake(0,
                      CGRectGetMaxY(self.logo.frame) + LOGO_LABEL_BUFFER,
                      self.view.bounds.size.width,
                      20);
}

- (CGRect)pinViewFrame {
    return CGRectMake(0,
                      CGRectGetMaxY(self.instructionsLabel.frame) + LABEL_SQUARE_BUFFER,
                      self.view.bounds.size.width,
                      SQUARE_HEIGHT);
}

@end
