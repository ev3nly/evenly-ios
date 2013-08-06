//
//  EVRewardCard.m
//  Evenly
//
//  Created by Joseph Hankin on 8/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRewardCard.h"

@implementation EVRewardCard

- (id)initWithFrame:(CGRect)frame text:(NSString *)text color:(UIColor *)color {
    self = [self initWithFrame:frame];
    if (self) {
        self.back = [[EVRewardCardBack alloc] initWithFrame:self.bounds text:text color:color];
        [self addSubview:self.back];
        
        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
        [self addGestureRecognizer:self.tapRecognizer];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)tapRecognized:(id)sender {
    [self flip];
}

- (void)flip {
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];

}

- (void)setRewardAmount:(NSDecimalNumber *)rewardAmount animated:(BOOL)animated {
    
}

@end
