//
//  EVLoadingIndicator.m
//  Evenly
//
//  Created by Justin Brunet on 7/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVLoadingIndicator.h"
#import <QuartzCore/QuartzCore.h>

#define ROTATION_DURATION 0.8
#define PULSE_DURATION 1.0
#define COLORED_LOGO_MIN_ALPHA 0.1
#define COLORED_LOGO_MAX_ALPHA 0.7

@interface EVLoadingIndicator ()

@property (nonatomic, strong) UIImageView *spinnerView;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UIImageView *coloredLogoView;

@property (nonatomic, assign) BOOL animating;

@end

@implementation EVLoadingIndicator

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadLogoView];
        [self loadColoredLogoView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.logoView.frame = [self logoViewFrame];
    self.coloredLogoView.frame = [self logoViewFrame];
}

#pragma mark - View Loading

- (void)loadLogoView {
    self.logoView = [[UIImageView alloc] initWithImage:[EVImages grayLoadingLogo]];
    [self addSubview:self.logoView];
}

- (void)loadColoredLogoView {
    self.coloredLogoView = [[UIImageView alloc] initWithImage:[EVImages loadingLogo]];
    [self addSubview:self.coloredLogoView];
}

#pragma mark - Spinning

- (void)startAnimating {
    if (!self.animating) {
        [self zoomBounceWithDuration:0.2 completion:nil];
        [self.coloredLogoView pulseFromAlpha:COLORED_LOGO_MIN_ALPHA toAlpha:COLORED_LOGO_MAX_ALPHA duration:PULSE_DURATION];
        self.animating = YES;
    }
}

- (void)stopAnimating {
    if (self.animating) {
        [self shrinkBounceWithDuration:0.2 completion:^{
            [self removeFromSuperview];
            self.animating = NO;
        }];
    }
}

#pragma mark - Frames

- (CGRect)logoViewFrame {
    [self.logoView sizeToFit];
    return CGRectMake(CGRectGetMidX(self.bounds) - self.logoView.bounds.size.width/2,
                      CGRectGetMidY(self.bounds) - self.logoView.bounds.size.height/2,
                      self.logoView.bounds.size.width,
                      self.logoView.bounds.size.height);
}

@end
