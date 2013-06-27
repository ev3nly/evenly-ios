//
//  EVEnterPINViewController.m
//  Evenly
//
//  Created by Justin Brunet on 6/26/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVEnterPINViewController.h"

#define LOGO_TOP_BUFFER 40
#define LOGO_LABEL_BUFFER 20
#define LABEL_SQUARE_BUFFER 20
#define SQUARE_HEIGHT 54

#define ENTER_TEXT @"Enter Your Passcode"
#define FAILED_TEXT @"Please Try Again"

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

- (void)loadLogo {
    self.logo = [[UIImageView alloc] initWithImage:[EVImages grayLogo]];
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

#pragma mark - PIN Handling

- (void)userEnteredPIN:(NSString *)pin {
    if ([[EVPINUtility sharedUtility] isValidPIN:pin])
        [self handleCorrectPin];
    else
        [self handleIncorrectPin];
}

- (void)handleCorrectPin {
    [self.instructionsLabel fadeToText:@"Success!" withColor:[EVColor darkLabelColor] duration:0.2];
    [self fadeInColoredLogoAndDismiss];
}

- (void)handleIncorrectPin {
    [self.instructionsLabel fadeToText:FAILED_TEXT withColor:[EVColor lightRedColor] duration:0.2];
    
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
}

- (void)fadeInColoredLogoAndDismiss {
    UIView *coloredLogo = [self freshlyColoredLogo];
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

#pragma mark - A Little View Fun

- (UIView *)freshlyColoredLogo {
    UIView *fullLogo = [[UIView alloc] initWithFrame:self.logo.frame];
    [fullLogo addSubview:[self bottomHalfOfColoredLogo]];
    [fullLogo addSubview:[self topHalfOfColoredLogo]];
    return fullLogo;
}

- (UIView *)topHalfOfColoredLogo {
    UIImageView *blueLogo = [[UIImageView alloc] initWithImage:[EVImageUtility overlayImage:self.logo.image
                                                                                  withColor:[EVColor blueColor]
                                                                                 identifier:@"blueLogoFromGray"]];
    blueLogo.frame = self.logo.bounds;
    
    UIView *topHalf = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               blueLogo.bounds.size.width,
                                                               ceilf(blueLogo.bounds.size.height/2))];
    [topHalf addSubview:blueLogo];
    topHalf.clipsToBounds = YES;
    return topHalf;
}

- (UIView *)bottomHalfOfColoredLogo {
    UIImageView *greenLogo = [[UIImageView alloc] initWithImage:[EVImageUtility overlayImage:self.logo.image
                                                                                   withColor:[EVColor lightGreenColor]
                                                                                  identifier:@"greenLogoFromGray"]];
    CGRect greenSmileFrame = self.logo.bounds;
    greenSmileFrame.origin.y -= ceilf(greenLogo.bounds.size.height/2);
    greenLogo.frame = greenSmileFrame;
    
    UIView *bottomHalf = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  ceilf(greenLogo.bounds.size.height/2),
                                                                  greenLogo.bounds.size.width,
                                                                  ceilf(greenLogo.bounds.size.height/2))];
    [bottomHalf addSubview:greenLogo];
    bottomHalf.clipsToBounds = YES;
    return bottomHalf;
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
