//
//  EVRequestSingleAmountView.h
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVRequestView.h"
#import "EVTextField.h"
#import "EVRequestBigAmountView.h"

@interface EVRequestSingleAmountView : EVRequestView

@property (nonatomic, strong) EVRequestBigAmountView *bigAmountView;
@property (nonatomic, readonly) EVTextField *amountField;
@property (nonatomic, readonly) UILabel *minimumAmountLabel;

@end
