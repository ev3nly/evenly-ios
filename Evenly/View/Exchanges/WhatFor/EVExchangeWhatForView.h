//
//  EVRequestDetailsView.h
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVExchangeView.h"
#import "EVTextField.h"

@interface EVExchangeWhatForView : EVExchangeView <UITextViewDelegate>

@property (nonatomic, strong) UITextView *descriptionField;

@end
