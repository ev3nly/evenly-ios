//
//  EVRequestViewController_NEW.h
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPushPopViewController.h"
#import "EVRequestSwitch.h"
#import "EVCharge.h"
#import "EVGroupCharge.h"

#import "EVRequestInitialView.h"
#import "EVRequestSingleAmountView.h"
#import "EVRequestMultipleAmountsView.h"
#import "EVRequestDetailsView.h"
#import "EVRequestMultipleDetailsView.h"

typedef enum {
    EVRequestPhaseWho = 0,
    EVRequestPhaseHowMuch,
    EVRequestPhaseWhatFor
} EVRequestPhase;


@interface EVRequestViewController : EVPushPopViewController <UITableViewDelegate>

@property (nonatomic) EVRequestPhase phase;

@property (nonatomic, strong) EVCharge *request;
@property (nonatomic, strong) EVGroupCharge *groupRequest;

@property (nonatomic, strong) EVRequestInitialView *initialView;

@property (nonatomic, strong) EVRequestSingleAmountView *singleAmountView;
@property (nonatomic, strong) EVRequestMultipleAmountsView *multipleAmountsView;

@property (nonatomic, strong) EVRequestDetailsView *singleDetailsView;
@property (nonatomic, strong) EVRequestMultipleDetailsView *multipleDetailsView;

@end
