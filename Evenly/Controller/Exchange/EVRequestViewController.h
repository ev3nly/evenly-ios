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
#import "EVRequestSingleAmountView.h"
#import "EVRequestMultipleAmountsView.h"
#import "EVRequestDetailsView.h"
#import "EVRequestMultipleDetailsView.h"



@interface EVRequestViewController : EVExchangeViewController_NEW 

@property (nonatomic, strong) EVRequest *request;
@property (nonatomic, strong) EVGroupRequest *groupRequest;

@property (nonatomic, strong) EVRequestWhoView *initialView;

@property (nonatomic, strong) EVRequestSingleAmountView *singleAmountView;
@property (nonatomic, strong) EVRequestMultipleAmountsView *multipleAmountsView;

@property (nonatomic, strong) EVRequestDetailsView *singleDetailsView;
@property (nonatomic, strong) EVRequestMultipleDetailsView *multipleDetailsView;

@end
