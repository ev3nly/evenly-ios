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
#import "EVMasterViewController.h"
#import "EVMainMenuViewController.h"
#import "EVHomeViewController.h"
#import "EVWalletViewController.h"
#import "EVSession.h"
#import "EVCIA.h"
#import "EVSettingsManager.h"
#import "EVHTTPClient.h"
#import "EVAppErrorHandler.h"
#import "EVKeyboardTracker.h"
#import "EVPINUtility.h"

#import "EVSignInViewController.h"

#import <FacebookSDK/FacebookSDK.h>

@implementation EVAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self registerWithServices];
    [self configure];
    [self setUpAppearance];
    
    self.masterViewController = [[EVNavigationManager sharedManager] masterViewController];
    self.masterViewController.leftPanel = [[EVNavigationManager sharedManager] mainMenuViewController];
    self.masterViewController.centerPanel = [[EVNavigationManager sharedManager] homeViewController];
    self.masterViewController.rightPanel = [[EVNavigationManager sharedManager] walletViewController];
    
    self.window.rootViewController = self.masterViewController;
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    NSArray *array = [UIFont fontNamesForFamilyName:@"Avenir"];
    DLog(@"Avenir variants: %@", array);
    
    // STRICTLY TEMPORARY
    if (![[EVCIA sharedInstance] session])
    {
        [self.masterViewController showOnboardingController];
//        [self.masterViewController showLoginViewControllerWithCompletion:NULL];
    }
    else
    {
        [EVSession setSharedSession:[[EVCIA sharedInstance] session]];
        [[NSNotificationCenter defaultCenter] postNotificationName:EVSessionSignedInNotification object:nil];
    }
    
    self.masterViewController.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
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
    [EVUser setMe:[[EVCIA sharedInstance] me]];
    [EVSession setSharedSession:[[EVCIA sharedInstance] session]];
    
    [EVCIA reloadMe];
    
    [[EVKeyboardTracker sharedTracker] registerForNotifications];
    
    // Load user's settings from server.
    [[EVSettingsManager sharedManager] loadSettingsFromServer];
}

- (void)setUpAppearance {
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"Header"] forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:[EVImages barButtonItemBackground] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:[EVImages barButtonItemBackgroundPress] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
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
    
//    if ([[EVPINUtility sharedUtility] pinIsSet])
//        [[self masterViewController] showPINViewControllerAnimated:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [EVCIA reloadMe];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [FBSession.activeSession handleOpenURL:url];
}

@end
