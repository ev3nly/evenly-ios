//
//  EVProgressBarForeground.m
//  Evenly
//
//  Created by Joseph Hankin on 6/23/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVProgressBarForeground.h"
#import <QuartzCore/QuartzCore.h>

@interface EVProgressBarForeground ()

@property (nonatomic, strong) UIImageView *backgroundView;

@end

@implementation EVProgressBarForeground

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [EVColor lightGreenColor];
        self.opaque = NO;
        self.autoresizesSubviews = YES;
        
        CAShapeLayer *mask = [CAShapeLayer layer];
        [mask setPath:[[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:(self.bounds.size.height / 2)] CGPath]];
        self.layer.mask = mask;
        
//        self.backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
//        self.backgroundView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
//        self.backgroundView.image = [[UIImage imageNamed:@"toggle_on_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
//        [self addSubview:self.backgroundView];
    }
    return self;
}

//- (void)drawRect:(CGRect)rect
//{
//    CGRect adjustedRect = CGRectInset(rect, 2, 2);
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:adjustedRect cornerRadius:(adjustedRect.size.height / 2)];
//    [[EVColor lightGreenColor] setFill];
//    [path addClip];
//    [path fill];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
