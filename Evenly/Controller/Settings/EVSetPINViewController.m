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

#define CONFIRM_TEXT @"Confirm Your Passcode"
#define FAILED_TEXT @"Please Try Again"

@interface EVSetPINViewController ()

@property (nonatomic, strong) NSString *enteredPin;

@end

@implementation EVSetPINViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Set Passcode";
    }
    return self;
}

- (void)userEnteredPIN:(NSString *)pin {
    if (!self.enteredPin) {
        self.enteredPin = pin;
        [self slideInNewPinView];
        [self.instructionsLabel fadeToText:CONFIRM_TEXT withColor:[EVColor darkLabelColor] duration:0.2];
    }
    else {
        if ([self.enteredPin isEqualToString:pin])
            [self handleCorrectPin];
        else
            [self handleIncorrectPin];
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
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.pinView.frame = leftFrame;
                         newView.frame = middleFrame;
                     } completion:^(BOOL finished) {
                         [self.pinView removeFromSuperview];
                         self.pinView = newView;
                     }];
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
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.pinView.frame = rightFrame;
                         newView.frame = middleFrame;
                     } completion:^(BOOL finished) {
                         [self.pinView removeFromSuperview];
                         self.pinView = newView;
                     }];
}
@end
