//
//  EVPrivacySelectorView.m
//  Evenly
//
//  Created by Justin Brunet on 6/12/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPrivacySelectorView.h"
#import "EVPrivacySelectorLine.h"
#import "EVPrivacySelectorHeader.h"
#import "EVPrivacySelectorOption.h"
#import "EVUser.h"

#define LINE_HEIGHT 40.0
#define NUM_LINES 1
#define DIVIDER_HUE 230

@interface EVPrivacySelectorView ()

- (void)loadCells;
- (void)loadDividers;

- (CGRect)frameForDividerIndex:(int)index;
- (CGRect)frameForCellIndex:(int)index;

@end

@implementation EVPrivacySelectorView

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self loadCells];
        [self loadDividers];
    }
    return self;
}

#pragma mark - View Loading

- (void)loadCells
{
    for (int i = 0; i < [[self class] numberOfLines]; i++) {
        EVPrivacySelectorLine *line;
        
        if (i == 0)
            line = [[EVPrivacySelectorHeader alloc] initWithFrame:[self frameForCellIndex:i] andSetting:[EVCIA me].privacySetting];
        else
            line = [[EVPrivacySelectorOption alloc] initWithFrame:[self frameForCellIndex:i] andSetting:i-1];
        
        [self addSubview:line];
    }
}

- (void)loadDividers
{
    for (int i = 0; i < [[self class] numberOfLines]+1; i++) {
        UIView *divider = [[UIView alloc] initWithFrame:[self frameForDividerIndex:i]];
        divider.backgroundColor = EV_RGB_COLOR(DIVIDER_HUE, DIVIDER_HUE, DIVIDER_HUE);
        [self addSubview:divider];
    }
}

#pragma mark - View Defines

+ (float)lineHeight {
    return LINE_HEIGHT;
}

+ (int)numberOfLines {
    return NUM_LINES;
}

- (CGRect)frameForDividerIndex:(int)index {
    return CGRectMake(0,
                      [[self class] lineHeight] * index,
                      self.bounds.size.width,
                      1);
}

- (CGRect)frameForCellIndex:(int)index {
    return CGRectMake(0,
                      [[self class] lineHeight] * index,
                      self.bounds.size.width,
                      [[self class] lineHeight]);
}

@end
