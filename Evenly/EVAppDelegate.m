//
//  EVAppDelegate.m
//  Evenly
//
//  Created by Joseph Hankin on 5/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVAppDelegate.h"
#import <Crashlytics/Crashlytics.h>
#import "JASidePanelController.h"
#import "EVNavigationManager.h"
#import "EVMainMenuViewController.h"
#import "EVHomeViewController.h"
#import "EVWalletViewController.h"

@implementation EVAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey:@"57feb0d7e994889c02aae5608c93b9891426fff9"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.sidePanelController = [[JASidePanelController alloc] init];
    self.sidePanelController.leftPanel = [[EVMainMenuViewController alloc] init];
    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[EVNavigationManager sharedManager] homeViewController]];
    self.sidePanelController.rightPanel = [[EVWalletViewController alloc] init];
    
    self.window.rootViewController = self.sidePanelController;
    self.window.backgroundColor = [UIColor cyanColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
