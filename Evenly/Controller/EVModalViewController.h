//
//  EVModalViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/16/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"

@interface EVModalViewController : EVViewController

@property (nonatomic, assign) BOOL canDismissManually;

- (void)loadCancelButton;
- (void)cancelButtonPress:(id)sender;

@end
