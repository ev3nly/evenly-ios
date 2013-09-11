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
#import "EVPrivacySelectorToggle.h"
#import "EVExchangeWhoView.h"

typedef enum {
    EVExchangePhaseWho = 0,
    EVExchangePhaseHowMuch,
    EVExchangePhaseWhatFor
} EVExchangePhase;

@interface EVExchangeViewController : EVPushPopViewController <EVAutocompleteTableViewControllerDelegate>

@property (nonatomic) EVExchangePhase phase;

@property (nonatomic, strong) EVPageControl *pageControl;
@property (nonatomic, strong) EVAutocompleteTableViewController *autocompleteTableViewController;
@property (nonatomic, strong) EVExchangeWhoView *initialView;
@property (nonatomic, strong) EVPrivacySelectorToggle *privacySelector;

#pragma mark - Basic Interface
- (void)addContact:(id)contact;
- (void)sendExchangeToServer;

#pragma mark - View Loading
- (void)loadPageControl;
- (void)loadContentViews;
- (void)setUpReactions;
- (void)unloadPageControlAnimated:(BOOL)animated;

#pragma mark - Nav Bar Buttons
- (void)setUpNavBar;
- (UIButton *)leftButtonForPhase:(EVExchangePhase)phase;
- (UIButton *)rightButtonForPhase:(EVExchangePhase)phase;

#pragma mark - Button Actions
- (void)nextButtonPress:(id)sender;

#pragma mark - Advancing
- (void)advancePhase;
- (void)advanceToHowMuch;
- (void)advanceToWhatFor;

#pragma mark - Validation
- (BOOL)shouldAdvanceToHowMuch;
- (BOOL)shouldAdvanceToWhatFor;
- (BOOL)shouldPerformAction;

#pragma mark - Utility
- (void)setVisibilityForExchange:(EVExchange *)exchange;
- (NSString *)actionButtonText;

#pragma mark - Frames
- (CGRect)exchangeViewDefaultFrame;

@end
