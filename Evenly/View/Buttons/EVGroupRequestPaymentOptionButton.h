//
//  EVGroupRequestPaymentOptionButton.h
//  Evenly
//
//  Created by Joseph Hankin on 6/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EVGroupRequestTier;

@interface EVGroupRequestPaymentOptionButton : UIButton

@property (nonatomic, strong) UIImageView *checkboxImageView;
@property (nonatomic, strong) UILabel *label;

+ (instancetype)buttonForTier:(EVGroupRequestTier *)tier;

@end
