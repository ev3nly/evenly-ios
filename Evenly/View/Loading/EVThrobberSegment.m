//
//  EVThrobberSegment.m
//  Evenly
//
//  Created by Joseph Hankin on 8/5/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVThrobberSegment.h"
#import <QuartzCore/QuartzCore.h>

@interface EVThrobberSegment ()

@property (nonatomic, strong) UIView *pillView;
@property (nonatomic, strong) CABasicAnimation *animation;
@property (nonatomic, strong) CABasicAnimation *colorAnimation;

@end

@implementation EVThrobberSegment

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
        
        self.pillView = [[UIView alloc] initWithFrame:self.bounds];
        self.pillView.layer.cornerRadius = 2.0;
        self.pillView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        self.pillView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        [self addSubview:self.pillView];

        self.animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        self.animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1.5, 1)];
        self.animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        self.animation.autoreverses = YES;
        self.animation.duration = 0.4;
        self.animation.repeatCount = HUGE_VALF;
        
        self.colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        self.colorAnimation.fromValue = (__bridge id)([self.color CGColor]);
        self.colorAnimation.toValue = (__bridge id)([[self highlightedColor] CGColor]);
        self.colorAnimation.autoreverses = YES;
        self.colorAnimation.duration = 0.4;
        self.colorAnimation.repeatCount = HUGE_VALF;
    }
    return self;
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration {
    self.animation.duration = (CFTimeInterval)animationDuration;
    self.colorAnimation.duration = (CFTimeInterval)animationDuration;
}

- (NSTimeInterval)animationDuration {
    return (NSTimeInterval)self.animation.duration;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self.pillView setBackgroundColor:_color];
    self.colorAnimation.fromValue = (__bridge id)([_color CGColor]);
}

- (void)setHighlightedColor:(UIColor *)highlightedColor {
    _highlightedColor = highlightedColor;
    self.colorAnimation.toValue = (__bridge id)([_highlightedColor CGColor]);
    
}

- (void)startAnimating {
    [self.pillView.layer addAnimation:self.animation forKey:@"transform"];
    [self.pillView.layer addAnimation:self.colorAnimation forKey:@"fillColor"];
}

- (void)stopAnimating {
    [self.pillView.layer removeAllAnimations];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.pillView.frame = CGRectMake(0, self.frame.size.height * 0.2, self.frame.size.width, self.frame.size.height * 0.66);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
