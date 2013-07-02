//
//  EVExchangeViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"
#import "EVExchange.h"
#import "EVExchangeFormView.h"
#import "ReactiveCocoa.h"
#import "EVPrivacySelectorView.h"
#import "EVNavigationBarButton.h"

#import "EVAutocompleteTableViewController.h"

@interface EVExchangeViewController : EVViewController <EVAutocompleteTableViewControllerDelegate>

@property (nonatomic, strong) EVNavigationBarButton *cancelButton;
@property (nonatomic, strong) EVNavigationBarButton *completeExchangeButton;

@property (nonatomic, strong) EVExchange *exchange;
@property (nonatomic, strong) NSArray *suggestions;

@property (nonatomic, strong) EVAutocompleteTableViewController *autocompleteTableViewController;

@property (nonatomic, strong) EVExchangeFormView *formView;
@property (nonatomic, strong) EVPrivacySelectorView *privacySelector;

- (NSString *)completeExchangeButtonText;
- (void)loadFormView;
- (CGRect)formViewFrame;

@end
