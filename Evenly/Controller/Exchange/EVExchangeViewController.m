//
//  EVExchangeViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchangeViewController.h"
#import "EVNavigationBarButton.h"
#import "EVExchangeFormView.h"
#import "EVPrivacySelectorView.h"
#import "EVUserAutocompletionCell.h"
#import "EVKeyboardTracker.h"

#import "ABContactsHelper.h"

#define KEYBOARD_HEIGHT 216

@interface EVExchangeViewController () {
    EVPrivacySelectorView *_networkSelector;
}

@property (nonatomic, strong) EVExchangeFormView *formView;

- (void)loadLeftButton;
- (void)loadRightButton;
- (void)loadNetworkSelector;
- (void)configureReactions;

- (CGRect)networkSelectorFrame;

@end

@implementation EVExchangeViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Exchange";
        self.view.backgroundColor = [UIColor whiteColor];
        self.suggestions = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadLeftButton];
    [self loadRightButton];
    [self loadFormView];
    [self loadNetworkSelector];
    [self configureReactions];
    
    self.suggestionsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.suggestionsTableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.suggestionsTableView.delegate = self;
    self.suggestionsTableView.dataSource = self;
    self.suggestionsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.suggestionsTableView registerClass:[EVUserAutocompletionCell class]
                      forCellReuseIdentifier:@"userAutocomplete"];
    self.suggestionsTableView.separatorColor = [UIColor colorWithWhite:0.8 alpha:1.0];
}

#pragma mark - View Loading

- (void)loadLeftButton {
    EVNavigationBarButton *leftButton = [[EVNavigationBarButton alloc] initWithTitle:@"Cancel"];
    [leftButton addTarget:self action:@selector(cancelButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)loadRightButton {
    EVNavigationBarButton *payButton = [EVNavigationBarButton buttonWithTitle:@"Pay"];
    [payButton addTarget:self action:@selector(completeExchangePress:) forControlEvents:UIControlEventTouchUpInside];
    payButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:payButton];
}

- (void)loadFormView {
    CGRect formRect = self.view.bounds;
    formRect.size.height -= (KEYBOARD_HEIGHT + 44);
    
    self.formView = [[EVExchangeFormView alloc] initWithFrame:formRect];
    [self.view addSubview:self.formView];
}

- (void)loadNetworkSelector
{
    _networkSelector = [[EVPrivacySelectorView alloc] initWithFrame:[self networkSelectorFrame]];
    [self.view addSubview:_networkSelector];
}

- (void)reloadTableView {
    if (![self.formView.toField isFirstResponder]) {
        [self hideTableView];
        return;
    }
    
    if (self.suggestions.count > 0) {
        [self showTableView];
    } else {
        [self hideTableView];
    }
    [self.suggestionsTableView reloadData];
}

- (void)showTableView {
    CGRect keyboardFrame = [[EVKeyboardTracker sharedTracker] keyboardFrame];
    //    CGRect toTextFieldFrame = [self.view convertRect:self.transactionForm.toTextField.frame fromView:self.transactionForm];
    
//    UIEdgeInsets tableViewInsets = UIEdgeInsetsMake(self.form.horizontalStripe.frame.origin.y + 1, 3, self.view.frame.origin.y, 3);
    
    CGRect tableViewFrame = CGRectMake(self.formView.frame.origin.x,
                                       self.formView.frame.origin.y,
                                       self.formView.frame.size.width,
                                       CGRectGetMinY(keyboardFrame) - self.formView.frame.origin.y);
//    tableViewFrame = UIEdgeInsetsInsetRect(tableViewFrame, tableViewInsets);
    //    DLog(@"\nKeyboardFrame: %@   \nToFieldFrame (in self.view's coordinates): %@  \nTable view frame: %@", NSStringFromCGRect(keyboardFrame), NSStringFromCGRect(toTextFieldFrame), NSStringFromCGRect(tableViewFrame));
    
    self.suggestionsTableView.frame = tableViewFrame;
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
    return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVUserAutocompletionCell *cell = (EVUserAutocompletionCell *)[tableView dequeueReusableCellWithIdentifier:@"userAutocomplete"];
    
    id contact = [self.suggestions objectAtIndex:indexPath.row];
    if ([contact isKindOfClass:[EVContact class]]) {
        cell.nameLabel.text = [contact name];
        cell.emailLabel.text = [contact email];
    } else if ([contact isKindOfClass:[ABContact class]]) {
        cell.nameLabel.text = [contact compositeName];
        cell.emailLabel.text = [[contact emailArray] objectAtIndex:0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id contact = [self.suggestions objectAtIndex:indexPath.row];
    NSString *emailAddress = nil;
    if ([contact isKindOfClass:[EVUser class]]) {
		self.exchange.to = contact;
    } else if ([contact isKindOfClass:[ABContact class]]) {
        emailAddress = [[contact emailArray] objectAtIndex:0];
		EVContact *toContact = [[EVContact alloc] init];
		toContact.email = emailAddress;
		self.exchange.to = toContact;
    }
    //    self.transactionForm.toTextField.text = emailAddress;
    [self hideTableView];
    [self.formView.amountField becomeFirstResponder];
}

- (void)configureReactions
{
    [self.formView.toField.rac_textSignal subscribeNext:^(NSString *toString) {
        if ([self.formView.toField isFirstResponder])
        {
            NSArray *results = [ABContactsHelper contactsWithEmailMatchingName:toString];
            self.suggestions = results;
            
            [self reloadTableView];
            if (!EV_IS_EMPTY_STRING(toString)) {
                [EVUser allWithParams:@{ @"query" : toString } success:^(id result) {
                    self.suggestions = [(NSArray *)result arrayByAddingObjectsFromArray:self.suggestions];
                } failure:^(NSError *error) {
                    DLog(@"error: %@", error);
                }];
            }
        }
        else
        {
            [self hideTableView];
            self.suggestions = [NSArray array];
        }
        if (self.exchange.to == nil)
            self.exchange.to = [EVUser new];
        self.exchange.to.email = toString;
        self.exchange.to.dbid = nil;
    }];
    [self.formView.amountField.rac_textSignal subscribeNext:^(NSString *amountString) {
        self.exchange.amount = [NSDecimalNumber decimalNumberWithString:[amountString stringByReplacingOccurrencesOfString:@"$" withString:@""]];
    }];
    [self.formView.descriptionField.rac_textSignal subscribeNext:^(NSString *descriptionString) {
        self.exchange.memo = descriptionString;
    }];
    [RACAble(self.exchange.isValid) subscribeNext:^(id x) {
        BOOL valid = [(NSNumber *)x boolValue];
        self.navigationItem.rightBarButtonItem.enabled = valid;
    }];
}

#pragma mark - Button Handling

- (void)cancelButtonPress:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)completeExchangePress:(id)sender {
    //implement in subclass
}

#pragma mark - Frame Defines

#define NETWORK_LINE_HEIGHT 40
- (CGRect)networkSelectorFrame {
    return CGRectMake(0,
                      self.view.bounds.size.height - KEYBOARD_HEIGHT - NETWORK_LINE_HEIGHT - 44,
                      self.view.bounds.size.width,
                      NETWORK_LINE_HEIGHT * 4);
}

@end
