//
//  EVThrobber.h
//  Evenly
//
//  Created by Joseph Hankin on 8/5/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    EVThrobberStyleLight,
    EVThrobberStyleDark
} EVThrobberStyle;

@interface EVThrobber : UIView

@property (nonatomic) NSInteger numberOfSegments;
@property (nonatomic) EVThrobberStyle style;
@property (nonatomic, readonly, getter = isAnimating) BOOL animating;
@property (nonatomic) BOOL hidesWhenStopped;

- (id)initWithThrobberStyle:(EVThrobberStyle)style;

- (void)startAnimating;
- (void)stopAnimating;

@end
