//
//  EVGroupRequestMemoCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/26/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestTextEditCell.h"
#import "EVPlaceholderTextView.h"

@interface EVGroupRequestMemoCell : EVGroupRequestTextEditCell <UITextViewDelegate>

@property (nonatomic, strong) EVPlaceholderTextView *textField;

@end
