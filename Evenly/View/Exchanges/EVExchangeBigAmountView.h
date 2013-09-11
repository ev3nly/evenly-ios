//
//  EVRequestBigAmountView.h
//  Evenly
//
//  Created by Joseph Hankin on 6/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVTextField.h"
#import "EVCurrencyTextFieldFormatter.h"
#import "EVGroupedTableViewCell.h"

@interface EVExchangeBigAmountView : UIView <UITextFieldDelegate>

@property (nonatomic, strong) EVGroupedTableViewCellBackground *bigAmountContainer;
@property (nonatomic, strong) EVTextField *amountField;
@property (nonatomic, strong) UILabel *minimumAmountLabel;

@property (nonatomic, strong) EVCurrencyTextFieldFormatter *currencyFormatter;

+ (CGFloat)totalHeight;

- (void)flashMinimumAmountLabel;

@end
