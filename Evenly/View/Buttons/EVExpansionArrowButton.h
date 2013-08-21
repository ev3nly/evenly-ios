//
//  EVExpansionArrowButton.h
//  Evenly
//
//  Created by Joseph Hankin on 7/12/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVExpansionArrowButton : UIButton

@property (nonatomic) BOOL expanded;

- (void)setExpanded:(BOOL)expanded animated:(BOOL)animated;

@end
