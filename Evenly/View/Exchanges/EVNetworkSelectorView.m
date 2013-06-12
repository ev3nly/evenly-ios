//
//  EVNetworkSelectorView.m
//  Evenly
//
//  Created by Justin Brunet on 6/12/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVNetworkSelectorView.h"
#import "EVNetworkSelectorCell.h"

#define LINE_HEIGHT 40
#define NUM_LINES 4
#define DIVIDER_HUE 230

@interface EVNetworkSelectorView ()

- (void)loadDividers;
- (CGRect)frameForDividerIndex:(int)index;

@end

@implementation EVNetworkSelectorView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        [self loadDividers];
    }
    return self;
}

- (void)loadDividers
{
    for (int i = 0; i < NUM_LINES+1; i++) {
        UIView *divider = [[UIView alloc] initWithFrame:[self frameForDividerIndex:i]];
        divider.backgroundColor = EV_RGB_COLOR(DIVIDER_HUE, DIVIDER_HUE, DIVIDER_HUE);
        [self addSubview:divider];
    }
}

- (CGRect)frameForDividerIndex:(int)index {
    return CGRectMake(0,
                      LINE_HEIGHT * index,
                      self.bounds.size.width,
                      1);
}

@end
