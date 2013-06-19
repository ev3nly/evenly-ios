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

@interface EVRequestSingleAmountView : EVRequestView<UITextFieldDelegate>

@property (nonatomic, strong) EVTextField *amountField;
@property (nonatomic, strong) UILabel *minimumAmountLabel;

@end