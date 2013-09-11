//
//  EVCheckmarkButton.m
//  Evenly
//
//  Created by Justin Brunet on 6/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVCheckmarkButton.h"

@interface EVCheckmarkButton ()

@property (nonatomic, strong) UILabel *label;

- (void)loadCheckHole;
- (void)loadLabel;

@end

@implementation EVCheckmarkButton

#pragma mark - Lifecycle

- (id)initWithText:(NSString *)text {
    if (self = [super initWithFrame:CGRectZero]) {
        [self loadCheckHole];
        [self loadLabel];
        self.text = text;
        
        self.xMargin = 10.0;
        self.checkLabelBuffer = 10.0;
        
        EVTapGestureRecognizer *tapRecognizer = [[EVTapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapRecognizer.delegate = self;
        tapRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)layoutSubviews {
    float maxLabelWidth = (self.bounds.size.width - CGRectGetMaxX(self.check.frame) - self.xMargin - self.checkLabelBuffer);
    
    CGSize labelSize = [self.label multiLineSizeForWidth:maxLabelWidth];
    CGFloat totalWidth = self.check.image.size.width + self.checkLabelBuffer + labelSize.width;
    CGFloat xOrigin = (self.frame.size.width - totalWidth) / 2.0;
    
    self.check.frame = CGRectMake(xOrigin,
                                  (self.frame.size.height - self.check.image.size.height) / 2.0,
                                  self.check.image.size.width,
                                  self.check.image.size.height);
    
    self.label.frame = CGRectMake(CGRectGetMaxX(self.check.frame) + self.checkLabelBuffer,
                                  CGRectGetMidY(self.bounds) - labelSize.height/2,
                                  labelSize.width,
                                  labelSize.height);
}

#pragma mark - View Loading

- (void)loadCheckHole {
    self.check = [[UIImageView alloc] initWithImage:[EVImages checkHoleEmpty]];
    [self addSubview:self.check];
}

- (void)loadLabel {
    self.label = [UILabel new];
    self.label.textColor = [EVColor darkColor];
    self.label.font = [EVFont blackFontOfSize:15];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.numberOfLines = 1;
    [self addSubview:self.label];
}

static BOOL ignoringTap = NO;

- (void)handleTap:(EVTapGestureRecognizer *)tapRecognizer {    
    if (tapRecognizer.state == UIGestureRecognizerStateBegan && !ignoringTap) {
        [self setHighlighted:YES];
    }
    else if (tapRecognizer.state == UIGestureRecognizerStateChanged && !ignoringTap) {
        [self setHighlighted:[tapRecognizer isWithinView]];
    }
    else if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        if (ignoringTap) {
            ignoringTap = NO;
            return;
        }
        [self setHighlighted:NO];
        [self fadeBetweenChecks];
    }
    else if (tapRecognizer.state == UIGestureRecognizerStateCancelled || tapRecognizer.state == UIGestureRecognizerStateFailed) {
        if (ignoringTap) {
            ignoringTap = NO;
            return;
        }
        [self setHighlighted:NO];
    }
}

#pragma mark - Gesture Handling

- (void)setHighlighted:(BOOL)highlighted {
//    if (self.hasLinks)
        return;
    if (highlighted) {
        self.label.textColor = [EVColor darkLabelColor];
    } else {
        self.label.textColor = [EVColor lightLabelColor];
    }
    self.label.text = self.label.text;
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

@end
