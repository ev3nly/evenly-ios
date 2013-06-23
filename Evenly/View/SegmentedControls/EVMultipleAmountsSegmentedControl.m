//
//  EVMultipleAmountsSegmentedControl.m
//  Evenly
//
//  Created by Joseph Hankin on 6/23/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVMultipleAmountsSegmentedControl.h"

#define EV_SEGMENTED_CONTROL_HEIGHT 44.0
#define EV_SEGMENTED_CONTROL_WIDTH 320.0

@implementation EVMultipleAmountsSegmentedControl

- (UIFont *)font {
    return [EVFont blackFontOfSize:15];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x,
                                           frame.origin.y,
                                           EV_SEGMENTED_CONTROL_WIDTH,
                                           EV_SEGMENTED_CONTROL_HEIGHT)];
    if (self) {
        self.backgroundColor = [EVColor creamColor];
        UIView *topStripe = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     self.frame.size.width,
                                                                     1)];
        [topStripe setBackgroundColor:[EVColor newsfeedStripeColor]];
        [self addSubview:topStripe];
        
        UIView *bottomStripe = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                        self.frame.size.height - 1,
                                                                        self.frame.size.width,
                                                                        1)];
        [bottomStripe setBackgroundColor:[EVColor newsfeedStripeColor]];
        [self addSubview:bottomStripe];
    }
    return self;
}

- (void)reloadSubviews {
    [self.buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.buttons removeAllObjects];
    
    CGSize buttonSize = CGSizeMake(self.frame.size.width / [self numberOfSegments], EV_SEGMENTED_CONTROL_HEIGHT);
    CGPoint origin = CGPointZero;
    int i = 0;
    for (NSString *string in self.items) {
        UIButton *button = [[UIButton alloc] initWithFrame:(CGRect){origin, buttonSize}];
        [button.titleLabel setFont:[self font]];
        [button setTitleColor:[EVColor lightLabelColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted | UIControlStateSelected];
        
        
        [button setTitle:string forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        origin.x += buttonSize.width;
        [button setSelected:(i == self.selectedSegmentIndex)];
        i++;
        [self addSubview:button];
        [self.buttons addObject:button];
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
