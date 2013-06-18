//
//  EVPageView.m
//  TCTouch
//
//  Created by Joseph Hankin on 1/27/12.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPageView.h"

@implementation EVPageView

@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize pageNumber = _pageNumber;
@synthesize indexPath = _indexPath;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height)];
    if (self) {
        self.reuseIdentifier = reuseIdentifier;
        self.autoresizesSubviews = YES;
        self.autoresizingMask = EV_AUTORESIZE_TO_FIT;
    }
    return self;
}

- (void)prepareForReuse {
    // abstract
}

- (void)pageDidAppear { 
    // abstract
}

- (void)pageWillDisappear {
    // abstract
}

- (NSString *)description {
    return [[super description] stringByAppendingFormat:@"Reuse Identifier: %@ page: %d", self.reuseIdentifier, self.pageNumber];
}

@end
