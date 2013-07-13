//
//  EVNavigationBarButton.h
//  Evenly
//
//  Created by Joseph Hankin on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVNavigationBarButton : UIButton

+ (instancetype)buttonWithTitle:(NSString *)title;
- (id)initWithTitle:(NSString *)title;
- (CGRect)frameForTitle:(NSString *)title;

@end
