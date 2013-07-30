//
//  EVTippingViewController.h
//  Evenly
//
//  Created by Justin Brunet on 7/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPaymentViewController.h"

@class EVExchangeHowMuchView, EVExchangeWhatForView;

@interface EVTippingViewController : EVPaymentViewController

@property (nonatomic, strong) EVExchangeHowMuchView *howMuchView;
@property (nonatomic, strong) EVExchangeWhatForView *whatForView;

@end
