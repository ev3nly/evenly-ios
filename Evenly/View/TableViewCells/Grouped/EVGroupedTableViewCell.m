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
        
        EVGroupedTableViewCellBackground *background = [[EVGroupedTableViewCellBackground alloc] initWithFrame:VISIBLE_FRAME];
        background.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        background.fillColor = [UIColor whiteColor];
        self.backgroundView = background;
        
        EVGroupedTableViewCellBackground *selectedBackground = [[EVGroupedTableViewCellBackground alloc] initWithFrame:VISIBLE_FRAME];
        selectedBackground.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        selectedBackground.fillColor = [EVColor newsfeedButtonHighlightColor];
        self.selectedBackgroundView = selectedBackground;
    }
    return self;
}

- (void)setPosition:(EVGroupedTableViewCellPosition)position {
    _position = position;
    [(EVGroupedTableViewCellBackground *)self.backgroundView setPosition:_position];
    [(EVGroupedTableViewCellBackground *)self.selectedBackgroundView setPosition:_position];
    [self.backgroundView setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGRect)visibleFrame {
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
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
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
