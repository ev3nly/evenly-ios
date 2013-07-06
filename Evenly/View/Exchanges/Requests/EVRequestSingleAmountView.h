//
//  EVRequestSingleAmountView.h
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVExchangeView.h"
#import "EVTextField.h"
#import "EVExchangeBigAmountView.h"

@interface EVRequestSingleAmountView : EVExchangeView

@property (nonatomic, strong) EVExchangeBigAmountView *bigAmountView;
@property (nonatomic, readonly) EVTextField *amountField;
@property (nonatomic, readonly) UILabel *minimumAmountLabel;

@end
