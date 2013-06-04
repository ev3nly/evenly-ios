//
//  EVWalletViewController.m
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVWalletViewController.h"
#import "EVNavigationManager.h"

@interface EVWalletViewController ()

@end

@implementation EVWalletViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DLog(@"View will appear");
}

- (void)viewWillDisappear:(BOOL)animated {
    DLog(@"View will disappear");
}

#pragma mark - EVSidePanelViewController Overrides

- (JASidePanelState)visibleState {
    return JASidePanelRightVisible;
}

@end
