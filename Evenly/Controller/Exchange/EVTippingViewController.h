//
//  EVTippingViewController.h
//  Evenly
//
//  Created by Justin Brunet on 7/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPaymentViewController.h"

@class EVTip, EVChooseTipView, EVExchangeWhatForView, EVSharingSelectorView;

@interface EVTippingViewController : EVPaymentViewController

@property (nonatomic, strong) EVTip *tip;
@property (nonatomic, strong) EVChooseTipView *chooseTipView;
@property (nonatomic, strong) EVExchangeWhatForView *whatForView;
@property (nonatomic, strong) EVSharingSelectorView *privacySelector;

@end
