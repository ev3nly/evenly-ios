//
//  EVEditLabelCell.h
//  Evenly
//
//  Created by Justin Brunet on 6/21/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"

typedef void(^EVEditLabelCellHandleTextChangeBlock)(NSString *text);

@interface EVEditLabelCell : EVGroupedTableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) EVEditLabelCellHandleTextChangeBlock handleTextChange;

+ (float)cellHeight;

- (void)setTitle:(NSString *)title placeholder:(NSString *)placeholder;

@end
