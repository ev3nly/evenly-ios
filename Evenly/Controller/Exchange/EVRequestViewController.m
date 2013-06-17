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
#import "EVRequestSwitch.h"

@interface EVRequestViewController ()

- (void)loadRequestSwitch;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadRequestSwitch];
}

- (NSString *)completeExchangeButtonText {
    return @"Request";
}

- (CGRect)formViewFrame {
    CGRect formRect = [super formViewFrame];
    CGSize size = [self requestSwitchSize];
    formRect.origin.y += size.height;
    //TODO: need to take into account slider or whatever we end up using
    return formRect;
}

- (CGSize)requestSwitchSize {
    return CGSizeMake(300, 45);
}


- (void)loadRequestSwitch {
    UIView *requestSwitchBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50.0)];
    requestSwitchBackground.backgroundColor = [EVColor creamColor];
    [self.view addSubview:requestSwitchBackground];
    
    EVRequestSwitch *requestSwitch = [[EVRequestSwitch alloc] initWithFrame:CGRectMake(10, 7, 300, 35)];
    [requestSwitchBackground addSubview:requestSwitch];
    
}

@end
