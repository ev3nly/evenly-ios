//
//  EVRequestMultipleAmountsView.h
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVExchangeView.h"
#import "EVExchangeBigAmountView.h"
#import "EVMultipleAmountsSegmentedControl.h"
#import "EVTextField.h"

typedef enum {
    EVRequestAmountsSingle = 0,
    EVRequestAmountsMultiple
} EVRequestAmounts;

@interface EVRequestMultipleAmountsView : EVExchangeView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) EVMultipleAmountsSegmentedControl *segmentedControl;
@property (nonatomic, strong) EVExchangeBigAmountView *singleAmountView;
@property (nonatomic, strong) UITableView *multipleAmountsView;

@property (nonatomic, readonly) NSArray *tiers;
@property (nonatomic, readonly) BOOL isValid;

@end
