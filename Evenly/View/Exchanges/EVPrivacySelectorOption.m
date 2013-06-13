//
//  EVPrivacySelectorOption.m
//  Evenly
//
//  Created by Justin Brunet on 6/13/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPrivacySelectorOption.h"

#define CHECK_BUFFER 10
#define INDENTATION 20

@interface EVPrivacySelectorOption () {
    UIImageView *_check;
}

- (void)loadCheck;
- (CGRect)checkFrame;

@end

@implementation EVPrivacySelectorOption

- (id)initWithFrame:(CGRect)frame andSetting:(EVPrivacySetting)setting
{
    if (self = [super initWithFrame:frame andSetting:setting])
    {
        [self loadCheck];
    }
    return self;
}

- (void)loadCheck
{
    _check = [[UIImageView alloc] initWithImage:[EVImages checkIcon]];
    _check.backgroundColor = [UIColor clearColor];
    _check.frame = [self checkFrame];
    [self addSubview:_check];
    if (self.setting != [EVUser me].privacySetting)
        _check.alpha = 0;
}

- (void)handleTouchUpInside
{
    [EVUser me].privacySetting = self.setting;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.label.textColor = [UIColor whiteColor];
    }
    else {
        self.backgroundColor = [UIColor clearColor];
        self.label.textColor = [self labelColor];

    }
}

- (UIColor *)labelColor {
    return EV_RGB_COLOR(50, 50, 50);
}

- (CGRect)imageViewFrame {
    CGRect superFrame = [super imageViewFrame];
    superFrame.origin.x += INDENTATION;
    return superFrame;
}

- (CGRect)labelFrame {
    CGRect superFrame = [super labelFrame];
    superFrame.origin.x += INDENTATION;
    return superFrame;
}

- (CGRect)checkFrame {
    return CGRectMake(self.bounds.size.width - _check.image.size.width - CHECK_BUFFER,
                      self.bounds.size.height/2 - _check.image.size.height/2,
                      _check.image.size.width,
                      _check.image.size.height);
}

@end
