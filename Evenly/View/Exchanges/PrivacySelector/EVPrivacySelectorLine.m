//
//  EVPrivacySelectorLine.m
//  Evenly
//
//  Created by Justin Brunet on 6/13/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPrivacySelectorLine.h"

#define LABEL_X_ORIGIN 40
#define LABEL_INDENT 12
#define LABEL_RIGHT_BUFFER 10
#define LABEL_Y_OFFSET 2

@interface EVPrivacySelectorLine ()

- (void)loadImageView;
- (void)loadLabel;

- (void)addTapRecognizer;
- (void)handleTap:(EVTapGestureRecognizer *)tapRecognizer;

@end

@implementation EVPrivacySelectorLine

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame andSetting:(EVPrivacySetting)setting
{
    if (self = [super initWithFrame:frame])
    {
        self.setting = setting;
        [self loadImageView];
        [self loadLabel];
        [self addTapRecognizer];
        [[EVCIA me] addObserver:self forKeyPath:@"privacySetting" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)dealloc
{
    [[EVCIA me] removeObserver:self forKeyPath:@"privacySetting"];
}

#pragma mark - View Loading

- (void)loadImageView
{
    self.privacyImageView = [[UIImageView alloc] initWithImage:[self imageForSetting:self.setting]];
    self.privacyImageView.frame = [self imageViewFrame];
    self.privacyImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.privacyImageView];
}

- (void)loadLabel
{
    self.label = [UILabel new];
    self.label.text = [self textForSetting:self.setting];
    self.label.textColor = [self labelColor];
    self.label.font = [EVFont darkExchangeFormFont];
    self.label.frame = [self labelFrame];
    self.label.backgroundColor = [UIColor clearColor];
    [self addSubview:self.label];
}

#pragma mark - Gesture Handling

- (void)addTapRecognizer
{
    EVTapGestureRecognizer *tapRecognizer = [[EVTapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapRecognizer];
}

- (void)handleTap:(EVTapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateBegan) {
        [self setHighlighted:YES];
    }
    else if (tapRecognizer.state == UIGestureRecognizerStateChanged) {
        [self setHighlighted:[tapRecognizer isWithinView]];
    }
    else if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        [self setHighlighted:NO];
        [self handleTouchUpInside];
    }
    else if (tapRecognizer.state == UIGestureRecognizerStateCancelled || tapRecognizer.state == UIGestureRecognizerStateFailed) {
        [self setHighlighted:NO];
    }
}

- (void)handleTouchUpInside {
    //implement in subclass
}

- (void)setHighlighted:(BOOL)highlighted {
    //implement in subclass
}

#pragma mark - Utility

- (UIImage *)imageForSetting:(EVPrivacySetting)setting {
    switch (setting) {
        case EVPrivacySettingFriends:
            return [EVImages friendsIcon];
        case EVPrivacySettingNetwork:
            return [EVImages globeIcon];
        case EVPrivacySettingPrivate:
            return [EVImages lockIcon];
        default:
            return nil;
    }
}

- (NSString *)textForSetting:(EVPrivacySetting)setting {
    switch (setting) {
        case EVPrivacySettingFriends:
            return @"Friends";
        case EVPrivacySettingNetwork:
            return @"Network";
        case EVPrivacySettingPrivate:
            return @"Private";
        default:
            return nil;
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //implement in subclass
}

#pragma mark - View Defines

- (CGRect)imageViewFrame {
    return CGRectMake(LABEL_X_ORIGIN/2 - _privacyImageView.image.size.width/2,
                      self.bounds.size.height/2 - _privacyImageView.image.size.height/2,
                      _privacyImageView.image.size.width,
                      _privacyImageView.image.size.height);
}

- (CGRect)labelFrame {
    return CGRectMake(LABEL_X_ORIGIN,
                      LABEL_Y_OFFSET,
                      self.bounds.size.width - LABEL_X_ORIGIN - LABEL_RIGHT_BUFFER,
                      self.bounds.size.height - LABEL_Y_OFFSET);
}

- (UIColor *)labelColor {
    return [EVColor lightLabelColor];
}

@end
