//
//  EVRequestMultipleDetailsView.h
//  Evenly
//
//  Created by Joseph Hankin on 6/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchangeWhatForView.h"
#import "EVTextField.h"
#import "EVPlaceholderTextView.h"
#import "EVExchangeWhatForHeader.h"

@interface EVRequestMultipleDetailsView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) EVExchangeWhatForHeader *whatForHeader;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) EVTextField *nameField;

@property (nonatomic, strong) UIView *divider;

@property (nonatomic, strong) EVPlaceholderTextView *descriptionField;

@end
