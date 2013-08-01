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
#import "EVExchangeWhatForHeader.h"

@class EVTip;

@interface EVExchangeWhatForView : EVExchangeView <UITextViewDelegate>

@property (nonatomic, strong) EVTip *tip;
@property (nonatomic, strong) EVExchangeWhatForHeader *whatForHeader;

@property (nonatomic, strong) UITextView *descriptionField;

- (void)flashNoDescriptionMessage;

@end
