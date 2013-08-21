//
//  EVRewardCardBackDot.h
//  Evenly
//
//  Created by Joseph Hankin on 8/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVRewardCardBackDot : UIView

@property (nonatomic, strong) NSString *text;

- (id)initWithText:(NSString *)text color:(UIColor *)color;

@end