//
//  EVGroupRequestTitleCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/26/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestTextEditCell.h"
#import "EVTextField.h"

@interface EVGroupRequestTitleCell : EVGroupRequestTextEditCell <UITextFieldDelegate>

@property (nonatomic, strong) EVTextField *textField;

@end
