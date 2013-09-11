//
//  EVPrivacyNotice.m
//  Evenly
//
//  Created by Joseph Hankin on 6/12/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPrivacyNotice.h"
#import <QuartzCore/QuartzCore.h>

#define EV_PRIVACY_NOTICE_MARGIN 12.0

@implementation EVPrivacyNotice

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.iconView = [[UIImageView alloc] initWithImage:[EVImages lockIcon]];
        [self addSubview:self.iconView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = EV_RGB_COLOR(0.6314, 0.6157, 0.6118);
        self.label.font = [EVFont boldFontOfSize:12];
        self.label.numberOfLines = 0;
        self.label.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:self.label];
        
    }
    return self;
}

- (void)layoutSubviews {
    self.iconView.frame = CGRectMake(EV_PRIVACY_NOTICE_MARGIN, EV_PRIVACY_NOTICE_MARGIN, self.iconView.image.size.width, self.iconView.image.size.height);
    self.label.frame = CGRectMake(CGRectGetMaxX(self.iconView.frame) + EV_PRIVACY_NOTICE_MARGIN,
                                  0,
                                  self.frame.size.width - CGRectGetMaxX(self.iconView.frame) - 2*EV_PRIVACY_NOTICE_MARGIN,
                                  self.frame.size.height);
    
    [super layoutSubviews];
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:2.0];
    [path setLineCapStyle:kCGLineCapRound];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineWidth:1.0];
    [path addClip]; // very important!  Keeps the rounded corners from looking all overflowed and shitty
    [EV_RGB_COLOR(0.9020, 0.8941, 0.8902) setFill];
    [EV_RGB_COLOR(0.8196, 0.8039, 0.7961) setStroke];
    [path fill];
    [path stroke];
}

@end
