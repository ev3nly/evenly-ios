//
//  EVExchangeViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchangeViewController.h"
#import "EVUserAutocompletionCell.h"
#import "EVKeyboardTracker.h"
#import "EVPayment.h"
#import "EVCharge.h"

#import "ABContactsHelper.h"

#define DEFAULT_KEYBOARD_HEIGHT 216
#define CELL_HEIGHT 40

@interface EVExchangeViewController ()

- (void)loadLeftButton;
- (void)loadRightButton;
- (void)loadPrivacySelector;
- (void)loadSuggestionsTableView;
- (void)configureReactions;

- (void)completeExchangePress:(id)sender;

- (CGRect)privacySelectorFrame;
- (CGRect)suggestionsTableViewFrame;

@end

@implementation EVExchangeViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Exchange";
        self.suggestions = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadLeftButton];
    [self loadRightButton];
    [self loadFormView];
    [self loadPrivacySelector];
    [self loadSuggestionsTableView];
    [self configureReactions];
}

#pragma mark - Setup

- (void)loadLeftButton {
    self.cancelButton = [[EVNavigationBarButton alloc] initWithTitle:@"Cancel"];
    [self.cancelButton addTarget:self action:@selector(cancelButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
}

- (void)loadRightButton {
    self.completeExchangeButton = [EVNavigationBarButton buttonWithTitle:[self completeExchangeButtonText]];
    [self.completeExchangeButton addTarget:self action:@selector(completeExchangePress:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.completeExchangeButton];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)loadFormView {
    self.formView = [[EVExchangeFormView alloc] initWithFrame:[self formViewFrame]];
    [self.view addSubview:self.formView];
}

- (void)loadPrivacySelector {
    _privacySelector = [[EVPrivacySelectorView alloc] initWithFrame:[self privacySelectorFrame]];
    [self.view addSubview:_privacySelector];
}

- (void)loadSuggestionsTableView {
    self.suggestionsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.suggestionsTableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.suggestionsTableView.delegate = self;
    self.suggestionsTableView.dataSource = self;
    self.suggestionsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.suggestionsTableView registerClass:[EVUserAutocompletionCell class]
                      forCellReuseIdentifier:@"userAutocomplete"];
    self.suggestionsTableView.separatorColor = [UIColor colorWithWhite:0.8 alpha:1.0];
}

- (void)configureReactions
{
    [self.formView.toField.rac_textSignal subscribeNext:^(NSString *toString) {
        [self handleToFieldInput:toString];
    }];
    [self.formView.amountField.rac_textSignal subscribeNext:^(NSString *amountString) {
        amountString = [amountString stringByReplacingOccurrencesOfString:@"owes me " withString:@""];
        self.exchange.amount = [NSDecimalNumber decimalNumberWithString:[amountString stringByReplacingOccurrencesOfString:@"$" withString:@""]];
    }];
    [self.formView.descriptionField.rac_textSignal subscribeNext:^(NSString *descriptionString) {
        if (![descriptionString isEqualToString:[self.formView descriptionPlaceholderText]])
            self.exchange.memo = descriptionString;
    }];
    [RACAble(self.exchange.valid) subscribeNext:^(id x) {
        BOOL valid = [(NSNumber *)x boolValue];
        self.navigationItem.rightBarButtonItem.enabled = valid;
    }];
    [RACAble(self.exchange.to) subscribeNext:^(EVObject<EVExchangeable> *to) {
        if (to == nil)
            return;
        self.formView.toField.text = to.name ? to.name : to.email;
	}];
}

#pragma mark - TableView Utility

- (void)reloadTableView {
    EV_PERFORM_ON_MAIN_QUEUE(^ (void) {
        if (![self.formView.toField isFirstResponder]) {
            [self hideTableView];
            return;
        }
        
        if (self.suggestions.count > 0)
            [self showTableView];
        else
            [self hideTableView];
        
        [self.suggestionsTableView reloadData];
    });
}

- (void)showTableView {
    self.suggestionsTableView.frame = [self suggestionsTableViewFrame];
    [self.view addSubview:self.suggestionsTableView];
}

- (void)hideTableView {
    [self.suggestionsTableView removeFromSuperview];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.suggestions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVUserAutocompletionCell *cell = (EVUserAutocompletionCell *)[tableView dequeueReusableCellWithIdentifier:@"userAutocomplete"];
    
    id contact = [self.suggestions objectAtIndex:indexPath.row];
    if ([contact isKindOfClass:[EVUser class]]) {
        cell.nameLabel.text = [contact name];
        cell.emailLabel.text = [contact email];
    }
    else if ([contact isKindOfClass:[ABContact class]]) {
        cell.nameLabel.text = [contact compositeName];
        cell.emailLabel.text = [[contact emailArray] objectAtIndex:0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id contact = [self.suggestions objectAtIndex:indexPath.row];
    if ([contact isKindOfClass:[EVUser class]]) {
		self.exchange.to = contact;
    }
    else if ([contact isKindOfClass:[ABContact class]]) {
        NSString *emailAddress = [[contact emailArray] objectAtIndex:0];
		EVContact *toContact = [[EVContact alloc] init];
		toContact.email = emailAddress;
		self.exchange.to = toContact;
    }
    
    [self hideTableView];
    [self.formView.amountField becomeFirstResponder];
}

#pragma mark - To Field Handling

- (void)handleToFieldInput:(NSString *)text {
    if ([self.formView.toField isFirstResponder]) {
        self.suggestions = [ABContactsHelper contactsWithEmailMatchingName:text];
        [self reloadTableView];
        
        if (!EV_IS_EMPTY_STRING(text)) {
            [EVUser allWithParams:@{ @"query" : text } success:^(id result) {
                self.suggestions = [self.suggestions arrayByAddingObjectsFromArray:(NSArray *)result];
                [self reloadTableView];
            } failure:^(NSError *error) {
                DLog(@"error: %@", error);
            }];
        }
    }
    else {
        [self hideTableView];
        self.suggestions = [NSArray array];
    }
    if (!self.exchange.to)
        self.exchange.to = [EVUser new];
    self.exchange.to.email = text;
    self.exchange.to.dbid = nil;
}

#pragma mark - Button Handling

- (void)cancelButtonPress:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)completeExchangePress:(id)sender {
    [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusInProgress text:@"SENDING PAYMENT..."];
    
    [self.exchange saveWithSuccess:^{
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusSuccess];
        [EVStatusBarManager sharedManager].completion = ^(void) { [self.presentingViewController dismissViewControllerAnimated:YES completion:nil]; };
        
        if ([self.exchange isKindOfClass:[EVPayment class]])
            [EVCIA me].balance = [[EVCIA me].balance decimalNumberBySubtracting:self.exchange.amount];
    } failure:^(NSError *error) {
        DLog(@"failed to create %@", NSStringFromClass([self.exchange class]));
        [[EVStatusBarManager sharedManager] setStatus:EVStatusBarStatusFailure];
    }];
}

#pragma mark - View Defines

- (NSString *)completeExchangeButtonText {
    return @"Pay";
}

- (CGRect)formViewFrame {
    CGRect formRect = self.view.bounds;
    formRect.size.height -= (DEFAULT_KEYBOARD_HEIGHT + self.navigationController.navigationBar.bounds.size.height);
    return formRect;
}

- (CGRect)privacySelectorFrame {
    float yOrigin = self.view.bounds.size.height - DEFAULT_KEYBOARD_HEIGHT - [EVPrivacySelectorView lineHeight] - self.navigationController.navigationBar.bounds.size.height;
    return CGRectMake(0,
                      yOrigin,
                      self.view.bounds.size.width,
                      [EVPrivacySelectorView lineHeight] * [EVPrivacySelectorView numberOfLines]);
}

- (CGRect)suggestionsTableViewFrame {
    CGRect keyboardFrame = [[EVKeyboardTracker sharedTracker] keyboardFrame];
    float tableHeight = CGRectGetMinY(keyboardFrame) - self.formView.frame.origin.y - self.navigationController.navigationBar.bounds.size.height - CELL_HEIGHT;
    return CGRectMake(self.formView.frame.origin.x,
                      self.formView.frame.origin.y + CELL_HEIGHT,
                      self.formView.frame.size.width,
                      tableHeight);
}

@end
