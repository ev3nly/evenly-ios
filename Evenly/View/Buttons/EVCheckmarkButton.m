//
//  EVCheckmarkButton.m
//  Evenly
//
//  Created by Justin Brunet on 6/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVCheckmarkButton.h"
#import "EVTapGestureRecognizer.h"

#define SIDE_MARGIN 20
#define CHECK_LABEL_BUFFER 10

@interface EVCheckmarkButton ()

@property (nonatomic, strong) UIImageView *check;
@property (nonatomic, strong) UILabel *label;

- (void)loadCheckHole;
- (void)loadLabel;

@end

@implementation EVCheckmarkButton

#pragma mark - Lifecycle

- (id)initWithText:(NSString *)text {
    if (self = [super initWithFrame:CGRectZero]) {
        self.text = text;
        [self loadCheckHole];
        [self loadLabel];
        EVTapGestureRecognizer *tapRecognizer = [[EVTapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapRecognizer.delegate = self;
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.check.frame = [self checkHoleFrame];
    self.label.frame = [self labelFrame];
}

#pragma mark - View Loading

- (void)loadCheckHole {
    self.check = [[UIImageView alloc] initWithImage:[EVImages checkHoleEmpty]];
    [self addSubview:self.check];
}

- (void)loadLabel {
    self.label = [UILabel new];
    self.label.text = self.text;
    self.label.textColor = [EVColor lightLabelColor];
    self.label.font = [EVFont defaultFontOfSize:15];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.numberOfLines = 2;
    [self addSubview:self.label];
}

#pragma mark - Gesture Handling

- (void)handleTap:(EVTapGestureRecognizer *)tapRecognizer {
    if (tapRecognizer.state == UIGestureRecognizerStateBegan) {
        [self setHighlighted:YES];
    }
    else if (tapRecognizer.state == UIGestureRecognizerStateChanged) {
        [self setHighlighted:[tapRecognizer isWithinView]];
    }
    else if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        [self setHighlighted:NO];
        [self fadeBetweenChecks];
    }
    else if (tapRecognizer.state == UIGestureRecognizerStateCancelled || tapRecognizer.state == UIGestureRecognizerStateFailed) {
        [self setHighlighted:NO];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted) {
        self.label.textColor = [EVColor darkLabelColor];
    } else {
        self.label.textColor = [EVColor lightLabelColor];
    }
}

- (void)fadeBetweenChecks {
    UIImage *newCheckImage = !self.checked ? [EVImages checkHoleChecked] : [EVImages checkHoleEmpty];
    UIImageView *newCheck = [[UIImageView alloc] initWithImage:newCheckImage];
    newCheck.frame = self.check.frame;
    newCheck.alpha = self.checked;
    [self addSubview:newCheck];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (self.checked)
                             self.check.alpha = 0;
                         else
                             newCheck.alpha = 1;
                     } completion:^(BOOL finished) {
                         self.check.alpha = 1;
                         self.checked = !self.checked;
                         [newCheck removeFromSuperview];
                     }];
}

#pragma mark - Setters

- (void)setChecked:(BOOL)checked {
    _checked = checked;
    
    if (checked)
        self.check.image = [EVImages checkHoleChecked];
    else
        self.check.image = [EVImages checkHoleEmpty];
}

- (void)setText:(NSString *)text {
    _text = text;
    
    if (self.label)
        self.label.text = text;
}

#pragma mark - Frames

- (CGRect)checkHoleFrame {
    return CGRectMake(SIDE_MARGIN,
                      CGRectGetMidY(self.bounds) - self.check.image.size.height/2,
                      self.check.image.size.width,
                      self.check.image.size.height);
}

- (CGRect)labelFrame {
    float maxLabelWidth = (self.bounds.size.width - CGRectGetMaxX(self.check.frame) - SIDE_MARGIN - CHECK_LABEL_BUFFER);
    CGSize labelSize = [self.label.text sizeWithFont:self.label.font
                                   constrainedToSize:CGSizeMake(maxLabelWidth, 1000)
                                       lineBreakMode:self.label.lineBreakMode];
    return CGRectMake(CGRectGetMaxX(self.check.frame) + CHECK_LABEL_BUFFER,
                      CGRectGetMidY(self.bounds) - labelSize.height/2,
                      labelSize.width,
                      labelSize.height);
}

@end
