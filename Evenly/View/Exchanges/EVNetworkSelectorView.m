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
- (void)loadCells;

- (CGRect)frameForDividerIndex:(int)index;
- (CGRect)frameForCellIndex:(int)index;

@end

@implementation EVNetworkSelectorView

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        [self loadDividers];
        [self loadCells];
    }
    return self;
}

#pragma mark - View Loading

- (void)loadDividers
{
    for (int i = 0; i < NUM_LINES+1; i++) {
        UIView *divider = [[UIView alloc] initWithFrame:[self frameForDividerIndex:i]];
        divider.backgroundColor = EV_RGB_COLOR(DIVIDER_HUE, DIVIDER_HUE, DIVIDER_HUE);
        [self addSubview:divider];
    }
}

- (void)loadCells
{
    for (int i = 0; i < NUM_LINES; i++) {
        EVNetworkSelectorCell *cell = [[EVNetworkSelectorCell alloc] initWithFrame:[self frameForCellIndex:i]
                                                                           andType:i];
        [self addSubview:cell];
    }
}

#pragma mark - Frame Defines

- (CGRect)frameForDividerIndex:(int)index {
    return CGRectMake(0,
                      LINE_HEIGHT * index,
                      self.bounds.size.width,
                      1);
}

- (CGRect)frameForCellIndex:(int)index {
    return CGRectMake(0,
                      LINE_HEIGHT * index,
                      self.bounds.size.width,
                      LINE_HEIGHT);
}

@end
