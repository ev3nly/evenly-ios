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

#define KEYBOARD_HEIGHT 216

@interface EVExchangeViewController ()

- (void)loadLeftButton;
- (void)loadRightButton;
- (void)loadFormView;

@end

@implementation EVExchangeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
}

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

- (void)cancelButtonPress:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
