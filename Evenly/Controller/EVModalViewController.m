//
//  EVModalViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/16/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVModalViewController.h"

@interface EVModalViewController ()

@end

@implementation EVModalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _canDismissManually = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.canDismissManually)
        [self loadCancelButton];
}

- (void)loadCancelButton {
    UIButton *cancelButton = [self defaultCancelButton];
    [cancelButton addTarget:self action:@selector(cancelButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
}

- (void)setCanDismissManually:(BOOL)canDismissManually {
    _canDismissManually = canDismissManually;
    
    if (canDismissManually)
        [self loadCancelButton];
    else
        [self.navigationItem setLeftBarButtonItem:nil];
}

@end
