//
//  EVExchangeViewController_NEW.m
//  Evenly
//
//  Created by Joseph Hankin on 7/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchangeViewController.h"
#import "EVExchange.h"
#import "EVGroupRequest.h"
#import "ABContactsHelper.h"
#import "EVBackButton.h"
#import "EVNavigationBarButton.h"
#import "EVValidator.h"

#define TITLE_PAGE_CONTROL_Y_OFFSET 5.0

@interface EVExchangeViewController ()

@property (nonatomic, strong) NSArray *leftButtons;
@property (nonatomic, strong) NSArray *rightButtons;

@end

@implementation EVExchangeViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.phase = EVExchangePhaseWho;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(tokenAddedByReturnPress:)
                                                     name:EVExchangeWhoViewAddedTokenFromReturnPressNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView {
    [super loadView];
    
    [self loadNavigationButtons];
    [self loadPageControl];
    [self loadPrivacySelector];
    [self loadContentViews];
    [self loadAutocomplete];
    [self setUpReactions];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.pageControl.center = [self pageControlCenter];
    self.privacySelector.frame = [self privacySelectorFrame];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.initialView becomeFirstResponder];
}

#pragma mark - Loading

- (void)loadNavigationButtons {
    self.leftButtons = [self leftNavBarButtons];
    self.rightButtons = [self rightNavBarButtons];
}

- (void)loadPageControl {
    self.pageControl = [[EVPageControl alloc] init];
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;
    [self.pageControl sizeToFit];
    [self.navigationController.navigationBar addSubview:self.pageControl];
    CGFloat positionAdjustment = -TITLE_PAGE_CONTROL_Y_OFFSET;
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:positionAdjustment
                                                                  forBarMetrics:UIBarMetricsDefault];
    CGRect rect = self.titleLabel.frame;
    rect.origin.y += positionAdjustment;
    [self.navigationItem.titleView setFrame:rect];
}

- (void)loadPrivacySelector {
    _privacySelector = [[EVPrivacySelectorToggle alloc] initWithFrame:[self privacySelectorFrame]];
}

- (void)loadContentViews {
    // abstract
}

