//
//  EVRewardCardBack.m
//  Evenly
//
//  Created by Joseph Hankin on 8/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRewardCardBack.h"
#import <QuartzCore/QuartzCore.h>

@interface EVRewardCardBack ()

@property (nonatomic, strong) UIImageView *backgroundView;

@end

@implementation EVRewardCardBack

- (id)initWithFrame:(CGRect)frame text:(NSString *)text color:(UIColor *)color {
    self = [self initWithFrame:frame];
    if (self) {
        
        self.autoresizesSubviews = YES;
        self.backgroundColor = [EVColor lightColor];

        self.layer.cornerRadius = 2.0;
        self.layer.borderColor = [[EVColor newsfeedStripeColor] CGColor];
        self.layer.borderWidth = 1.0;
        
        self.dot = [[EVRewardCardBackDot alloc] initWithText:text color:color];
        self.dot.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
        self.dot.autoresizingMask = EV_AUTORESIZE_TO_CENTER;
        [self addSubview:self.dot];
    }
    return self;
}

- (void)setText:(NSString *)text {
    [self.dot setText:text];
}

- (NSString *)text {
    return self.dot.text;
}

@end
