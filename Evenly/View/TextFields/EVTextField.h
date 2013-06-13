//
//  EVTextField.h
//  Evenly
//
//  Created by Joseph Hankin on 6/13/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVTextField : UITextField

@property (nonatomic, weak) UIResponder<UIKeyInput> *next;
@property (nonatomic, strong) UIColor *placeholderColor;

@end