- (void)loadAutocomplete {
    self.autocompleteTableViewController = [[EVAutocompleteTableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.autocompleteTableViewController.delegate = self;
    self.autocompleteTableViewController.inputField = self.initialView.toField.textField;
    
    [self.initialView setAutocompleteTableView:self.autocompleteTableViewController.tableView];
}

- (void)setUpReactions {
    // abstract
}

- (void)unloadPageControlAnimated:(BOOL)animated {
    [self.pageControl removeFromSuperview];
    self.pageControl = nil;
    [UIView animateWithDuration:(animated ? EV_DEFAULT_ANIMATION_DURATION : 0.0) animations:^{
        [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:0
                                                                      forBarMetrics:UIBarMetricsDefault];
    } completion:nil];
}

#pragma mark - Basic Interface

- (void)addContact:(id)contact {
    if ([contact isKindOfClass:[ABContact class]]) {
		EVContact *toContact = [[EVContact alloc] init];
        if ([contact hasPhoneNumber])
            toContact.phoneNumber = [EVStringUtility strippedPhoneNumber:[contact evenlyContactString]];
        else
            toContact.email = [[contact emailArray] objectAtIndex:0];
        toContact.name = [contact compositeName];
        contact = toContact;
    }
    [self.initialView addContact:contact];
}

- (void)sendExchangeToServer {
    // abstract
}

#pragma mark - Nav Bar Buttons

- (NSArray *)leftNavBarButtons {
    NSMutableArray *leftButtons = [NSMutableArray array];
    UIButton *button;
    
    button = [self defaultCancelButton];
    [button addTarget:self action:@selector(cancelButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [leftButtons addObject:button];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button] animated:NO];
    
    button = [EVBackButton button];
    [button addTarget:self action:@selector(backButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [leftButtons addObject:button];
    
    button = [EVBackButton button];
    [button addTarget:self action:@selector(backButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [leftButtons addObject:button];
    
    return leftButtons;
}

- (NSArray *)rightNavBarButtons {
    NSMutableArray *rightButtons = [NSMutableArray array];
    UIButton *button;
    
    button = [[EVNavigationBarButton alloc] initWithTitle:@"Next"];
    [button addTarget:self action:@selector(nextButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [rightButtons addObject:button];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button] animated:NO];
    
    button = [[EVNavigationBarButton alloc] initWithTitle:@"Next"];
    [button addTarget:self action:@selector(nextButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [rightButtons addObject:button];
    
    button = [[EVNavigationBarButton alloc] initWithTitle:[self actionButtonText]];
    [button addTarget:self action:@selector(actionButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [rightButtons addObject:button];

    return rightButtons;
}

- (void)setUpNavBar {
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[self leftButtonForPhase:self.phase]] animated:YES];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[self rightButtonForPhase:self.phase]] animated:YES];
    [self.pageControl setCurrentPage:self.phase];
}

- (UIButton *)leftButtonForPhase:(EVExchangePhase)phase {
    return [self.leftButtons objectAtIndex:phase];
}

- (UIButton *)rightButtonForPhase:(EVExchangePhase)phase {
    return [self.rightButtons objectAtIndex:phase];
}

#pragma mark - Button Actions

- (void)backButtonPress:(id)sender {
    [self popViewAnimated:YES];
    self.phase--;
    [self setUpNavBar];
}

- (void)nextButtonPress:(id)sender {
    if (self.phase == EVExchangePhaseWho) {
        NSString *toFieldContents = self.initialView.toField.textField.text;
        if ([[EVValidator sharedValidator] stringIsValidEmail:toFieldContents] || [toFieldContents isPhoneNumber]) {
            [self.initialView addTokenFromField:self.initialView.toField];
            [self.autocompleteTableViewController handleFieldInput:nil];
        } else {
            [self advancePhase];
        }
    } else {
        [self advancePhase];
    }
}

- (void)actionButtonPress:(id)sender {
    if (![self shouldPerformAction])
        return;
    
    [sender setEnabled:NO];
    self.navigationItem.leftBarButtonItem = nil;
    [self sendExchangeToServer];
}

#pragma mark - Advancing

- (void)advancePhase {
    if (self.phase == EVExchangePhaseWho && [self shouldAdvanceToHowMuch]) {
        [self advanceToHowMuch];
        self.phase = EVExchangePhaseHowMuch;
    } else if (self.phase == EVExchangePhaseHowMuch && [self shouldAdvanceToWhatFor]) {
        [self advanceToWhatFor];
        self.phase = EVExchangePhaseWhatFor;
    }
    [self setUpNavBar];
}

- (void)advanceToHowMuch {
    //abstract
}
- (void)advanceToWhatFor {
    //abstract
}

#pragma mark - Validation 

- (BOOL)shouldAdvanceToHowMuch {
    return YES; // abstract
}

- (BOOL)shouldAdvanceToWhatFor {
    return YES; // abstract
}

- (BOOL)shouldPerformAction {
    return YES; // abstract
}

#pragma mark - UITableViewDelegate

- (void)autocompleteViewController:(EVAutocompleteTableViewController *)viewController didSelectContact:(id)contact {
    [self addContact:contact];
}

- (void)tokenAddedByReturnPress:(NSNotification *)notification {
    [self.autocompleteTableViewController handleFieldInput:nil];
}

#pragma mark - Utility

- (void)setVisibilityForExchange:(EVExchange *)exchange {
    EVPrivacySetting privacySetting = [EVCIA me].privacySetting;
    if (!exchange.to.dbid && exchange.to.email)
        privacySetting = EVPrivacySettingPrivate;
    exchange.visibility = [EVStringUtility stringForPrivacySetting:privacySetting];
}

- (NSString *)actionButtonText {
    return nil; //abstract
}

#pragma mark - Frames

- (CGPoint)pageControlCenter {
    return CGPointMake(self.navigationController.navigationBar.frame.size.width / 2.0,
                       self.titleLabel.frame.size.height + 5.0);
}

- (CGRect)privacySelectorFrame {
    BOOL shouldShowPrivacySelector = NO;
    for (EVObject<EVExchangeable> *recipient in [self.initialView recipients]) {
        if (recipient.dbid)
            shouldShowPrivacySelector = YES;
    }
    self.privacySelector.hidden = !shouldShowPrivacySelector;
    
    float yOrigin = self.view.bounds.size.height - EV_DEFAULT_KEYBOARD_HEIGHT - [EVPrivacySelectorToggle lineHeight];
    return CGRectMake(0,
                      yOrigin,
                      self.view.bounds.size.width,
                      [EVPrivacySelectorToggle lineHeight] * [EVPrivacySelectorToggle numberOfLines]);
}

@end
