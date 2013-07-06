//
//  EVRequestViewController_NEW.h
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchangeViewController_NEW.h"
#import "EVRequestSwitch.h"
#import "EVRequest.h"
#import "EVGroupRequest.h"

#import "EVRequestWhoView.h"
#import "EVExchangeHowMuchView.h"
#import "EVRequestMultipleAmountsView.h"
#import "EVExchangeWhatForView.h"
#import "EVRequestMultipleDetailsView.h"



@interface EVRequestViewController : EVExchangeViewController_NEW 

@property (nonatomic, strong) EVRequest *request;
@property (nonatomic, strong) EVGroupRequest *groupRequest;

@property (nonatomic, strong) EVRequestWhoView *initialView;

@property (nonatomic, strong) EVExchangeHowMuchView *singleAmountView;
@property (nonatomic, strong) EVRequestMultipleAmountsView *multipleAmountsView;

@property (nonatomic, strong) EVExchangeWhatForView *singleDetailsView;
@property (nonatomic, strong) EVRequestMultipleDetailsView *multipleDetailsView;

@end
