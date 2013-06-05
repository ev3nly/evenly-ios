//
//  EVAppDelegate.h
//  Evenly
//
//  Created by Joseph Hankin on 5/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JASidePanelController;

@interface EVAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) JASidePanelController *masterViewController;

@end
