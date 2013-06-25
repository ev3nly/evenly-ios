//
//  EVGroupRequestSegmentedControl.m
//  Evenly
//
//  Created by Joseph Hankin on 6/23/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVDashboardSegmentedControl.h"

#define DASHBOARD_SEGMENTED_CONTROL_HEIGHT 40.0
#define DASHBOARD_SEGMENTED_CONTROL_WIDTH 298.0

@interface EVDashboardSegmentedControlButton : UIButton

@end

@implementation EVDashboardSegmentedControlButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *stripe = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 1, 0, 1, self.frame.size.height)];
        [stripe setBackgroundColor:[EVColor newsfeedStripeColor]];
        [stripe setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight];
        [self addSubview:stripe];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setBackgroundColor:(selected ? [UIColor whiteColor] : [UIColor clearColor])];
}

//- (void)setHighlighted:(BOOL)highlighted {
//    [super setHighlighted:highlighted];
//    [self setBackgroundColor:(highlighted ? [UIColor whiteColor] : [UIColor clearColor])];
//}

@end

@interface EVDashboardSegmentedControl ()

@end

@implementation EVDashboardSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x,
                                           frame.origin.y,
                                           DASHBOARD_SEGMENTED_CONTROL_WIDTH,
                                           DASHBOARD_SEGMENTED_CONTROL_HEIGHT)];
    if (self) {
        self.autoresizesSubviews = YES;
        self.backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.backgroundView.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        self.backgroundView.image = [UIImage imageNamed:@"tab-inactive-background"];
        self.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        self.backgroundView.clipsToBounds = YES;
        self.clipsToBounds = YES;
        [self addSubview:self.backgroundView];
        
        UIView *stripe = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
        [stripe setBackgroundColor:[EVColor newsfeedStripeColor]];
        [stripe setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [self addSubview:stripe];
    }
    return self;
}

- (void)reloadSubviews {
    [self.buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.buttons removeAllObjects];
    CGSize buttonSize = CGSizeMake(ceilf(self.frame.size.width / [self numberOfSegments]), DASHBOARD_SEGMENTED_CONTROL_HEIGHT-1);
    CGPoint origin = CGPointZero;
    int i = 0;
    for (NSString *string in self.items) {
        
        // JH: There's something weird happening in the measurements here,
        // so on the off chance you need to touch this, don't fuck it up.
        if (i == [self.items count] - 1)
            buttonSize.width += 1;
        
        UIButton *button = [[EVDashboardSegmentedControlButton alloc] initWithFrame:(CGRect){origin, buttonSize}];
        [self configureButton:button];
        [button setTitle:string forState:UIControlStateNormal];
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
