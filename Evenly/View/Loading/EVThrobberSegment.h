//
//  EVThrobberSegment.h
//  Evenly
//
//  Created by Joseph Hankin on 8/5/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVThrobberSegment : UIView

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *highlightedColor;

@property (nonatomic) NSTimeInterval animationDuration;

- (void)startAnimating;
- (void)stopAnimating;

@end
