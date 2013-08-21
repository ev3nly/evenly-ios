//
//  EVSharingSelectorView.m
//  Evenly
//
//  Created by Justin Brunet on 8/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVSharingSelectorView.h"

#define LABEL_X_ORIGIN 10
#define LABEL_RIGHT_BUFFER 10
#define LABEL_Y_OFFSET 2

#define EVENLY_LOGO_X_ORIGIN 160
#define LOGO_LOGO_BUFFER 20

@interface EVSharingSelectorView ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *evenlyLogo;
@property (nonatomic, strong) UIImageView *facebookLogo;
@property (nonatomic, strong) UIImageView *twitterLogo;

@end

@implementation EVSharingSelectorView

+ (int)numberOfLines {
    return 1;
}

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [EVColor creamColor];
        self.shareOnEvenly = YES;
        [self loadLabel];
        [self loadEvenlyLogo];
        [self loadFacebookLogo];
        [self loadTwitterLogo];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.label.frame = [self labelFrame];
    self.evenlyLogo.frame = [self evenlyLogoFrame];
    self.facebookLogo.frame = [self facebookLogoFrame];
    self.twitterLogo.frame = [self twitterLogoFrame];
}

#pragma mark - View Loading

- (void)loadLabel {
    self.label = [UILabel new];
    self.label.text = @"Share On...";
    self.label.textColor = [EVColor lightLabelColor];
    self.label.font = [EVFont darkExchangeFormFont];
    self.label.backgroundColor = [UIColor clearColor];
    [self addSubview:self.label];
}

- (void)loadEvenlyLogo {
    self.evenlyLogo = [[UIImageView alloc] initWithImage:[EVImages shareEvenlyActive]];
    [self addSubview:self.evenlyLogo];
    [self.evenlyLogo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(evenlyTapped)]];
    self.evenlyLogo.userInteractionEnabled = YES;
}

- (void)loadFacebookLogo {
    self.facebookLogo = [[UIImageView alloc] initWithImage:[EVImages shareFacebookInactive]];
    [self addSubview:self.facebookLogo];
    [self.facebookLogo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(facebookTapped)]];
    self.facebookLogo.userInteractionEnabled = YES;
}

- (void)loadTwitterLogo {
    self.twitterLogo = [[UIImageView alloc] initWithImage:[EVImages shareTwitterInactive]];
    [self addSubview:self.twitterLogo];
    [self.twitterLogo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twitterTapped)]];
    self.twitterLogo.userInteractionEnabled = YES;
}

- (void)loadCells {
    //this doesn't need cells
}

#pragma mark - Button Handling

- (void)evenlyTapped {
    self.shareOnEvenly = !self.shareOnEvenly;
    self.evenlyLogo.image = self.shareOnEvenly ? [EVImages shareEvenlyActive] : [EVImages shareEvenlyInactive];
}

- (void)facebookTapped {
    self.shareOnFacebook = !self.shareOnFacebook;
    self.facebookLogo.image = self.shareOnFacebook ? [EVImages shareFacebookActive] : [EVImages shareFacebookInactive];
}

- (void)twitterTapped {
    self.shareOnTwitter = !self.shareOnTwitter;
    self.twitterLogo.image = self.shareOnTwitter ? [EVImages shareTwitterActive] : [EVImages shareTwitterInactive];
}

#pragma mark - Frames

- (CGRect)labelFrame {
    return CGRectMake(LABEL_X_ORIGIN,
                      LABEL_Y_OFFSET,
                      self.bounds.size.width - LABEL_X_ORIGIN - LABEL_RIGHT_BUFFER,
                      self.bounds.size.height - LABEL_Y_OFFSET);
}

- (CGRect)evenlyLogoFrame {
    [self.evenlyLogo sizeToFit];
    return CGRectMake(EVENLY_LOGO_X_ORIGIN,
                      self.bounds.size.height/2 - self.evenlyLogo.bounds.size.height/2,
                      self.evenlyLogo.bounds.size.width,
                      self.evenlyLogo.bounds.size.height);
}

- (CGRect)facebookLogoFrame {
    [self.facebookLogo sizeToFit];
    return CGRectMake(CGRectGetMaxX(self.evenlyLogo.frame) + LOGO_LOGO_BUFFER,
                      self.bounds.size.height/2 - self.facebookLogo.bounds.size.height/2,
                      self.facebookLogo.bounds.size.width,
                      self.facebookLogo.bounds.size.height);
}

- (CGRect)twitterLogoFrame {
    [self.twitterLogo sizeToFit];
    return CGRectMake(CGRectGetMaxX(self.facebookLogo.frame) + LOGO_LOGO_BUFFER,
                      self.bounds.size.height/2 - self.twitterLogo.bounds.size.height/2,
                      self.twitterLogo.bounds.size.width,
                      self.twitterLogo.bounds.size.height);
}

@end
