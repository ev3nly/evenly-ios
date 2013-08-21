//
//  EVRequestMultipleDetailsView.h
//  Evenly
//
//  Created by Joseph Hankin on 6/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchangeWhatForView.h"
#import "EVExchangeView.h"
#import "EVTextField.h"
#import "EVPlaceholderTextView.h"
#import "EVExchangeWhatForHeader.h"

@interface EVGroupRequestWhatForView : EVExchangeView<UITextFieldDelegate>

@property (nonatomic, strong) EVExchangeWhatForHeader *whatForHeader;
@property (nonatomic, strong) EVTextField *nameField;
@property (nonatomic, strong) UIView *divider;
@property (nonatomic, strong) EVPlaceholderTextView *descriptionField;

- (void)flashNoDescriptionMessage;

@end
