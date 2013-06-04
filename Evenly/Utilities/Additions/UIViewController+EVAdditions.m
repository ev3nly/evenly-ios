//
//  UIViewController+EVAdditions.m
//  Evenly
//
//  Created by Joseph Hankin on 6/4/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "UIViewController+EVAdditions.h"

@implementation UIViewController (EVAdditions)

- (JASidePanelController *)sidePanelController {
    UIResponder *responder = self;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[JASidePanelController class]]) {
            return (JASidePanelController *)responder;
        }
    }
    return nil;
}

@end
