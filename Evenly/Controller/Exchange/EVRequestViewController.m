//
//  EVRequestViewController_NEW.m
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRequestViewController.h"
#import "EVNavigationBarButton.h"
#import "EVBackButton.h"
#import "EVUserAutocompletionCell.h"
#import "EVKeyboardTracker.h"

#import "ABContactsHelper.h"

#import "EVRequest.h"
#import "EVGroupRequest.h"


@interface EVRequestViewController ()



@property (nonatomic) BOOL isGroupRequest;
@property (nonatomic) BOOL hasRecipients;
@property (nonatomic) BOOL canGoToHowMuchPhase;

@end

@implementation EVRequestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"New Request";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.initialView becomeFirstResponder];
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
    
    button = [[EVNavigationBarButton alloc] initWithTitle:@"Request"];
    [button addTarget:self action:@selector(requestButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [button setEnabled:NO];
    [right addObject:button];
    
    self.leftButtons = [NSArray arrayWithArray:left];
    self.rightButtons = [NSArray arrayWithArray:right];
}

- (void)loadContentViews {
    self.initialView = [[EVRequestWhoView alloc] initWithFrame:[self.view bounds]];
    self.initialView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    self.singleAmountView = [[EVExchangeHowMuchView alloc] initWithFrame:[self contentViewFrame]];
    self.singleAmountView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    self.multipleAmountsView = [[EVRequestMultipleAmountsView alloc] initWithFrame:[self.view bounds]];
    self.multipleAmountsView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    self.singleDetailsView = [[EVExchangeWhatForView alloc] initWithFrame:[self.view bounds]];
    self.singleDetailsView.autoresizingMask = EV_AUTORESIZE_TO_FIT;    
    
    self.multipleDetailsView = [[EVRequestMultipleDetailsView alloc] initWithFrame:[self.view bounds]];
    self.multipleDetailsView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    
    [self.view addSubview:self.initialView];
    [self.viewStack addObject:self.initialView];
    [self.view bringSubviewToFront:self.privacySelector];
}

- (CGRect)contentViewFrame {
    return CGRectMake(0, 0, self.view.frame.size.width, self.view.bounds.size.height - EV_DEFAULT_KEYBOARD_HEIGHT);
}

- (void)loadAutocomplete {
    self.autocompleteTableViewController = [[EVAutocompleteTableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.autocompleteTableViewController.delegate = self;
    self.autocompleteTableViewController.inputField = self.initialView.toField.textField;
    
    [self.initialView setAutocompleteTableView:self.autocompleteTableViewController.tableView];
}

- (void)setUpReactions {

    // Handle the first screen: if it's a group request, and if not, if it has at least one recipient.
    RAC(self.isGroupRequest) = RACAble(self.initialView.requestSwitch.on);
    
    [RACAble(self.isGroupRequest) subscribeNext:^(NSNumber *isGroupRequest) {
        [self validateForPhase:EVExchangePhaseWho];
    }];
    
    [RACAble(self.initialView.recipientCount) subscribeNext:^(NSNumber *hasRecipients) {
        [self validateForPhase:EVExchangePhaseWho];
    }];
    
    // SECOND SCREEN:
    // Single:
    [self.singleAmountView.amountField.rac_textSignal subscribeNext:^(NSString *amountString) {
        [self validateForPhase:EVExchangePhaseHowMuch];
    }];
    // Multiple:
    [RACAble(self.multipleAmountsView.isValid) subscribeNext:^(NSNumber *isValid) {
        [self validateForPhase:EVExchangePhaseHowMuch];
    }];
    
    // THIRD SCREEN:
    // Single
    [self.singleDetailsView.descriptionField.rac_textSignal subscribeNext:^(NSString *descriptionString) {
        [self validateForPhase:EVExchangePhaseWhatFor];
    }];
    // Multiple
    [self.multipleDetailsView.nameField.rac_textSignal subscribeNext:^(NSString *nameString) {
        [self validateForPhase:EVExchangePhaseWhatFor];
    }];
}

- (void)validateForPhase:(EVExchangePhase)phase {
    UIButton *button = [self rightButtonForPhase:phase];
    if (phase == EVExchangePhaseWho)
    {
        if (self.isGroupRequest) {
            [button setEnabled:YES];
            NSString *title = (self.initialView.recipientCount ? @"Next" : @"Skip");
            [button setTitle:title forState:UIControlStateNormal];
        } else {
            [button setEnabled:(BOOL)self.initialView.recipientCount];
            [button setTitle:@"Next" forState:UIControlStateNormal];
        }
    }
    else if (phase == EVExchangePhaseHowMuch)
    {
        if (!self.isGroupRequest)
        {
            float amount = [[EVStringUtility amountFromAmountString:self.singleAmountView.amountField.text] floatValue];
            BOOL okay = (amount >= EV_MINIMUM_EXCHANGE_AMOUNT);
            [button setEnabled:okay];
            [self.singleAmountView.minimumAmountLabel setHidden:okay];
        }
        else
        {
            [button setEnabled:self.multipleAmountsView.isValid];
        }
    }
    else if (phase == EVExchangePhaseWhatFor)
    {
        if (!self.isGroupRequest)
            [button setEnabled:!EV_IS_EMPTY_STRING(self.singleDetailsView.descriptionField.text)];
        else
            [button setEnabled:!EV_IS_EMPTY_STRING(self.multipleDetailsView.nameField.text)];
    }
}

#pragma mark - Button Actions

- (void)cancelButtonPress:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)backButtonPress:(id)sender {
    [self popViewAnimated:YES];
    self.phase--;
    [self setUpNavBar];
    [self validateForPhase:self.phase];
}

- (void)nextButtonPress:(id)sender {
    if (self.phase == EVExchangePhaseWho)
    {
        if (!self.isGroupRequest)
        {
            self.request = [[EVRequest alloc] init];
            EVObject<EVExchangeable> *recipient = [[self.initialView recipients] lastObject];
            self.request.to = recipient;
            [self.singleAmountView.titleLabel setText:[NSString stringWithFormat:@"%@ owes me", [recipient name]]];
            [self pushView:self.singleAmountView animated:YES];
            // Give the privacy selector to the single details view.
            [self.singleDetailsView addSubview:self.privacySelector];
        }
        else
        {
            self.groupRequest = [[EVGroupRequest alloc] init];
            self.groupRequest.members = [self.initialView recipients];
            [self pushView:self.multipleAmountsView animated:YES];
            // Give the privacy selector to the multiple details view.
            [self.multipleDetailsView addSubview:self.privacySelector];
        }
        self.phase = EVExchangePhaseHowMuch;
    }
    else if (self.phase == EVExchangePhaseHowMuch)
    {
        if (!self.isGroupRequest)
        {
            self.request.amount = [EVStringUtility amountFromAmountString:self.singleAmountView.amountField.text];
            NSString *title = [NSString stringWithFormat:@"%@ owes me %@", self.request.to.name, [EVStringUtility amountStringForAmount:self.request.amount]];
            [self.singleDetailsView.titleLabel setText:title];
            [self pushView:self.singleDetailsView animated:YES];
        }
        else
        {
            self.groupRequest.tiers = self.multipleAmountsView.tiers;
            [self pushView:self.multipleDetailsView animated:YES];
        }
        self.phase = EVExchangePhaseWhatFor;
    }
    [self setUpNavBar];
    [self validateForPhase:self.phase];
}

- (void)requestButtonPress:(id)sender {
    [sender setEnabled:NO];
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"SENDING REQUEST..."];
    
    if (!self.isGroupRequest)
    {
        self.request.memo = self.singleDetailsView.descriptionField.text;
        [self.request saveWithSuccess:^{
            [[EVCIA sharedInstance] reloadPendingSentExchangesWithCompletion:NULL];
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
            [EVStatusBarManager sharedManager].duringSuccess = ^(void) {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            };
        } failure:^(NSError *error) {
            DLog(@"failed to create %@", NSStringFromClass([self.request class]));
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
            [sender setEnabled:YES];
        }];
    }
    else
    {
        self.groupRequest.title = self.multipleDetailsView.nameField.text;
        self.groupRequest.memo = self.multipleDetailsView.descriptionField.text;
        DLog(@"Group request dictionary representation: %@", [self.groupRequest dictionaryRepresentation]);

        [self.groupRequest saveWithSuccess:^{
            [[EVCIA sharedInstance] reloadPendingSentExchangesWithCompletion:NULL];
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
            [EVStatusBarManager sharedManager].duringSuccess = ^(void) {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            };
        } failure:^(NSError *error) {
            DLog(@"failed to create %@", NSStringFromClass([self.request class]));
            [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
        }];
    }
}

#pragma mark - UITableViewDelegate


- (void)autocompleteViewController:(EVAutocompleteTableViewController *)viewController didSelectContact:(id)contact {
    if ([contact isKindOfClass:[ABContact class]]) {
        NSString *emailAddress = [[contact emailArray] objectAtIndex:0];
		EVContact *toContact = [[EVContact alloc] init];
		toContact.email = emailAddress;
        toContact.name = [contact compositeName];
        contact = toContact;
    }
    [self.initialView addContact:contact];
}

@end
