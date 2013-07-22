//
//  EVEnterPINViewController.h
//  Evenly
//
//  Created by Justin Brunet on 6/26/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVModalViewController.h"
#import "EVPINView.h"
#import "EVPINUtility.h"
#import <QuartzCore/QuartzCore.h>

@interface EVEnterPINViewController : EVModalViewController

@property (nonatomic, strong) UILabel *instructionsLabel;
@property (nonatomic, strong) EVPINView *pinView;

- (void)loadSignOutBarButton;

- (void)userEnteredPIN:(NSString *)pin;
- (void)handleCorrectPin;
- (void)handleIncorrectPin;

- (void)configureHandlerOnPinView:(EVPINView *)pinView;

- (NSString *)enterPinPrompt;

@end
