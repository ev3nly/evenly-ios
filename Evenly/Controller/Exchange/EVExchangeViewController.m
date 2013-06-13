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
#import "EVNetworkSelectorView.h"

#define KEYBOARD_HEIGHT 216

@interface EVExchangeViewController () {
    EVNetworkSelectorView *_networkSelector;
}

- (void)loadLeftButton;
- (void)loadRightButton;
- (void)loadNetworkSelector;

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
}

#pragma mark - View Loading

- (void)loadLeftButton {
    EVNavigationBarButton *leftButton = [[EVNavigationBarButton alloc] initWithTitle:@"Cancel"];
    [leftButton addTarget:self action:@selector(cancelButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)loadRightButton {
    EVNavigationBarButton *payButton = [EVNavigationBarButton buttonWithTitle:@"Pay"];
    [payButton addTarget:self action:@selector(payButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:payButton];
}

- (void)loadFormView {
    CGRect formRect = self.view.bounds;
    formRect.size.height -= (KEYBOARD_HEIGHT + 44);
    
    EVExchangeFormView *formView = [[EVExchangeFormView alloc] initWithFrame:formRect];
    [self.view addSubview:formView];
}

- (void)loadNetworkSelector
{
    _networkSelector = [[EVNetworkSelectorView alloc] initWithFrame:[self networkSelectorFrame]];
    [self.view addSubview:_networkSelector];
}

#pragma mark - Button Handling

- (void)cancelButtonPress:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
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
