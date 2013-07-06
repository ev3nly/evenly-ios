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

@interface EVExchangeViewController_NEW : EVPushPopViewController <EVAutocompleteTableViewControllerDelegate>

@property (nonatomic) EVExchangePhase phase;
@property (nonatomic, strong) NSArray *leftButtons;
@property (nonatomic, strong) NSArray *rightButtons;

@property (nonatomic, strong) EVPageControl *pageControl;

@property (nonatomic, strong) EVAutocompleteTableViewController *autocompleteTableViewController;
@property (nonatomic, strong) EVExchangeWhoView *initialView;

@property (nonatomic, strong) EVPrivacySelectorView *privacySelector;

- (void)loadNavigationButtons;
- (void)loadPageControl;
- (void)loadPrivacySelector;
- (CGRect)privacySelectorFrame;
- (void)loadContentViews;
- (void)loadAutocomplete;
- (void)setUpReactions;

#pragma mark - Nav Bar Buttons
- (void)setUpNavBar;
- (UIButton *)leftButtonForPhase:(EVExchangePhase)phase;
- (UIButton *)rightButtonForPhase:(EVExchangePhase)phase;

- (void)validateForPhase:(EVExchangePhase)phase;

- (void)cancelButtonPress:(id)sender;
- (void)backButtonPress:(id)sender;
- (void)nextButtonPress:(id)sender;
- (void)actionButtonPress:(id)sender;

@end
