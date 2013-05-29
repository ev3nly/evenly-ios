//
//  UITableView+EVAdditions.m
//  Evenly
//
//  Created by Justin Brunet on 4/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "UITableView+EVAdditions.h"

#define LOADING_INDICATOR_TAG 2947

@implementation UITableView (EVAdditions)

@dynamic isLoading;

- (void)setIsLoading:(BOOL)loading {    
    if (loading) {
        for (UIView *subview in self.subviews) {
            if (subview.tag == LOADING_INDICATOR_TAG)
                return;
        }
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.tag = LOADING_INDICATOR_TAG;
        indicator.frame = CGRectMake(CGRectGetMidX(self.bounds) - indicator.bounds.size.width/2,
                                     CGRectGetMidY(self.bounds) - indicator.bounds.size.height/2,
                                     indicator.bounds.size.width,
                                     indicator.bounds.size.height);
        indicator.autoresizingMask = EV_AUTORESIZE_TO_CENTER;
        [self addSubview:indicator];
        [indicator startAnimating];
    }
    else {
        for (UIView *subview in self.subviews) {
            if (subview.tag == LOADING_INDICATOR_TAG) {
                UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)subview;
                [indicator stopAnimating];
                [indicator removeFromSuperview];
            }
        }
    }
}

- (BOOL)isLoading {
    for (UIView *subview in self.subviews) {
        if (subview.tag == LOADING_INDICATOR_TAG) {
            return YES;
        }
    }
    return NO;
}

@end
