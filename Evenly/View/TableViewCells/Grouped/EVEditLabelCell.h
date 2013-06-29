//
//  EVEditLabelCell.h
//  Evenly
//
//  Created by Justin Brunet on 6/21/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"


@interface EVEditLabelCell : EVGroupedTableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) EVHandleTextChangeBlock handleTextChange;

+ (float)cellHeight;

- (void)setTitle:(NSString *)title placeholder:(NSString *)placeholder;

@end
