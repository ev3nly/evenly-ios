//
//  EVGroupedTableViewCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"

#define SIDE_MARGIN 10
#define VISIBLE_FRAME CGRectMake(SIDE_MARGIN, 0, self.bounds.size.width - SIDE_MARGIN*2, self.bounds.size.height)

#define CORNER_RADIUS 2.0

#define RED_CONTROL_INSET CGPointMake(8, -1)

@implementation EVGroupedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [EVColor newsfeedNounColor];
        self.textLabel.highlightedTextColor = self.textLabel.textColor;
        self.textLabel.font = [EVFont blackFontOfSize:15];
        self.backgroundColor = [UIColor clearColor];
        
        EVGroupedTableViewCellBackground *background = [[EVGroupedTableViewCellBackground alloc] initWithFrame:[self visibleFrame]];
        background.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        background.fillColor = [UIColor whiteColor];
        self.backgroundView = background;
        
        EVGroupedTableViewCellBackground *selectedBackground = [[EVGroupedTableViewCellBackground alloc] initWithFrame:[self visibleFrame]];
        selectedBackground.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        selectedBackground.fillColor = [EVColor newsfeedButtonHighlightColor];
        self.selectedBackgroundView = selectedBackground;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([EVUtilities userHasIOS7]) {
        if (self.isEditing) {
            [self resetBackgroundFrameToCounteractIos7DeleteBug];
            [self adjustRedControl];
        }
    }
}

- (void)setPosition:(EVGroupedTableViewCellPosition)position {
    _position = position;
    [(EVGroupedTableViewCellBackground *)self.backgroundView setPosition:_position];
    [(EVGroupedTableViewCellBackground *)self.selectedBackgroundView setPosition:_position];
    [self.backgroundView setNeedsDisplay];
}

#pragma mark - IOS7 Editing Fixes

/* 
    If you have a backgroundView in a tableViewCell, the background view
    will slide over incorrectly when you enter delete mode.  TableViewCells
    now have their entire view nested in a scrollView, which seems to be 
    responsible for this issue.
 
    In addition, the red delete button isn't centered in a way that looks
    nice with our layout, and it doesn't include a built-in way to change it,
    hence the redControl methods.
*/

- (void)resetBackgroundFrameToCounteractIos7DeleteBug {
    CGRect bgFrame = self.backgroundView.frame;
    bgFrame.origin.x = 0;
    self.backgroundView.frame = bgFrame;
}

- (void)adjustRedControl {
    UIScrollView *scrollView = [self mainCellSubview];
    if (scrollView) {
        UIControl *redControl = [self redControlForScrollView:scrollView];
        if (redControl) {
            CGRect controlFrame = redControl.frame;
            controlFrame.origin.x = RED_CONTROL_INSET.x;
            controlFrame.origin.y = RED_CONTROL_INSET.y;
            redControl.frame = controlFrame;
        }
    }
}

- (UIScrollView *)mainCellSubview {
    UIScrollView *scrollView;
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UIScrollView class]])
            scrollView = (UIScrollView *)subview;
    }
    return scrollView;
}

- (UIControl *)redControlForScrollView:(UIScrollView *)scrollView {
    UIControl *redControl;
    for (UIView *subview in scrollView.subviews) {
        if ([subview isKindOfClass:[UIControl class]])
            redControl = (UIControl *)subview;
    }
    return redControl;
}

- (CGRect)visibleFrame {
    if (![EVUtilities userHasIOS7])
        return self.bounds;
    return VISIBLE_FRAME;
}

@end

@implementation EVGroupedTableViewCellBackground

- (id)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.fillColor = [UIColor whiteColor];
        self.strokeColor = [EVColor newsfeedStripeColor];
        self.position = EVGroupedTableViewCellPositionSingle;
        
        if ([EVUtilities userHasIOS7])
            self.clipsToBounds = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if ([EVUtilities userHasIOS7])
        rect = CGRectIntegral(VISIBLE_FRAME);
    UIBezierPath *path = [UIBezierPath bezierPath];

    if (self.position == EVGroupedTableViewCellPositionTop)
    {
        
        /*
         This one looks like this:
         
         /----------\
         |          |
         ------------
         
         */
        
        [path moveToPoint:CGPointMake(rect.origin.x, CGRectGetMaxY(rect))];
        [path addLineToPoint:CGPointMake(rect.origin.x, CORNER_RADIUS)];
        [path addArcWithCenter:CGPointMake(rect.origin.x + CORNER_RADIUS, rect.origin.y + CORNER_RADIUS)
                        radius:CORNER_RADIUS
                    startAngle:M_PI
                      endAngle:3*M_PI / 2.0
                     clockwise:YES];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect) - CORNER_RADIUS, rect.origin.y)];
        [path addArcWithCenter:CGPointMake(CGRectGetMaxX(rect) - CORNER_RADIUS, rect.origin.y + CORNER_RADIUS)
                        radius:CORNER_RADIUS
                    startAngle:3*M_PI / 2.0
                      endAngle:0
                     clockwise:YES];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
        [path addLineToPoint:CGPointMake(rect.origin.x, CGRectGetMaxY(rect))];

    }
    else if (self.position == EVGroupedTableViewCellPositionCenter) 
    {
        /*
         
         This one looks like this: 

         |          |
         ------------
         
         */

        
        [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y)];
        [path addLineToPoint:CGPointMake(rect.origin.x, CGRectGetMaxY(rect))];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), rect.origin.y)];
    }
    else if (self.position == EVGroupedTableViewCellPositionBottom)
    {
        
        /*
         
         And this one looks like this:
         
         |          |
         \----------/
         
         */
        [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y)];
        [path addLineToPoint:CGPointMake(rect.origin.x, CGRectGetMaxY(rect) - CORNER_RADIUS)];
        [path addArcWithCenter:CGPointMake(rect.origin.x + CORNER_RADIUS, CGRectGetMaxY(rect) - CORNER_RADIUS)
                        radius:CORNER_RADIUS
                    startAngle:M_PI
                      endAngle:M_PI / 2.0
                     clockwise:NO];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect) - CORNER_RADIUS, CGRectGetMaxY(rect))];
        [path addArcWithCenter:CGPointMake(CGRectGetMaxX(rect) - CORNER_RADIUS, CGRectGetMaxY(rect) - CORNER_RADIUS)
                        radius:CORNER_RADIUS
                    startAngle:M_PI / 2.0
                      endAngle:0
                     clockwise:NO];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), rect.origin.y)];

    }
    else if (self.position == EVGroupedTableViewCellPositionSingle)
    {
        /*
         If there's only one cell, just do a simple rounded rect.
         */        
        path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:CORNER_RADIUS];
    }
    
    float lineWidth = [self isMainBackgroundView] ? 1.0 : 2.0;

    [path setLineCapStyle:kCGLineCapRound];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineWidth:lineWidth];
    [path addClip]; // very important!  Keeps the rounded corners from looking all overflowed and shitty
    [self.fillColor setFill];
    [self.strokeColor setStroke];
    [path fill];
    [path stroke];
}

- (BOOL)isMainBackgroundView {
    return [self.fillColor isEqual:[UIColor whiteColor]];
}

@end
