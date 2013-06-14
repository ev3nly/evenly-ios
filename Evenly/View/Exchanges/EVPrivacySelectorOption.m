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

#pragma mark Lifecycle

- (id)initWithFrame:(CGRect)frame andSetting:(EVPrivacySetting)setting
{
    if (self = [super initWithFrame:frame andSetting:setting])
    {
        [self loadCheck];
    }
    return self;
}

#pragma mark - View Loading

- (void)loadCheck
{
    _check = [[UIImageView alloc] initWithImage:[EVImages checkIcon]];
    _check.backgroundColor = [UIColor clearColor];
    _check.frame = [self checkFrame];
    [self addSubview:_check];
    _check.alpha = (self.setting == [EVUser me].privacySetting);
}

#pragma mark - Gesture Handling

- (void)handleTouchUpInside
{
    [EVUser me].privacySetting = self.setting;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.label.textColor = [UIColor whiteColor];
        self.privacyImageView.image = [EVImageUtility overlayImage:[self imageForSetting:self.setting]
                                                         withColor:[UIColor whiteColor]
                                                        identifier:[NSString stringWithFormat:@"privacySetting-%i", self.setting]];
        _check.image = [EVImageUtility overlayImage:[EVImages checkIcon]
                                          withColor:[UIColor whiteColor]
                                         identifier:@"checkIcon"];
    }
    else {
        self.backgroundColor = [UIColor clearColor];
        self.label.textColor = [self labelColor];
        self.privacyImageView.image = [self imageForSetting:self.setting];
        _check.image = [EVImages checkIcon];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSNumber *newSetting = [change objectForKey:NSKeyValueChangeNewKey];
    
    [UIView animateWithDuration:0.05
                     animations:^{
                         _check.alpha = ([newSetting intValue] == self.setting);
                     }];
}

#pragma mark - View Defines

- (UIColor *)labelColor {
    return [EVColor darkLabelColor];
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
