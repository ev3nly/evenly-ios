//
//  EVGroupRequestAmountCell.h
//  Evenly
//
//  Created by Joseph Hankin on 6/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVTextField.h"

@interface EVGroupRequestAmountCell : UITableViewCell

@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) EVTextField *optionNameField;
@property (nonatomic, strong) EVTextField *optionAmountField;

@end

@interface EVGroupRequestAddOptionCell : UITableViewCell

@end