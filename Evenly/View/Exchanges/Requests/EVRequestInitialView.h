//
//  EVRequestInitialView.h
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EVTextField.h"
#import "EVRequestSwitch.h"

@interface EVRequestInitialView : UIView<EVSwitchDelegate>

@property (nonatomic, strong) EVRequestSwitch *requestSwitch;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) EVTextField *toField;
@property (nonatomic, strong) UILabel *instructionLabel;

@end
