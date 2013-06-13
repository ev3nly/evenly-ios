//
//  EVTextField.m
//  Evenly
//
//  Created by Joseph Hankin on 6/13/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVTextField.h"

@implementation EVTextField

- (void)drawPlaceholderInRect:(CGRect)rect {
    if (self.placeholderColor) {
        [self.placeholderColor set];
    }
    [super drawPlaceholderInRect:rect];
}

@end
