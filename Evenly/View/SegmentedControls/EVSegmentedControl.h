//
//  EVSegmentedControl.h
//  Evenly
//
//  Created by Joseph Hankin on 6/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVSegmentedControl : UIControl

@property(nonatomic,readonly) NSUInteger numberOfSegments;
@property(nonatomic) NSInteger selectedSegmentIndex;

- (id)initWithItems:(NSArray *)items;

@end
