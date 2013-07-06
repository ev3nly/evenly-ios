//
//  EVPaymentViewController_NEW.h
//  Evenly
//
//  Created by Joseph Hankin on 7/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchangeViewController.h"
#import "EVExchangeWhoView.h"
#import "EVExchangeHowMuchView.h"
#import "EVExchangeWhatForView.h"

#import "EVPayment.h"

@interface EVPaymentViewController : EVExchangeViewController

@property (nonatomic, strong) EVPayment *payment;

@property (nonatomic, strong) EVExchangeHowMuchView *howMuchView;
@property (nonatomic, strong) EVExchangeWhatForView *whatForView;

@end
