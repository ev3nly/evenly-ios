//
//  EVRewardCardBack.h
//  Evenly
//
//  Created by Joseph Hankin on 8/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVRewardCardBackDot.h"

@interface EVRewardCardBack : UIView

@property (nonatomic, strong) EVRewardCardBackDot *dot;

- (id)initWithFrame:(CGRect)frame text:(NSString *)text color:(UIColor *)color;

@end
