//
//  EVGroupRequestFormView.m
//  Evenly
//
//  Created by Joseph Hankin on 6/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestFormView.h"

@implementation EVGroupRequestFormView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGRect)amountFieldFrame { return CGRectZero; }
- (CGRect)forLabelFrame { return CGRectZero; }
- (CGRect)descriptionFieldFrame { return CGRectZero; }

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
