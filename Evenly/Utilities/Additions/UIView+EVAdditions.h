//
//  UIView+EVAdditions.h
//  TCTouch
//
//  Created by Joe Hankin on 3/27/12.
//  Copyright (c) 2012 Blackboard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EVAdditions)
/** Convenience method to set a view's origin. */
- (void)setOrigin:(CGPoint)inOrigin;
/** Convenience method to set a view's size. */
- (void)setSize:(CGSize)inSize;
/** Removes all a view's subviews.  Be careful when using on UIScrollViews, as it will also remove the scroll indicators. */
- (void)removeAllSubviews;
/** Casts origin and size values to integers to prevent blurring.  Useful when setting center value or calling sizeToFit. */
- (void)align;
/** Convenience method to bring a view to the front of its hierarchy. */
- (void)comeToFront;

/** The view controller whose view contains this view. */
- (UIViewController *)viewController DEPRECATED_ATTRIBUTE;

- (void)logSuperviews;

- (BOOL)findAndResignFirstResponder;

@end