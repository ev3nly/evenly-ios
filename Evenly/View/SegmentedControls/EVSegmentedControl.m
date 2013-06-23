//
//  EVSegmentedControl.m
//  Evenly
//
//  Created by Joseph Hankin on 6/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVSegmentedControl.h"

@interface EVSegmentedControl ()

@end

@implementation EVSegmentedControl

- (id)initWithItems:(NSArray *)items {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.items = [NSMutableArray arrayWithArray:items];
        [self reloadSubviews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.buttons = [NSMutableArray array];
    }
    return self;
}

- (NSUInteger)numberOfSegments {
    return self.items.count;
}

- (void)buttonPress:(UIButton *)button {
    NSUInteger index = [self.buttons indexOfObject:button];
    if (index == self.selectedSegmentIndex)
        return;
    
    UIButton *previousButton = [self.buttons objectAtIndex:self.selectedSegmentIndex];
    [previousButton setSelected:NO];
    [button setSelected:YES];
    self.selectedSegmentIndex = index;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)reloadSubviews {
    // abstract
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
