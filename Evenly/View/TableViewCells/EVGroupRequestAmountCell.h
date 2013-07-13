//
//  EVGroupRequestAmountCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVTextField.h"
#import "EVGrayButton.h"
#import "EVExpansionArrowButton.h"
#import "EVCurrencyTextFieldFormatter.h"

@interface EVGroupRequestAmountCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) EVTextField *optionAmountField;
@property (nonatomic, strong) EVGrayButton *friendsButton;
@property (nonatomic, strong) EVExpansionArrowButton *arrowButton;
@property (nonatomic, strong) EVTextField *optionNameField;

@property (nonatomic, strong) EVCurrencyTextFieldFormatter *currencyFormatter;

@end

@interface EVGroupRequestAddOptionCell : UITableViewCell

@end