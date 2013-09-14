//
//  EVCheckmarkLinkButton.m
//  Evenly
//
//  Created by Joseph Hankin on 7/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVCheckmarkLinkButton.h"
#import "TTTAttributedLabel.h"

#define SIDE_MARGIN 20
#define CHECK_LABEL_BUFFER 10

@interface EVCheckmarkLinkButton ()

@property (nonatomic, strong) TTTAttributedLabel *label;
@property (nonatomic, assign) BOOL hasLinks;

@end

@implementation EVCheckmarkLinkButton

- (id)initWithText:(NSString *)text {
    self = [super initWithText:text];
    if (self) {
        self.xMargin = SIDE_MARGIN;
        // Initialization code
    }
    return self;
}

- (void)loadLabel {
    self.label = [TTTAttributedLabel new];
    self.label.textColor = [EVColor lightLabelColor];
    self.label.font = [EVFont defaultFontOfSize:15];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.numberOfLines = 2;
    [self addSubview:self.label];
}


- (void)setLinkDelegate:(id)delegate {
    self.label.delegate = delegate;
}

- (void)linkToUrl:(NSURL *)url forText:(NSString *)text {
    NSRange r = [self.label.text rangeOfString:text];
    [self.label addLinkToURL:url withRange:r];
    self.hasLinks = YES;
}

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

- (void)layoutSubviews {
    self.check.frame = [self checkHoleFrame];
    self.label.frame = [self labelFrame];
}

- (CGRect)checkHoleFrame {
    return CGRectMake(self.xMargin,
                      CGRectGetMidY(self.bounds) - self.check.image.size.height/2,
                      self.check.image.size.width,
                      self.check.image.size.height);
}

- (CGRect)labelFrame {
    float maxLabelWidth = (self.bounds.size.width - CGRectGetMaxX(self.check.frame) - self.xMargin - self.checkLabelBuffer);
    CGSize labelSize = [self.label.text _safeBoundingRectWithSize:CGSizeMake(maxLabelWidth, 1000)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName: self.label.font}
                                                          context:NULL].size;

    return CGRectMake(CGRectGetMaxX(self.check.frame) + self.checkLabelBuffer,
                      CGRectGetMidY(self.bounds) - labelSize.height/2,
                      labelSize.width,
                      labelSize.height);
}

@end
