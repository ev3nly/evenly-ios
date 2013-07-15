//
//  EVRequestViewController_NEW.h
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchangeViewController.h"
#import "EVRequestSwitch.h"
#import "EVRequest.h"
#import "EVGroupRequest.h"

#import "EVRequestWhoView.h"
#import "EVExchangeHowMuchView.h"

#import "EVRequestMultipleAmountsView.h"
#import "EVGroupRequestHowMuchView.h"

#import "EVExchangeWhatForView.h"
#import "EVGroupRequestWhatForView.h"

@interface EVRequestViewController : EVExchangeViewController 

@property (nonatomic, strong) EVRequest *request;
@property (nonatomic, strong) EVGroupRequest *groupRequest;

@property (nonatomic, strong) EVRequestWhoView *initialView;

@property (nonatomic, strong) EVExchangeHowMuchView *singleHowMuchView;
@property (nonatomic, strong) EVGroupRequestHowMuchView *groupHowMuchView;

@property (nonatomic, strong) EVExchangeWhatForView *singleWhatForView;
@property (nonatomic, strong) EVGroupRequestWhatForView *groupWhatForView;

@end
