//
//  EVRequestHowMuchView.h
//  Evenly
//
//  Created by Joseph Hankin on 7/12/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchangeView.h"
#import "EVGroupRequestSingleAmountView.h"

#define ADD_OPTION_BUTTON_HEIGHT 35.0

@interface EVGroupRequestHowMuchView : EVExchangeView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic, strong) UILabel *headerLabel;

@property (nonatomic, strong) EVGroupRequestSingleAmountView *singleAmountView;

@property (nonatomic, strong) UITableView *multipleAmountsView;

@property (nonatomic) BOOL showingMultipleOptions;

@property (nonatomic, readonly) NSArray *tiers;
@property (nonatomic, readonly) BOOL isValid;

- (void)setShowingMultipleOptions:(BOOL)showing animated:(BOOL)animated;

@end