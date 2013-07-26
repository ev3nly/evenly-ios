//
//  EVSetPINViewController.m
//  Evenly
//
//  Created by Justin Brunet on 6/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVSetPINViewController.h"

#define LOGO_TOP_BUFFER 40
#define LOGO_LABEL_BUFFER 20
#define LABEL_SQUARE_BUFFER 20
#define SQUARE_HEIGHT 54

#define ENTER_OLD_TEXT @"Enter Old Passcode"
#define ENTER_NEW_TEXT @"Enter New Passcode"
#define CONFIRM_TEXT @"Confirm Your Passcode"
#define FAILED_TEXT @"Please Try Again"

@interface EVSetPINViewController ()

@property (nonatomic, assign) EVEnterPINState currentState;
@property (nonatomic, strong) NSString *enteredPin;

@end

@implementation EVSetPINViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Set Passcode";
        if (![[EVPINUtility sharedUtility] pinIsSet])
            self.currentState = EVEnterPINStateEnterNew;
    }
    return self;
}

- (void)loadSignOutBarButton {
    //don't even try it
}

- (void)userEnteredPIN:(NSString *)pin {
    if (self.currentState == EVEnterPINStateEnterOld) {
        if ([[EVPINUtility sharedUtility] isValidPIN:pin]) {
            [self slideInNewPinView];
            [self.instructionsLabel fadeToText:ENTER_NEW_TEXT withColor:[EVColor darkLabelColor] duration:0.2];
            self.currentState = EVEnterPINStateEnterNew;
        } else {
            [super handleIncorrectPin];
        }
    } else if (self.currentState == EVEnterPINStateEnterNew) {
        self.enteredPin = pin;
        [self slideInNewPinView];
        [self.instructionsLabel fadeToText:CONFIRM_TEXT withColor:[EVColor darkLabelColor] duration:0.2];
        self.currentState = EVEnterPINStateConfirmNew;
    } else if (self.currentState == EVEnterPINStateConfirmNew) {
        if ([self.enteredPin isEqualToString:pin])
            [self handleCorrectPin];
        else {
            EV_DISPATCH_AFTER(0.1, ^{
                [self handleIncorrectPin];
            });
            self.currentState = EVEnterPINStateEnterNew;
        }
    }
}

- (void)handleCorrectPin {
    [[EVPINUtility sharedUtility] setPIN:self.enteredPin];
    [super handleCorrectPin];
}

- (void)handleIncorrectPin {
    self.enteredPin = nil;
    [self slideBackPinView];
    [self.instructionsLabel fadeToText:FAILED_TEXT withColor:[EVColor lightRedColor] duration:0.2];
}

- (void)slideInNewPinView {
    EVPINView *newView = [EVPINView new];
    [self configureHandlerOnPinView:newView];
    [self.view addSubview:newView];
    
    CGRect middleFrame = self.pinView.frame;
    CGRect leftFrame = middleFrame;
    leftFrame.origin.x -= leftFrame.size.width;
    CGRect rightFrame = middleFrame;
    rightFrame.origin.x += rightFrame.size.width;
    
    newView.frame = rightFrame;
    [self.pinView bounceAnimationToFrame:leftFrame duration:0.25 completion:nil];
    EV_DISPATCH_AFTER(0.2, ^{
        [newView bounceAnimationToFrame:middleFrame duration:0.25 completion:^{
            [self.pinView removeFromSuperview];
            self.pinView = newView;
        }];
    });
}

- (void)slideBackPinView {
    EVPINView *newView = [EVPINView new];
    [self configureHandlerOnPinView:newView];
    [self.view addSubview:newView];
    
    CGRect middleFrame = self.pinView.frame;
    CGRect leftFrame = middleFrame;
    leftFrame.origin.x -= leftFrame.size.width;
    CGRect rightFrame = middleFrame;
    rightFrame.origin.x += rightFrame.size.width;
    
    newView.frame = leftFrame;
    [self.pinView bounceAnimationToFrame:rightFrame duration:0.25 completion:nil];
    EV_DISPATCH_AFTER(0.2, ^{
        [newView bounceAnimationToFrame:middleFrame duration:0.25 completion:^{
            [self.pinView removeFromSuperview];
            self.pinView = newView;
        }];
    });
}

- (NSString *)enterPinPrompt {
    return (self.currentState == EVEnterPINStateEnterOld ? ENTER_OLD_TEXT : ENTER_NEW_TEXT);
}

@end
