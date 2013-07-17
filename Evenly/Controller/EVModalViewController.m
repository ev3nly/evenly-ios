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
    UIImage *closeImage = [EVImages navBarCancelButton];
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, closeImage.size.width + 20.0, closeImage.size.height)];
    [cancelButton setImage:closeImage forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    cancelButton.adjustsImageWhenHighlighted = NO;
    cancelButton.showsTouchWhenHighlighted = YES;
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
}

- (void)cancelButtonPress:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)setCanDismissManually:(BOOL)canDismissManually {
    _canDismissManually = canDismissManually;
    
    if (canDismissManually)
        [self loadCancelButton];
    else
        [self.navigationItem setLeftBarButtonItem:nil];
}

@end
