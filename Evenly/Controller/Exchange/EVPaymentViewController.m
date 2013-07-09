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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)loadNavigationButtons {
    
    NSMutableArray *left = [NSMutableArray array];
    NSMutableArray *right = [NSMutableArray array];
    UIButton *button;
    
    // Left buttons
    button = [[EVNavigationBarButton alloc] initWithTitle:@"Cancel"];
    [button addTarget:self action:@selector(cancelButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [left addObject:button];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button] animated:NO];
    
    button = [EVBackButton button];
    [button addTarget:self action:@selector(backButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [left addObject:button];
    
    button = [EVBackButton button];
    [button addTarget:self action:@selector(backButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [left addObject:button];
    
    // Right buttons
    button = [[EVNavigationBarButton alloc] initWithTitle:@"Next"];
    [button addTarget:self action:@selector(nextButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [button setEnabled:NO];
    [right addObject:button];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button] animated:NO];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    button = [[EVNavigationBarButton alloc] initWithTitle:@"Next"];
    [button addTarget:self action:@selector(nextButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [button setEnabled:NO];
    [right addObject:button];
    
    button = [[EVNavigationBarButton alloc] initWithTitle:@"Pay"];
    [button addTarget:self action:@selector(actionButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [button setEnabled:NO];
    [right addObject:button];
    
    self.leftButtons = [NSArray arrayWithArray:left];
    self.rightButtons = [NSArray arrayWithArray:right];
}

- (void)loadContentViews {
    self.initialView = [[EVPaymentWhoView alloc] initWithFrame:[self.view bounds]];
    self.initialView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    self.howMuchView = [[EVExchangeHowMuchView alloc] initWithFrame:[self.view bounds]];
    self.howMuchView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    self.whatForView = [[EVExchangeWhatForView alloc] initWithFrame:[self.view bounds]];
    self.whatForView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    [self.whatForView addSubview:self.privacySelector];

    [self.view addSubview:self.initialView];
    [self.viewStack addObject:self.initialView];
    [self.view bringSubviewToFront:self.privacySelector];
}

- (void)setUpReactions {
    
    // FIRST SCREEN:
    [RACAble(self.initialView.recipientCount) subscribeNext:^(NSNumber *hasRecipients) {
        [self validateForPhase:EVExchangePhaseWho];
        if ([hasRecipients integerValue] == 1)
            [self nextButtonPress:nil];
    }];
    
    // SECOND SCREEN:
    [self.howMuchView.amountField.rac_textSignal subscribeNext:^(NSString *amountString) {
        [self validateForPhase:EVExchangePhaseHowMuch];
    }];

    // THIRD SCREEN:
    [self.whatForView.descriptionField.rac_textSignal subscribeNext:^(NSString *descriptionString) {
        [self validateForPhase:EVExchangePhaseWhatFor];
    }];

}

- (void)validateForPhase:(EVExchangePhase)phase {
    UIButton *button = [self rightButtonForPhase:phase];
    if (phase == EVExchangePhaseWho)
    {
        [button setEnabled:(BOOL)self.initialView.recipientCount];
        [button setTitle:@"Next" forState:UIControlStateNormal];
    }
    else if (phase == EVExchangePhaseHowMuch)
    {
        float amount = [[EVStringUtility amountFromAmountString:self.howMuchView.amountField.text] floatValue];
        BOOL okay = (amount >= EV_MINIMUM_EXCHANGE_AMOUNT);
        [button setEnabled:okay];
        [self.howMuchView.minimumAmountLabel setHidden:okay];
    }
    else if (phase == EVExchangePhaseWhatFor)
    {
        [button setEnabled:!EV_IS_EMPTY_STRING(self.whatForView.descriptionField.text)];
    }
}

- (void)nextButtonPress:(id)sender {
    if (self.phase == EVExchangePhaseWho)
    {
        self.payment = [[EVPayment alloc] init];
        EVObject<EVExchangeable> *recipient = [[self.initialView recipients] lastObject];
        self.payment.to = recipient;
        [self.howMuchView.titleLabel setText:[NSString stringWithFormat:@"Pay %@...", [recipient name]]];
        [self pushView:self.howMuchView animated:YES];

        self.phase = EVExchangePhaseHowMuch;
    }
    else if (self.phase == EVExchangePhaseHowMuch)
    {
        self.payment.amount = [EVStringUtility amountFromAmountString:self.howMuchView.amountField.text];
        EVExchangeWhatForHeader *header = [EVExchangeWhatForHeader paymentHeaderForPerson:self.payment.to amount:self.payment.amount];
        self.whatForView.whatForHeader = header;
        [self pushView:self.whatForView animated:YES];

        self.phase = EVExchangePhaseWhatFor;
    }
    [self setUpNavBar];
    [self validateForPhase:self.phase];
}

- (void)actionButtonPress:(id)sender {
    [sender setEnabled:NO];
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"SENDING PAYMENT..."];
    
    self.payment.memo = self.whatForView.descriptionField.text;
    [self.payment saveWithSuccess:^{
        [[EVCIA sharedInstance] reloadPendingSentExchangesWithCompletion:NULL];
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
        
        EVStory *story = [EVStory storyFromCompletedExchange:self.payment];
        story.publishedAt = [NSDate date];
        [[NSNotificationCenter defaultCenter] postNotificationName:EVStoryLocallyCreatedNotification object:nil userInfo:@{ @"story" : story }];
        
        [EVStatusBarManager sharedManager].duringSuccess = ^(void) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        };
    } failure:^(NSError *error) {
        DLog(@"failed to create %@", NSStringFromClass([self.payment class]));
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
        [sender setEnabled:YES];
    }];
}


@end
