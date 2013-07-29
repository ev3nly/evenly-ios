//
//  EVTippingViewController.h
//  Evenly
//
//  Created by Justin Brunet on 7/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchangeViewController.h"

@class EVExchangeHowMuchView, EVExchangeWhatForView;

@interface EVTippingViewController : EVExchangeViewController

@property (nonatomic, strong) EVExchangeHowMuchView *howMuchView;
@property (nonatomic, strong) EVExchangeWhatForView *whatForView;

@end
