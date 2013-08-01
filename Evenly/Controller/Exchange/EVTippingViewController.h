//
//  EVTippingViewController.h
//  Evenly
//
//  Created by Justin Brunet on 7/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPaymentViewController.h"

@class EVTip, EVChooseTipView, EVExchangeWhatForView;

@interface EVTippingViewController : EVPaymentViewController

@property (nonatomic, strong) EVTip *tip;
@property (nonatomic, strong) EVChooseTipView *chooseTipView;
@property (nonatomic, strong) EVExchangeWhatForView *whatForView;

@end
