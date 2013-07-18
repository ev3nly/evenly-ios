//
//  EVExchangeViewController_NEW.h
//  Evenly
//
//  Created by Joseph Hankin on 7/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPushPopViewController.h"

#import "EVAutocompleteTableViewController.h" 

#import "EVPageControl.h"
#import "EVPrivacySelectorView.h"

#import "EVExchangeWhoView.h"

typedef enum {
    EVExchangePhaseWho = 0,
    EVExchangePhaseHowMuch,
    EVExchangePhaseWhatFor
} EVExchangePhase;

@interface EVExchangeViewController : EVPushPopViewController <EVAutocompleteTableViewControllerDelegate>

@property (nonatomic) EVExchangePhase phase;
@property (nonatomic, strong) NSArray *leftButtons;
@property (nonatomic, strong) NSArray *rightButtons;

@property (nonatomic, strong) EVPageControl *pageControl;

@property (nonatomic, strong) EVAutocompleteTableViewController *autocompleteTableViewController;
@property (nonatomic, strong) EVExchangeWhoView *initialView;

@property (nonatomic, strong) EVPrivacySelectorView *privacySelector;

#pragma mark - Basic Interface

- (void)addContact:(id)contact;
- (void)advancePhase;
- (void)sendExchangeToServer;

#pragma mark - View Loading

- (void)loadNavigationButtons;

- (void)loadPageControl;
- (void)unloadPageControlAnimated:(BOOL)animated;

- (void)loadPrivacySelector;
- (CGRect)privacySelectorFrame;
- (void)loadContentViews;
- (void)loadAutocomplete;
- (void)setUpReactions;

#pragma mark - Nav Bar Buttons

- (void)setUpNavBar;
- (UIButton *)leftButtonForPhase:(EVExchangePhase)phase;
- (UIButton *)rightButtonForPhase:(EVExchangePhase)phase;

#pragma mark - Button Actions

- (void)cancelButtonPress:(id)sender;
- (void)backButtonPress:(id)sender;
- (void)nextButtonPress:(id)sender;
- (void)actionButtonPress:(id)sender;

#pragma mark - Validation

- (BOOL)shouldAdvanceToHowMuch;
- (BOOL)shouldAdvanceToWhatFor;
- (BOOL)shouldPerformAction;

@end
