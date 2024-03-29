//
//  EVFormView.m
//  Evenly
//
//  Created by Joseph Hankin on 6/13/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVFormView.h"

#define EV_FORM_VIEW_STRIPE_THICKNESS 1.0
#define SIDE_MARGIN ([EVUtilities userHasIOS7] ? 10 : 0)

@interface EVFormView ()

@property (nonatomic, strong) EVGroupedTableViewCellBackground *background;
@property (nonatomic, strong) NSMutableArray *stripes;

@end

@implementation EVFormView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.background = [[EVGroupedTableViewCellBackground alloc] initWithFrame:self.bounds];
        self.background.autoresizingMask = EV_AUTORESIZE_TO_FIT;;
        self.autoresizesSubviews = YES;
        [self addSubview:self.background];
        
        self.stripes = [NSMutableArray array];
    }
    return self;
}

- (void)setFormRows:(NSArray *)formRows {
    [_formRows makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.stripes makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.stripes removeAllObjects];
    _formRows = formRows;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    CGFloat totalHeight = 0.0;
    for (UIView *view in _formRows) {
        totalHeight += view.frame.size.height;
    }
    NSInteger stripeCount = [_formRows count] + 1;
    totalHeight += stripeCount * EV_FORM_VIEW_STRIPE_THICKNESS;
    [self setSize:CGSizeMake(self.frame.size.width, totalHeight)];
    
    CGPoint origin = CGPointMake(SIDE_MARGIN, 1);
    for (UIView *view in _formRows) {
        [view setOrigin:origin];
        [self addSubview:view];
        origin.y += view.frame.size.height;
        if (view != [_formRows lastObject])
        {
            UIView *stripe = [self stripeAtPoint:origin];
            [self addSubview:stripe];
            [self.stripes addObject:stripe];
            origin.y += stripe.frame.size.height;
        }
    }
}

- (UIView *)stripeAtPoint:(CGPoint)point {
    UIView *stripe = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, self.frame.size.width - 2*point.x, [EVUtilities scaledDividerHeight])];
    stripe.backgroundColor = [EVColor newsfeedStripeColor];
    return stripe;
}

@end
