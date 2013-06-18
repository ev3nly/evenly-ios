//
//  EVGroupTableViewCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupTableViewCell.h"

@implementation EVGroupTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        EVGroupTableViewCellBackground *background = [[EVGroupTableViewCellBackground alloc] initWithFrame:self.bounds];
        background.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        self.backgroundView = background;
        
        EVGroupTableViewCellBackground *selectedBackground = [[EVGroupTableViewCellBackground alloc] initWithFrame:self.bounds];
        selectedBackground.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        selectedBackground.fillColor = [EVColor newsfeedButtonHighlightColor];
        self.selectedBackgroundView = selectedBackground;
    }
    return self;
}

- (void)setPosition:(EVGroupTableViewCellPosition)position {
    _position = position;
    [(EVGroupTableViewCellBackground *)self.backgroundView setPosition:_position];
    [(EVGroupTableViewCellBackground *)self.selectedBackgroundView setPosition:_position];
    [self.backgroundView setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

#define CORNER_RADIUS 2.0

@implementation EVGroupTableViewCellBackground

- (id)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.fillColor = [UIColor whiteColor];
        self.strokeColor = [EVColor newsfeedStripeColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];

    if (self.position == EVGroupTableViewCellPositionTop)
    {
        
        /*
         This one looks like this:
         
         /----------\
         |          |
         ------------
         
         */
        
        [path moveToPoint:CGPointMake(rect.origin.x, CGRectGetMaxY(rect))];
        [path addLineToPoint:CGPointMake(rect.origin.x, CORNER_RADIUS)];
        [path addArcWithCenter:CGPointMake(CORNER_RADIUS, CORNER_RADIUS)
                        radius:CORNER_RADIUS
                    startAngle:M_PI
                      endAngle:3*M_PI / 2.0
                     clockwise:YES];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect) - CORNER_RADIUS, rect.origin.y)];
        [path addArcWithCenter:CGPointMake(CGRectGetMaxX(rect) - CORNER_RADIUS, CORNER_RADIUS)
                        radius:CORNER_RADIUS
                    startAngle:3*M_PI / 2.0
                      endAngle:0
                     clockwise:YES];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
        [path addLineToPoint:CGPointMake(rect.origin.x, CGRectGetMaxY(rect))];

    }
    else if (self.position == EVGroupTableViewCellPositionCenter) 
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
    else if (self.position == EVGroupTableViewCellPositionBottom)
    {
        
        /*
         
         And this one looks like this:
         
         |          |
         \----------/
         
         */
        [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y)];
        [path addLineToPoint:CGPointMake(rect.origin.x, CGRectGetMaxY(rect) - CORNER_RADIUS)];
        [path addArcWithCenter:CGPointMake(CORNER_RADIUS, CGRectGetMaxY(rect) - CORNER_RADIUS)
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
    else if (self.position == EVGroupTableViewCellPositionSingle)
    {
        /*
         If there's only one cell, just do a simple rounded rect.
         */        
        path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:CORNER_RADIUS];
    }

    [path setLineCapStyle:kCGLineCapRound];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineWidth:2.0];
    [path addClip]; // very important!  Keeps the rounded corners from looking all overflowed and shitty
    [self.fillColor setFill];
    [self.strokeColor setStroke];
    [path fill];
    [path stroke];
}

@end
