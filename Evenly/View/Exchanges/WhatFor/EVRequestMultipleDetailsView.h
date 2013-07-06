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

@interface EVRequestMultipleDetailsView : UIView

@property (nonatomic, strong) EVTextField *nameField;
@property (nonatomic, strong) EVPlaceholderTextView *descriptionField;

@end
