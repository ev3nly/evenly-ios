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

- (NSString *)completeExchangeButtonText {
    return @"Request";
}

- (void)loadFormView {
    self.formView = [[EVRequestFormView alloc] initWithFrame:[self formViewFrame]];
    [self.view addSubview:self.formView];
}

- (CGRect)formViewFrame {
    CGRect formRect = [super formViewFrame];
    //TODO: need to take into account slider or whatever we end up using
    return formRect;
}

@end
