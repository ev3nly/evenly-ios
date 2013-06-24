//
//  EVOnboardingViewController.h
//  Evenly
//
//  Created by Justin Brunet on 6/23/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVModalViewController.h"
#import "EVMasterViewController.h"

@interface EVOnboardingViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, weak) EVMasterViewController *parent;

@end
