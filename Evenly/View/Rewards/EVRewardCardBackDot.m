//
//  EVRewardCardBackDot.m
//  Evenly
//
//  Created by Joseph Hankin on 8/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRewardCardBackDot.h"
#import <QuartzCore/QuartzCore.h>

#define REWARD_CARD_BACK_DOT_DIMENSION 30

@interface EVCircleView : UIView

- (id)initWithFrame:(CGRect)frame color:(UIColor *)color;

@end

@implementation EVCircleView

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (id)initWithFrame:(CGRect)frame color:(UIColor *)color {
    self = [self initWithFrame:frame];
    if (self) {        
        self.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
        shapeLayer.path = [[UIBezierPath bezierPathWithOvalInRect:self.bounds] CGPath];
        shapeLayer.fillColor = [color CGColor];
    }
    return self;
}

@end

@interface EVRewardCardBackDot ()

@property (nonatomic, strong) EVCircleView *circleView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation EVRewardCardBackDot

- (id)initWithText:(NSString *)text color:(UIColor *)color {
    self = [self initWithFrame:CGRectMake(0, 0, REWARD_CARD_BACK_DOT_DIMENSION, REWARD_CARD_BACK_DOT_DIMENSION)];
    if (self) {
        self.circleView = [[EVCircleView alloc] initWithFrame:self.bounds color:color];
        [self addSubview:self.circleView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, self.bounds.size.width, self.bounds.size.height - 1)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [EVColor creamColor];
        self.label.font = [EVFont blackFontOfSize:16];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.text = text;
        [self addSubview:self.label];
    }
    return self;
}

- (void)setText:(NSString *)text {
    self.label.text = text;
}

- (NSString *)text {
    return self.label.text;
}

@end