//
//  EVGroupRequestStatementLabel.h
//  Evenly
//
//  Created by Joseph Hankin on 6/26/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVGroupRequestStatementLabel : UIView

@property (nonatomic, getter = isIndented) BOOL indented;
@property (nonatomic, getter = isBold) BOOL bold;

@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UILabel *dotsLabel;
@property (nonatomic, strong) UILabel *amountLabel;

@end
