//
//  EVThrobber.m
//  Evenly
//
//  Created by Joseph Hankin on 8/5/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVThrobber.h"
#import "EVThrobberSegment.h"

#define DEFAULT_NUMBER_OF_SEGMENTS 4

#define DEFAULT_SEGMENT_WIDTH 16.0
#define DEFAULT_SEGMENT_SPACING 8.0
#define DEFAULT_HEIGHT 30.0

@interface EVThrobber ()

@property (nonatomic, strong) NSMutableArray *segments;
@property (nonatomic) BOOL animating;

@end

@implementation EVThrobber

- (id)initWithThrobberStyle:(EVThrobberStyle)style {
    CGFloat width = (DEFAULT_NUMBER_OF_SEGMENTS * DEFAULT_SEGMENT_WIDTH) +
                    (DEFAULT_SEGMENT_SPACING * (DEFAULT_NUMBER_OF_SEGMENTS-1));
    CGFloat height = DEFAULT_HEIGHT;
    self = [self initWithFrame:CGRectMake(0, 0, width, height)];
    if (self) {
        self.style = style;
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        self.style = EVThrobberStyleLight;
        self.hidesWhenStopped = YES;
        
        self.numberOfSegments = DEFAULT_NUMBER_OF_SEGMENTS;
        self.segments = [NSMutableArray arrayWithCapacity:self.numberOfSegments];
        [self reloadSegments];
    }
    return self;
}

- (void)setNumberOfSegments:(NSInteger)numberOfSegments {
    _numberOfSegments = numberOfSegments;
    [self reloadSegments];
}

- (void)reloadSegments {
    [self.segments makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.segments removeAllObjects];
    
    for (int i = 0; i < self.numberOfSegments; i++) {
        EVThrobberSegment *segment = [[EVThrobberSegment alloc] initWithFrame:CGRectZero];
        [self addSubview:segment];
        [self.segments addObject:segment];
    }
    
    [self setNeedsLayout];
}

- (UIColor *)segmentColor {
    UIColor *color = nil;
    if (self.style == EVThrobberStyleLight) {
        color = EV_RGB_ALPHA_COLOR(255, 255, 255, 0.3);
    } else {
        color = EV_RGB_ALPHA_COLOR(24, 30, 32, 0.43);
    }
    return color;
}

- (UIColor *)segmentHighlightedColor {
    UIColor *color = nil;
    if (self.style == EVThrobberStyleLight) {
        color = EV_RGB_ALPHA_COLOR(255, 255, 255, 0.6);
    } else {
        color = EV_RGB_ALPHA_COLOR(24, 30, 32, 0.6);
    }
    return color;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat segmentWidth, segmentSpacing;
    segmentSpacing = self.frame.size.width / (3*self.numberOfSegments - 1);
    segmentWidth = segmentSpacing * 2;
    
    CGFloat xOrigin = 0.0;
    for (EVThrobberSegment *segment in self.segments) {
        [segment setFrame:CGRectMake(xOrigin, 0, segmentWidth, self.frame.size.height)];
        xOrigin += segmentWidth + segmentSpacing;
        [segment setColor:[self segmentColor]];
        [segment setHighlightedColor:[self segmentHighlightedColor]];
    }
}

- (void)startAnimating {
    if (!_animating) {
        _animating = YES;
        int i = 0;
        NSTimeInterval timeInterval = 0.1;
        for (EVThrobberSegment *segment in self.segments) {
            [segment setHidden:NO];
            EV_DISPATCH_AFTER(timeInterval*i++, ^{
                [segment startAnimating];
            });
        }
    }
}

- (void)stopAnimating {
    if (_animating) {
        _animating = NO;
        [self.segments makeObjectsPerformSelector:@selector(stopAnimating)];
        if (self.hidesWhenStopped) {
            for (EVThrobberSegment *segment in self.segments) {
                [segment setHidden:YES];
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
