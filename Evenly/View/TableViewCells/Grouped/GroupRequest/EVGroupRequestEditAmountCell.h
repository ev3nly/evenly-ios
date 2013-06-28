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

extern NSString *const EVGroupRequestEditAmountCellBeganEditing;

@interface EVGroupRequestEditAmountCell : EVGroupedTableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) EVTextField *optionNameField;
@property (nonatomic, strong) EVTextField *optionAmountField;
@property (nonatomic, strong) EVCurrencyTextFieldFormatter *currencyFormatter;

@property (nonatomic, getter = isEditable) BOOL editable;

@property (nonatomic) BOOL isEditing;

@end

@interface EVGroupRequestEditAddOptionCell : EVGroupedTableViewCell

@end