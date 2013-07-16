//
//  EVExchangeViewController_NEW.m
//  Evenly
//
//  Created by Joseph Hankin on 7/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchangeViewController.h"
#import "ABContactsHelper.h"

#define TITLE_PAGE_CONTROL_Y_OFFSET 5.0

@interface EVExchangeViewController ()

@end

@implementation EVExchangeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.phase = EVExchangePhaseWho;
    }
    return self;
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
    
    [self.pageControl setCenter:CGPointMake(self.navigationController.navigationBar.frame.size.width / 2.0,
                                            self.titleLabel.frame.size.height + 5.0)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.initialView becomeFirstResponder];
}

#pragma mark - Basic Interface

- (void)addContact:(id)contact {
    if ([contact isKindOfClass:[ABContact class]]) {
        NSString *emailAddress = [[contact emailArray] objectAtIndex:0];
		EVContact *toContact = [[EVContact alloc] init];
		toContact.email = emailAddress;
        toContact.name = [contact compositeName];
        contact = toContact;
    }
    [self.initialView addContact:contact];
}

- (void)advancePhase {
    // abstract
}

- (void)sendExchangeToServer {
    // abstract
}

#pragma mark - View Loading


- (void)loadNavigationButtons {
    // abstract
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

- (void)unloadPageControlAnimated:(BOOL)animated {
    [self.pageControl removeFromSuperview];
    self.pageControl = nil;
    [UIView animateWithDuration:(animated ? EV_DEFAULT_ANIMATION_DURATION : 0.0) animations:^{
        [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:0
                                                                      forBarMetrics:UIBarMetricsDefault];
    } completion:^(BOOL finished) {
        
    }];
}


- (void)loadPrivacySelector {
    _privacySelector = [[EVPrivacySelectorView alloc] initWithFrame:[self privacySelectorFrame]];
}

- (CGRect)privacySelectorFrame {
    float yOrigin = self.view.bounds.size.height - EV_DEFAULT_KEYBOARD_HEIGHT - [EVPrivacySelectorView lineHeight] - self.navigationController.navigationBar.bounds.size.height;
    return CGRectMake(0,
                      yOrigin,
                      self.view.bounds.size.width,
                      [EVPrivacySelectorView lineHeight] * [EVPrivacySelectorView numberOfLines]);
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

#pragma mark - Nav Bar Buttons

- (void)setUpNavBar {
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[self leftButtonForPhase:self.phase]] animated:YES];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[self rightButtonForPhase:self.phase]] animated:YES];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self.pageControl setCurrentPage:self.phase];
}

- (UIButton *)leftButtonForPhase:(EVExchangePhase)phase {
    return [self.leftButtons objectAtIndex:phase];
}

- (UIButton *)rightButtonForPhase:(EVExchangePhase)phase {
    return [self.rightButtons objectAtIndex:phase];
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
    [self advancePhase];
}

- (void)actionButtonPress:(id)sender {
    [sender setEnabled:NO];
    self.navigationItem.leftBarButtonItem = nil;
    [self sendExchangeToServer];
}

#pragma mark - Validation 

- (void)validateForPhase:(EVExchangePhase)phase {
    // abstract
}

#pragma mark - UITableViewDelegate

- (void)autocompleteViewController:(EVAutocompleteTableViewController *)viewController didSelectContact:(id)contact {
    [self addContact:contact];
}

@end
