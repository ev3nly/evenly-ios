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

+ (CGFloat)standardHeight;
+ (CGFloat)expandedHeight;

@property (nonatomic, strong) EVTextField *optionAmountField;
@property (nonatomic, strong) EVGrayButton *friendsButton;

@property (nonatomic, strong) UIView *optionNameFieldBackground;
@property (nonatomic, strong) EVTextField *optionNameField;

@property (nonatomic, strong) EVCurrencyTextFieldFormatter *currencyFormatter;

@property (nonatomic, strong) void (^handleDeletePress)(EVGroupRequestAmountCell *cell);
@property (nonatomic, strong) void (^handleSelectFriendsPress)(EVGroupRequestAmountCell *cell);
@property (nonatomic, strong) void (^handleArrowPress)(EVGroupRequestAmountCell *cell);

- (void)addTopStripe;

@end

@interface EVGroupRequestAddOptionCell : UITableViewCell

@end