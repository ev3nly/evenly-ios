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
#import "EVSession.h"
#import "EVCache.h"

@implementation EVAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey:@"57feb0d7e994889c02aae5608c93b9891426fff9"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.masterViewController = [[EVNavigationManager sharedManager] masterViewController];
    self.masterViewController.leftPanel = [[EVMainMenuViewController alloc] init];
    self.masterViewController.centerPanel = [[EVNavigationManager sharedManager] homeViewController];
    self.masterViewController.rightPanel = [[EVWalletViewController alloc] init];
    
    self.window.rootViewController = self.masterViewController;
    self.window.backgroundColor = [UIColor cyanColor];
    [self.window makeKeyAndVisible];
    
    [EVSession createWithEmail:@"joe@paywithivy.com" password:@"haijoe" success:^{
        //retrieve user from session call, cache user
        EVUser *me = [[EVUser alloc] initWithDictionary:[EVSession sharedSession].originalDictionary[@"user"]];
        [EVUser setMe:me];
        [EVCache setUser:me];
        
        [EVUtilities registerForPushNotifications];
        
        //cache session
        [EVCache setSession:[EVSession sharedSession]];
    } failure:^(NSError *error) {
        DLog(@"Failure?! %@", error);
    }];
    
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
