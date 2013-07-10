//
//  EVLoadingIndicator.m
//  Evenly
//
//  Created by Justin Brunet on 7/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVLoadingIndicator.h"
#import <QuartzCore/QuartzCore.h>

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
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.spinnerView.frame = [self spinnerViewFrame];
    self.logoView.frame = [self logoViewFrame];
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
    
}

#pragma mark - Spinning

- (void)startAnimating {
    [self spinSpinner];
    [self pulseLogo];
}

- (void)stopAnimating {
    
}

- (void)spinSpinner {
    [self.spinnerView rotateContinuouslyWithDuration:0.8];
}

- (void)pulseLogo {
    UIImageView *coloredLogo = [[UIImageView alloc] initWithImage:[EVImages loadingLogo]];
    coloredLogo.frame = self.logoView.frame;
    coloredLogo.alpha = 0;
    [self addSubview:coloredLogo];
    
    [UIView animateWithDuration:1.0
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionRepeat
                     animations:^{
                         coloredLogo.alpha = 1;
                     } completion:^(BOOL finished) {
                         
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
