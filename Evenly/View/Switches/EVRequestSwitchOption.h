//
//  EVRequestSwitchOption.h
//  Evenly
//
//  Created by Joseph Hankin on 6/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVRequestSwitchOption : UIView

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *label;
@property(nonatomic, getter=isHighlighted) BOOL highlighted;

+ (instancetype)friendOption;
+ (instancetype)groupOption;

@end
