//
//  EVPaymentViewController_NEW.m
//  Evenly
//
//  Created by Joseph Hankin on 7/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPaymentViewController.h"
#import "EVNavigationBarButton.h"
#import "EVBackButton.h"
#import "EVExchangeWhatForHeader.h"
#import "EVStory.h"
#import "EVValidator.h"

#import "EVRewardsGameViewController.h"

@interface EVPaymentViewController ()

@end

@implementation EVPaymentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"New Payment";
    }
    return self;
}

#pragma mark - View Loading

- (void)loadContentViews {
    self.view.backgroundColor = [EVColor lightRedColor];
    self.initialView = [[EVPaymentWhoView alloc] initWithFrame:[self exchangeViewDefaultFrame]];
    self.initialView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    self.howMuchView = [[EVExchangeHowMuchView alloc] initWithFrame:[self exchangeViewDefaultFrame]];
    self.howMuchView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    self.whatForView = [[EVExchangeWhatForView alloc] initWithFrame:[self exchangeViewDefaultFrame]];
    self.whatForView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    [self.whatForView addSubview:self.privacySelector];
    
    [self.view addSubview:self.initialView];
    [self.viewStack addObject:self.initialView];
    [self.view bringSubviewToFront:self.privacySelector];
}

- (void)setUpReactions {
    [RACAble(self.initialView.recipientCount) subscribeNext:^(NSNumber *hasRecipients) {
        if ([hasRecipients integerValue] == 1)
            [self advancePhase];
    }];
}

#pragma mark - Basic Interface

- (void)sendExchangeToServer {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"SENDING PAYMENT..."];
    
    self.payment.memo = self.whatForView.descriptionField.text;
    [self setVisibilityForExchange:self.payment];
    
    [self.payment saveWithSuccess:^{
        // Don't allow the balance to fall below 0.  If a payment amount is > available balance, it gets
        // paid via credit card, leaving the balance unaffected.
        NSDecimalNumber *newBalance = [[[EVCIA me] balance] decimalNumberBySubtracting:self.payment.amount];
        if ([newBalance compare:[NSDecimalNumber zero]] != NSOrderedAscending) {
            [[EVCIA me] setBalance:newBalance];
        }
        [[EVCIA sharedInstance] reloadPendingSentExchangesWithCompletion:NULL];
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
        
        EVStory *story = [EVStory storyFromCompletedExchange:self.payment];
        story.publishedAt = [NSDate date];
        [[NSNotificationCenter defaultCenter] postNotificationName:EVStoryLocallyCreatedNotification object:nil userInfo:@{ @"story" : story }];
        
        void (^completion)(void) = NULL;
        
        if (self.payment.reward) {
            EVRewardsGameViewController *rewardsViewController = [[EVRewardsGameViewController alloc] initWithReward:self.payment.reward];
            [self unloadPageControlAnimated:YES];
            completion = ^{
                [self.navigationController pushViewController:rewardsViewController animated:YES];
                [EVCIA reloadMe];
            };
        } else {
            completion = ^(void) {
                [self cancelButtonPress:nil];
                [EVCIA reloadMe];
            };
        }
        [EVStatusBarManager sharedManager].duringSuccess = completion;
        
    } failure:^(NSError *error) {
        DLog(@"failed to create %@", NSStringFromClass([self.payment class]));
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
        [[self rightButtonForPhase:self.phase] setEnabled:YES];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self leftButtonForPhase:self.phase]];
    }];
}

#pragma mark - Advancing

- (void)advanceToHowMuch {
    self.payment = [[EVPayment alloc] init];
    EVObject<EVExchangeable> *recipient = [[self.initialView recipients] lastObject];
    self.payment.to = recipient;
    [self.howMuchView.titleLabel setText:[NSString stringWithFormat:@"Pay %@...", [recipient name]]];
    [self pushView:self.howMuchView animated:YES];
}

- (void)advanceToWhatFor {
    self.payment.amount = [EVStringUtility amountFromAmountString:self.howMuchView.amountField.text];
    EVExchangeWhatForHeader *header = [EVExchangeWhatForHeader paymentHeaderForPerson:self.payment.to amount:self.payment.amount];
    self.whatForView.whatForHeader = header;
    [self pushView:self.whatForView animated:YES];    
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

#pragma mark - Utility

- (NSString *)actionButtonText {
    return @"Pay";
}

@end
