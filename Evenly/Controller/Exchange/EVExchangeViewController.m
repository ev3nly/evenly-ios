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

- (void)configureReactions
{
    [self.formView.toField.rac_textSignal subscribeNext:^(NSString *toString) {
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
