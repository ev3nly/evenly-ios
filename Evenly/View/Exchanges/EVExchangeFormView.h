//
//  EVExchangeFormView.h
//  Evenly
//
//  Created by Justin Brunet on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVTextField.h"

@interface EVExchangeFormView : UIView <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) EVTextField *toField;
@property (nonatomic, strong) EVTextField *amountField;
@property (nonatomic, strong) UITextView *descriptionField;

- (EVTextField *)configuredTextField;
- (CGRect)payLabelFrame;
- (CGRect)amountFieldFrame;
- (float)maxAmountWidth;
- (NSString *)amountPrefix;

@end
