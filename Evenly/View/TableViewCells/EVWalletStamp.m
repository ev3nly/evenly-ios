//
//  EVWalletStamp.m
//  Evenly
//
//  Created by Joseph Hankin on 6/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVWalletStamp.h"
#import <QuartzCore/QuartzCore.h>

@interface EVWalletStampBorder : UIView

@end

@implementation EVWalletStampBorder

+ (Class)layerClass {
    return [CAShapeLayer class];
}

@end

@interface EVWalletStamp ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation EVWalletStamp

- (UIFont *)font {
    return [EVFont blackFontOfSize:10.0];
}

- (id)initWithText:(NSString *)text maxWidth:(CGFloat)maxWidth {
    if ([text isEqualToString:@"American Express"])
        text = @"Amex";
    CGSize textSize = [[text uppercaseString] _safeBoundingRectWithSize:CGSizeMake(maxWidth, [self font].lineHeight)
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{NSFontAttributeName: [self font]}
                                                                context:NULL].size;
    self = [self initWithFrame:CGRectMake(0, 0, textSize.width + 16, textSize.height + 10)];
    if (self) {
        self.text = [text uppercaseString];
        self.label.text = self.text;
        self.maxWidth = maxWidth;
        [self setNeedsLayout];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[EVWalletStampBorder alloc] initWithFrame:self.bounds];
        [self addSubview:self.backgroundView];
        
        UIBezierPath *shapePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) cornerRadius:2.0];
        [shapePath addClip];
        
        self.shapeLayer = (CAShapeLayer *)self.backgroundView.layer;
        self.shapeLayer.path = [shapePath CGPath];
        self.shapeLayer.lineWidth = [EVUtilities scaledDividerHeight];
        self.shapeLayer.strokeColor = [[EVColor sidePanelStripeColor] CGColor];
        self.shapeLayer.fillColor = [[EVColor sidePanelSelectedColor] CGColor];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, self.bounds.size.width - 16, self.bounds.size.height - 10)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor whiteColor];
        self.label.font = [self font];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
    }
    return self;
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    self.shapeLayer.strokeColor = [strokeColor CGColor];
}

- (void)setFillColor:(UIColor *)fillColor {
    self.shapeLayer.fillColor = [fillColor CGColor];
}

- (void)setTextColor:(UIColor *)textColor {
    self.label.textColor = textColor;
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
