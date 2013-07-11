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
#define COLORED_LOGO_MIN_ALPHA 0.20
#define COLORED_LOGO_MAX_ALPHA 0.75

@interface EVLoadingIndicator ()

@property (nonatomic, strong) UIImageView *spinnerView;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UIImageView *coloredLogoView;

@end

@implementation EVLoadingIndicator

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadSpinnerView];
        [self loadLogoView];
        [self loadColoredLogoView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.spinnerView.frame = [self spinnerViewFrame];
    self.logoView.frame = [self logoViewFrame];
    self.coloredLogoView.frame = [self logoViewFrame];
}

#pragma mark - View Loading

- (void)loadSpinnerView {
    self.spinnerView = [[UIImageView alloc] initWithImage:[EVImages loadingSpinner]];
    [self addSubview:self.spinnerView];
}

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
    [self zoomBounceWithDuration:0.2 completion:nil];
    [self.spinnerView rotateContinuouslyWithDuration:ROTATION_DURATION];
    [self.coloredLogoView pulseFromAlpha:COLORED_LOGO_MIN_ALPHA toAlpha:COLORED_LOGO_MAX_ALPHA duration:ROTATION_DURATION*2];
}

- (void)stopAnimating {
    [self shrinkBounceWithDuration:0.2 completion:^{
        [self removeFromSuperview];
    }];
}

#pragma mark - Frames

- (CGSize)sizeThatFits:(CGSize)size {
    return self.spinnerView.image.size;
}

- (CGRect)spinnerViewFrame {
    [self.spinnerView sizeToFit];
    return self.spinnerView.bounds;
}

- (CGRect)logoViewFrame {
    [self.logoView sizeToFit];
    return CGRectMake(CGRectGetMidX(self.bounds) - self.logoView.bounds.size.width/2,
                      CGRectGetMidY(self.bounds) - self.logoView.bounds.size.height/2,
                      self.logoView.bounds.size.width,
                      self.logoView.bounds.size.height);
}

@end
