//
//  EVGroupRequestEditAmountView.h
//  Evenly
//
//  Created by Joseph Hankin on 6/26/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"
#import "EVTextField.h"
#import "EVCurrencyTextFieldFormatter.h"

@class EVGroupRequestTier;

extern NSString *const EVGroupRequestEditAmountCellBeganEditing;

typedef void (^EVEditAmountCellHandleChangeBlock)(EVTextField *textField);

@interface EVGroupRequestEditAmountCell : EVGroupedTableViewCell <UITextFieldDelegate>

@property (nonatomic, weak) EVGroupRequestTier *tier;

@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) EVTextField *optionNameField;
@property (nonatomic, strong) EVTextField *optionAmountField;
@property (nonatomic, strong) EVCurrencyTextFieldFormatter *currencyFormatter;

@property (nonatomic, strong) EVEditAmountCellHandleChangeBlock handleTextChange;

@property (nonatomic, getter = isEditable) BOOL editable;

@end

@interface EVGroupRequestEditAddOptionCell : EVGroupedTableViewCell

@end