//
//  EVRequestInitialView.h
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EVTextField.h"

@interface EVRequestInitialView : UIView

@property (nonatomic, strong) EVTextField *textField;
@property (nonatomic, strong) UILabel *instructionLabel;

@end
