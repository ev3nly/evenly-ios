//
//  EVRewardsSlider.m
//  Evenly
//
//  Created by Joseph Hankin on 7/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRewardsSlider.h"

#define X_MARGIN 20

#define NUMBER_OF_ARROWS 3

NSString *const EVRewardsSliderPanBeganNotification = @"EVRewardsSliderPanBeganNotification";
NSString *const EVRewardsSliderPanEndedNotification = @"EVRewardsSliderPanEndedNotification";
NSString *const EVRewardsSliderSwipeBeganNotification = @"EVRewardsSliderSwipeBeganNotification";
NSString *const EVRewardsSliderSwipeEndedNotification = @"EVRewardsSliderSwipeEndedNotification";

@implementation EVRewardsSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
        [self loadForeground];
        
        [self loadBackground];
        
        self.swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognized:)];
        self.swipeRecognizer.delegate = self;
        [self.swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self.foregroundView addGestureRecognizer:self.swipeRecognizer];

        self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
        self.panRecognizer.delegate = self;
        [self.foregroundView addGestureRecognizer:self.panRecognizer];
        
        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
        [self.foregroundView addGestureRecognizer:self.tapRecognizer];
        
        self.backgroundColor = [EVColor darkColor];
        
        self.animationEnabled = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(panBegan:)
                                                     name:EVRewardsSliderPanBeganNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(panEnded:)
                                                     name:EVRewardsSliderPanEndedNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(swipeBegan:)
                                                     name:EVRewardsSliderSwipeBeganNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(swipeEnded:)
                                                     name:EVRewardsSliderSwipeEndedNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadForeground {
    self.foregroundView = [[UIView alloc] initWithFrame:[self offscreenRect]];
    self.foregroundView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    [self addSubview:self.foregroundView];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(X_MARGIN, 0, 150, self.frame.size.height)];
    self.label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textColor = EV_RGB_ALPHA_COLOR(36, 45, 50, 0.5);
    self.label.font = [EVFont blackFontOfSize:16];
    [self.foregroundView addSubview:self.label];
    
    UIImage *arrowImage = [UIImage imageNamed:@"reward_arrow"];
    self.arrowContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, arrowImage.size.width * NUMBER_OF_ARROWS, arrowImage.size.height)];
    
    for (int i = 0; i < NUMBER_OF_ARROWS; i++) {
        UIImageView *arrow = [[UIImageView alloc] initWithImage:arrowImage];
        [arrow setOrigin:CGPointMake(arrowImage.size.width * i, 0)];
        [self.arrowContainer addSubview:arrow];
    }
    
    [self.arrowContainer setOrigin:CGPointMake(self.frame.size.width - self.arrowContainer.frame.size.width - X_MARGIN,
                                               (self.frame.size.height- self.arrowContainer.frame.size.height) / 2.0)];
    [self.foregroundView addSubview:self.arrowContainer];
}

- (void)setForegroundColor:(UIColor *)foregroundColor {
    _foregroundColor = foregroundColor;
    [self.foregroundView setBackgroundColor:_foregroundColor];
}

- (void)loadBackground {
    self.backgroundView = [[EVRewardsSliderBackground alloc] initWithFrame:self.bounds];
    self.backgroundView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    [self insertSubview:self.backgroundView belowSubview:self.foregroundView];
    
    // Hide the background view logos until we have made an appearance.
    for (UIView *view in self.backgroundView.logos) {
        view.hidden = YES;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    [self.backgroundView setBackgroundColor:_backgroundColor];
}

- (void)setRewardAmount:(NSDecimalNumber *)rewardAmount {
    [self setRewardAmount:rewardAmount animated:NO];
}

- (void)setRewardAmount:(NSDecimalNumber *)rewardAmount animated:(BOOL)animated {
    _rewardAmount = rewardAmount;
    [self.backgroundView stopAnimating];
    [self.backgroundView setRewardAmount:rewardAmount animated:animated];
}

#pragma mark - Animation

- (CGRect)offscreenRect {
    return CGRectMake(-self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
}

- (void)makeAnAppearanceWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion {
    self.foregroundView.frame = [self offscreenRect];
    [self.foregroundView bounceAnimationToFrame:self.bounds
                                       duration:duration
                                     completion:^{
                                         for (UIView *view in self.backgroundView.logos) {
                                             view.hidden = NO;
                                         }
                                         if (completion)
                                             completion();
                                     }];
}


- (void)animateOut {
    [self.foregroundView bounceAnimationToFrame:[self offscreenRect]
                                       duration:EV_DEFAULT_ANIMATION_DURATION
                                     completion:^{
                                         [[NSNotificationCenter defaultCenter] postNotificationName:EVRewardsSliderPanEndedNotification
                                                                                             object:self];
                                         [[NSNotificationCenter defaultCenter] postNotificationName:EVRewardsSliderSwipeEndedNotification
                                                                                             object:self];
                                         [self sendActionsForControlEvents:UIControlEventValueChanged];
                                         if (self.animationEnabled)
                                             [[self backgroundView] startAnimating];
                                     }];
}

- (void)animateIn {
    [self.foregroundView bounceAnimationToFrame:self.bounds
                                       duration:EV_DEFAULT_ANIMATION_DURATION
                                     completion:^{
                                         [[NSNotificationCenter defaultCenter] postNotificationName:EVRewardsSliderPanEndedNotification
                                                                                             object:self];
                                         [[NSNotificationCenter defaultCenter] postNotificationName:EVRewardsSliderSwipeEndedNotification
                                                                                             object:self];
                                     }];
}

- (void)pulse {
    [UIView animateWithDuration:EV_DEFAULT_ANIMATION_DURATION
                     animations:^{
                         self.arrowContainer.transform = CGAffineTransformMakeScale(1.5, 1.5);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:EV_DEFAULT_ANIMATION_DURATION
                                          animations:^{
                                              self.arrowContainer.transform = CGAffineTransformIdentity;
                                          } completion:NULL];
                     }];
}

#pragma mark - Gesture Recognition

- (void)panRecognized:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self];

    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:EVRewardsSliderPanBeganNotification object:self];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        
        [self.foregroundView setOrigin:CGPointMake(MIN(translation.x, 0.0), 0)];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        if (translation.x < -(self.frame.size.width / 2.0)) {
            [self animateOut];
        } else {
            [self animateIn];
        }
    }
}

- (void)swipeRecognized:(UISwipeGestureRecognizer *)recognizer {
    [[NSNotificationCenter defaultCenter] postNotificationName:EVRewardsSliderSwipeBeganNotification object:self];
    [self animateOut];
}

- (void)tapRecognized:(UITapGestureRecognizer *)recognizer {
    [self pulse];
}

#pragma mark - Notifications

- (void)panBegan:(NSNotification *)notification {
    if ([notification object] != self) {
        self.enabled = NO;
    }
}

- (void)swipeBegan:(NSNotification *)notification {
    if ([notification object] != self) {
        self.enabled = NO;
    }
}

- (void)panEnded:(NSNotification *)notification {
    self.enabled = YES;
}

- (void)swipeEnded:(NSNotification *)notification {
    self.enabled = YES;
}

#pragma mark - Overrides

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self.swipeRecognizer setEnabled:enabled];
    [self.panRecognizer setEnabled:enabled];
    [self.tapRecognizer setEnabled:enabled];
}

@end
