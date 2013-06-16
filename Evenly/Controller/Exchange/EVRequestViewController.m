//
//  EVRequestViewController.m
//  Evenly
//
//  Created by Justin Brunet on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRequestViewController.h"
#import "EVRequestFormView.h"
#import "EVNavigationBarButton.h"
#import "EVCharge.h"

#define KEYBOARD_HEIGHT 216

@interface EVRequestViewController ()

@end

@implementation EVRequestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"New Request";
        self.exchange = [EVCharge new];
    }
    return self;
}

- (void)loadRightButton {
    EVNavigationBarButton *payButton = [EVNavigationBarButton buttonWithTitle:@"Request"];
    [payButton addTarget:self action:@selector(completeExchangePress:) forControlEvents:UIControlEventTouchUpInside];
    payButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:payButton];
}

- (void)loadFormView
{
    CGRect formRect = self.view.bounds;
    formRect.size.height -= (KEYBOARD_HEIGHT + 44);
//TODO: need to take into account slider or whatever we end up using
    
    self.formView = [[EVRequestFormView alloc] initWithFrame:formRect];
    [self.view addSubview:self.formView];
}

@end
