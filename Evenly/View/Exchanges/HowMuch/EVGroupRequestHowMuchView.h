//
//  EVRequestHowMuchView.h
//  Evenly
//
//  Created by Joseph Hankin on 7/12/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchangeView.h"
#import "EVGroupRequestSingleAmountView.h"
#import "EVGroupRequest.h"
#import "EVGroupRequestTierAssignmentManager.h"
#import "EVGroupRequestTierAssignmentView.h"

#define ADD_OPTION_BUTTON_HEIGHT 35.0

@interface EVGroupRequestHowMuchView : EVExchangeView <UITableViewDataSource, UITableViewDelegate, EVGroupRequestTierAssignmentManagerDelegate>

@property (nonatomic, weak) EVGroupRequest *groupRequest;

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic, strong) UILabel *headerLabel;

@property (nonatomic, strong) EVGroupRequestSingleAmountView *singleAmountView;

@property (nonatomic, strong) UITableView *multipleAmountsView;

@property (nonatomic, strong) EVGroupRequestTierAssignmentManager *tierAssignmentManager;
@property (nonatomic, strong) EVGroupRequestTierAssignmentView *tierAssignmentView;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UILabel *footerLabel;


@property (nonatomic) BOOL showingMultipleOptions;

@property (nonatomic, readonly) NSArray *tiers;
@property (nonatomic, readonly) NSArray *assignments;

@property (nonatomic, readonly) BOOL isMissingAmount;
@property (nonatomic, readonly) BOOL hasTierBelowMinimum;
@property (nonatomic, readonly) BOOL hasUnassignedMembers;

- (void)setShowingMultipleOptions:(BOOL)showing animated:(BOOL)animated completion:(void (^)(void))completion;

@end
