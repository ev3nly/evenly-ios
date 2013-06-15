//
//  EVRequestViewController.m
//  Evenly
//
//  Created by Justin Brunet on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRequestViewController.h"
#import "EVRequestFormView.h"
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

- (void)loadFormView
{
    CGRect formRect = self.view.bounds;
    formRect.size.height -= (KEYBOARD_HEIGHT + 44);
//TODO: need to take into account slider or whatever we end up using
    
    EVRequestFormView *formView = [[EVRequestFormView alloc] initWithFrame:formRect];
    [self.view addSubview:formView];
}

@end
