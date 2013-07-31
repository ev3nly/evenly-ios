//
//  EVTippingViewController.m
//  Evenly
//
//  Created by Justin Brunet on 7/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVTippingViewController.h"
#import "EVExchangeHowMuchView.h"
#import "EVExchangeWhatForView.h"
#import "EVNavigationBarButton.h"
#import "EVBackButton.h"
#import "EVValidator.h"

@interface EVTippingViewController ()

@end

@implementation EVTippingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Tipping";
    }
    return self;
}

#pragma mark - View Loading

- (UIBarButtonItem *)cancelButton {
    UIImage *closeImage = [EVImages navBarCancelButton];
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, closeImage.size.width + 20.0, closeImage.size.height)];
    [cancelButton setImage:closeImage forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    cancelButton.adjustsImageWhenHighlighted = NO;
    cancelButton.showsTouchWhenHighlighted = YES;
    return [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
}

- (void)setUpReactions {
    [RACAble(self.initialView.recipientCount) subscribeNext:^(NSNumber *hasRecipients) {
        if ([hasRecipients integerValue] == 1)
            [self advancePhase];
    }];
}

#pragma mark - Basic Interface

- (void)advancePhase {
//    if (self.phase == EVExchangePhaseWho)
//    {
//        if (![self shouldAdvanceToHowMuch])
//            return;
//        
//        self.payment = [[EVPayment alloc] init];
//        EVObject<EVExchangeable> *recipient = [[self.initialView recipients] lastObject];
//        self.payment.to = recipient;
//        [self.howMuchView.titleLabel setText:[NSString stringWithFormat:@"Pay %@...", [recipient name]]];
//        [self pushView:self.howMuchView animated:YES];
//        
//        self.phase = EVExchangePhaseHowMuch;
//    }
//    else if (self.phase == EVExchangePhaseHowMuch)
//    {
//        if (![self shouldAdvanceToWhatFor])
//            return;
//        
//        self.payment.amount = [EVStringUtility amountFromAmountString:self.howMuchView.amountField.text];
//        EVExchangeWhatForHeader *header = [EVExchangeWhatForHeader paymentHeaderForPerson:self.payment.to amount:self.payment.amount];
//        self.whatForView.whatForHeader = header;
//        [self pushView:self.whatForView animated:YES];
//        
//        self.phase = EVExchangePhaseWhatFor;
//    }
//    [self setUpNavBar];
}

- (void)sendExchangeToServer {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"SENDING PAYMENT..."];
    
//    self.payment.memo = self.whatForView.descriptionField.text;
//    [self setVisibilityForExchange:self.payment];
//    
//    [self.payment saveWithSuccess:^{
//        
//        // Don't allow the balance to fall below 0.  If a payment amount is > available balance, it gets
//        // paid via credit card, leaving the balance unaffected.
//        NSDecimalNumber *newBalance = [[[EVCIA me] balance] decimalNumberBySubtracting:self.payment.amount];
//        if ([newBalance compare:[NSDecimalNumber zero]] != NSOrderedAscending) {
//            [[EVCIA me] setBalance:newBalance];
//        }
//        [[EVCIA sharedInstance] reloadPendingSentExchangesWithCompletion:NULL];
//        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
//        
//        EVStory *story = [EVStory storyFromCompletedExchange:self.payment];
//        story.publishedAt = [NSDate date];
//        [[NSNotificationCenter defaultCenter] postNotificationName:EVStoryLocallyCreatedNotification object:nil userInfo:@{ @"story" : story }];
//        
//        void (^completion)(void) = NULL;
//        
//        if (self.payment.reward)
//        {
//            EVRewardsGameViewController *rewardsViewController = [[EVRewardsGameViewController alloc] initWithReward:self.payment.reward];
//            [self unloadPageControlAnimated:YES];
//            completion = ^{
//                [self.navigationController pushViewController:rewardsViewController animated:YES];
//            };
//        } else {
//            completion = ^(void) {
//                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//            };
//        }
//        [EVStatusBarManager sharedManager].duringSuccess = completion;
//        
//    } failure:^(NSError *error) {
//        DLog(@"failed to create %@", NSStringFromClass([self.payment class]));
//        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
//        [[self rightButtonForPhase:self.phase] setEnabled:YES];
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self leftButtonForPhase:self.phase]];
//    }];
}

#pragma mark - View Loading



- (void)nextButtonPress:(id)sender {
    if (self.phase == EVExchangePhaseWho)
    {
        NSString *toFieldContents = self.initialView.toField.textField.text;
        if ([[EVValidator sharedValidator] stringIsValidEmail:toFieldContents]) {
            [self.initialView addTokenFromField:self.initialView.toField];
            [self.autocompleteTableViewController handleFieldInput:nil];
        } else {
            [self advancePhase];
        }
    }
    else
    {
        [super nextButtonPress:sender];
    }
}

#pragma mark - Validation

- (BOOL)shouldAdvanceToHowMuch {
    if (self.initialView.recipientCount == 0) {
        [self.initialView flashMessage:@"You've got to tell us who you want to pay!"
                               inFrame:self.initialView.toFieldFrame
                          withDuration:2.0];
        return NO;
    }
    return YES;
}

- (BOOL)shouldAdvanceToWhatFor {
    float amount = [[EVStringUtility amountFromAmountString:self.howMuchView.amountField.text] floatValue];
    BOOL okay = (amount >= EV_MINIMUM_EXCHANGE_AMOUNT);
    if (!okay)
    {
        [self.howMuchView.bigAmountView flashMinimumAmountLabel];
        return NO;
    }
    return YES;
}

- (BOOL)shouldPerformAction {
    if (EV_IS_EMPTY_STRING(self.whatForView.descriptionField.text))
    {
        [self.whatForView flashNoDescriptionMessage];
        return NO;
    }
    return YES;
}

- (NSString *)actionButtonText {
    return @"Tipping";
}

@end
