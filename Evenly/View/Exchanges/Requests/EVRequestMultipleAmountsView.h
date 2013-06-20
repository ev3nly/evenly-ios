//
//  EVRequestMultipleAmountsView.h
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVRequestView.h"
#import "EVRequestBigAmountView.h"
#import "EVSegmentedControl.h"
#import "EVTextField.h"

@interface EVRequestMultipleAmountsView : EVRequestView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) EVSegmentedControl *segmentedControl;
@property (nonatomic, strong) EVRequestBigAmountView *singleAmountView;
@property (nonatomic, strong) UITableView *multipleAmountsView;

@property (nonatomic, readonly) NSArray *tiers;
@property (nonatomic, readonly) BOOL isValid;

@end
