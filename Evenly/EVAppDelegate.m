//
//  EVAppDelegate.m
//  Evenly
//
//  Created by Joseph Hankin on 5/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVAppDelegate.h"

#import <Crashlytics/Crashlytics.h>
#import <NewRelicAgent/NewRelicAgent.h>
#import "Mixpanel.h"

#import "JASidePanelController.h"
#import "EVNavigationManager.h"
#import "EVMainMenuViewController.h"
#import "EVHomeViewController.h"
#import "EVWalletViewController.h"
#import "EVSession.h"
#import "EVCache.h"
#import "EVSettingsManager.h"
#import "EVHTTPClient.h"
#import "EVAppErrorHandler.h"

@implementation EVAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [self registerWithServices];
    [self configure];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.masterViewController = [[EVNavigationManager sharedManager] masterViewController];
    self.masterViewController.leftPanel = [[EVMainMenuViewController alloc] init];
    self.masterViewController.centerPanel = [[EVNavigationManager sharedManager] homeViewController];
    self.masterViewController.rightPanel = [[EVWalletViewController alloc] init];
    
    self.window.rootViewController = self.masterViewController;
    self.window.backgroundColor = [UIColor cyanColor];
    [self.window makeKeyAndVisible];
    
    // STRICTLY TEMPORARY
    if (![EVSession sharedSession])
    {
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
    }
    
    return YES;
}

- (void)registerWithServices {
    [Crashlytics startWithAPIKey:@"57feb0d7e994889c02aae5608c93b9891426fff9"];
    [NewRelicAgent startWithApplicationToken:@"AA4424ba31b14b47817d4f97239eb1accee8d301fc"];
    //    [Parse setApplicationId:@"O1LVB8cEUNOYvAjjWjKSKzgx3CkEt4jDykr5H8ah"
    //                  clientKey:@"IylwifyGsv729Cg6HuiIsHkQBUvdrLttQIQTPlFV"];
    
#ifdef DEBUG //Germ
    [Mixpanel sharedInstanceWithToken:@"1d7eede1da7d22f6623a22c694f2a97f"];
#else //Vine
    [Mixpanel sharedInstanceWithToken:@"8025271500dfae2a28c360e58a7a9756"];
#endif
}

- (void)configure {
    // Set up HTTP client.
    [EVHTTPClient setErrorHandlerClass:[EVAppErrorHandler class]];
    
    // Load user and session from cache.
    [EVUser setMe:[EVCache user]];
    [EVSession setSharedSession:[EVCache session]];
    
    // Load user's settings from server.
    [[EVSettingsManager sharedManager] loadSettingsFromServer];
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
