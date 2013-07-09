//
//  EVCheckmarkButton.m
//  Evenly
//
//  Created by Justin Brunet on 6/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVCheckmarkButton.h"
#import "EVTapGestureRecognizer.h"
#import "TTTAttributedLabel.h"

#define SIDE_MARGIN 20
#define CHECK_LABEL_BUFFER 10

@interface EVCheckmarkButton ()

@property (nonatomic, strong) UIImageView *check;
@property (nonatomic, strong) TTTAttributedLabel *label;
@property (nonatomic, assign) BOOL hasLinks;

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
        EVTapGestureRecognizer *tapRecognizer = [[EVTapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapRecognizer.delegate = self;
        tapRecognizer.cancelsTouchesInView = NO;
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
    self.label = [TTTAttributedLabel new];
    self.label.textColor = [EVColor lightLabelColor];
    self.label.font = [EVFont defaultFontOfSize:15];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.numberOfLines = 2;
    [self addSubview:self.label];
}

#pragma mark - Gesture Handling

static BOOL ignoringTap = NO;

- (void)handleTap:(EVTapGestureRecognizer *)tapRecognizer {
    CGPoint location = [tapRecognizer locationInView:self];
    if (CGRectContainsPoint(self.label.frame, location) && self.hasLinks)
        ignoringTap = YES;
        
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

- (void)setLinkDelegate:(id)delegate {
    self.label.delegate = delegate;
}

- (void)linkToUrl:(NSURL *)url forText:(NSString *)text {
    NSRange r = [self.label.text rangeOfString:text];
    [self.label addLinkToURL:url withRange:r];
    self.hasLinks = YES;
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
