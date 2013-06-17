//
//  EVSwitch.m
//  Evenly
//
//  Created by Joseph Hankin on 6/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVSwitch.h"

#define EV_SWITCH_HANDLE_MARGIN 2.0
#define EV_SWITCH_HANDLE_LABEL_OFFSET 7.0

@interface EVSwitch ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic) CGPoint startingOrigin;

// For internal use only.  Changing the value of the switch in response to gesture
// recognition should call this method, which will send the actions for the control event.
// (The public method does not send actinos.)
- (void)_setOn:(BOOL)on animated:(BOOL)animated;

@end

@implementation EVSwitch

+ (CGSize)size {
    return [UIImage imageNamed:@"toggle_off_bg"].size;
}

- (id)initWithFrame:(CGRect)frame
{
    CGSize size = [[self class] size];
    self = [super initWithFrame:(CGRect){frame.origin, size}];
    if (self) {
        self.on = NO;
        
        [self loadBackground];
        [self loadHandle];
        [self loadLabel];
        [self loadGestureRecognizers];
    }
    return self;
}

#pragma mark - View Loading

- (void)loadBackground {
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.backgroundImageView];
    self.backgroundImageView.userInteractionEnabled = YES;
    [self updateBackgroundImage];
}

- (void)loadHandle {
    self.handleImageView = [[UIImageView alloc] initWithImage:[self handleImage]];
    self.handleImageView.frame = CGRectMake(EV_SWITCH_HANDLE_MARGIN,
                                            EV_SWITCH_HANDLE_MARGIN,
                                            self.handleImageView.frame.size.width,
                                            self.handleImageView.frame.size.height);
    [self addSubview:self.handleImageView];
    self.handleImageView.userInteractionEnabled = YES;
}

- (void)loadLabel {
    self.label = [[UILabel alloc] initWithFrame:[self labelFrameForState:self.on]];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textColor = [UIColor whiteColor];
    self.label.font = [EVFont blackFontOfSize:15];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.text = [self labelTextForState:self.on];
    [self insertSubview:self.label belowSubview:self.handleImageView];
}

- (void)loadGestureRecognizers {
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    [self addGestureRecognizer:self.panGestureRecognizer];
    
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeGestureRecognized:)];
    [self.leftSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:self.leftSwipeGestureRecognizer];
    
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeGestureRecognized:)];
    [self.rightSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:self.rightSwipeGestureRecognizer];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    [self addGestureRecognizer:self.tapGestureRecognizer];
}

#pragma mark - Public Interface

- (void)setOn:(BOOL)on {
    [self setOn:on animated:NO];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
    _on = on;
    [UIView animateWithDuration:(animated ? EV_DEFAULT_ANIMATION_DURATION : 0.0) animations:^{
        [self layoutForState];
    }];
}

- (void)layoutForState {
    [self.handleImageView setFrame:[self handleFrameForState:self.on]];
    [self.label setFrame:[self labelFrameForState:self.on]];
    [self.label setText:[self labelTextForState:self.on]];
    [self updateBackgroundImage];
}

#pragma mark - Gesture Recognizers

- (void)panGestureRecognized:(UIPanGestureRecognizer *)panRecognizer {
    if (panRecognizer.state == UIGestureRecognizerStateBegan)
    {
        self.startingOrigin = self.handleImageView.frame.origin;
    }
    
    CGPoint translation = [panRecognizer translationInView:self];
    CGPoint location = CGPointMake(self.startingOrigin.x + translation.x, self.startingOrigin.y);

    CGFloat minX = EV_SWITCH_HANDLE_MARGIN;
    CGFloat maxX = self.frame.size.width - self.handleImageView.frame.size.width - EV_SWITCH_HANDLE_MARGIN;
    CGFloat halfwayPoint = (minX + maxX) / 2.0;

    if (location.x < minX)
        location.x = minX;
    else if (location.x > maxX)
        location.x = maxX;
    
    if (panRecognizer.state == UIGestureRecognizerStateChanged)
    {
        float percentage = (location.x - minX) / (maxX - minX);
        [self.handleImageView setFrame:[self handleFrameForPercentage:percentage]];
        [self.label setFrame:[self labelFrameForPercentage:percentage]];
        [self.handleImageView setOrigin:location];
    }
    
    if (panRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [self _setOn:(location.x >= halfwayPoint) animated:YES];
    }
}

- (void)leftSwipeGestureRecognized:(UISwipeGestureRecognizer *)swipeRecognizer {
    [self _setOn:NO animated:YES];
}

- (void)rightSwipeGestureRecognized:(UISwipeGestureRecognizer *)swipeRecognizer {
    [self _setOn:YES animated:YES];
}

- (void)tapGestureRecognized:(UITapGestureRecognizer *)tapRecognizer {
    [self _setOn:!self.on animated:YES];
}

#pragma mark - Private Methods


- (void)_setOn:(BOOL)on animated:(BOOL)animated {
    [self setOn:on animated:animated];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)updateBackgroundImage {
    self.backgroundImageView.image = (self.on ? [self onImage] : [self offImage]);
}

- (UIImage *)offImage {
    return [UIImage imageNamed:@"toggle_off_bg"];
}

- (UIImage *)onImage {
    return [UIImage imageNamed:@"toggle_on_bg"];
}

- (UIImage *)handleImage {
    return [UIImage imageNamed:@"toggle_handle"];
}

#pragma mark Handle

- (CGRect)handleFrameForState:(BOOL)isOn {
    return [self handleFrameForPercentage:(isOn ? 1.0 : 0.0)];
}

- (CGRect)handleFrameForPercentage:(float)percentage {
    CGRect frame = CGRectMake(EV_SWITCH_HANDLE_MARGIN,
                              EV_SWITCH_HANDLE_MARGIN,
                              self.handleImageView.frame.size.width,
                              self.handleImageView.frame.size.height);
    CGFloat minX = frame.origin.x;
    CGFloat maxX = self.frame.size.width - self.handleImageView.frame.size.width - EV_SWITCH_HANDLE_MARGIN;
    CGFloat difference = maxX - minX;
    CGFloat x = minX + (difference * percentage);
    frame.origin.x = x;
    return frame;
}

#pragma mark Label

- (CGRect)labelFrameForState:(BOOL)isOn {
    return [self labelFrameForPercentage:(isOn ? 1.0 : 0.0)];
}

- (CGRect)labelFrameForPercentage:(float)percentage {
    
    CGRect frame = CGRectMake(0,
                              EV_SWITCH_HANDLE_MARGIN,
                              self.frame.size.width - [self handleImageView].frame.size.width - 2*EV_SWITCH_HANDLE_MARGIN - EV_SWITCH_HANDLE_LABEL_OFFSET,
                              self.frame.size.height - EV_SWITCH_HANDLE_MARGIN);
    CGFloat minX = self.handleImageView.frame.size.width + EV_SWITCH_HANDLE_MARGIN;
    CGFloat maxX = EV_SWITCH_HANDLE_MARGIN + EV_SWITCH_HANDLE_LABEL_OFFSET;
    CGFloat difference = MAX(0, minX - maxX);
    CGFloat x = minX - (difference * percentage);
    frame.origin.x = x;
    return frame;
}

- (NSString *)labelTextForState:(BOOL)isOn {
    return (isOn ? [EVStringUtility onString] : [EVStringUtility offString]);
}

@end
