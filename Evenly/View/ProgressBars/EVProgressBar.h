//
//  EVGroupRequestProgressBar.h
//  Evenly
//
//  Created by Joseph Hankin on 6/23/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVProgressBar : UIView

@property (nonatomic) BOOL enabled;
@property (nonatomic) float progress;

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
