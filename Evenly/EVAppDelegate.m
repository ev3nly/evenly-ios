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
#import "EVPayment.h"
#import "EVCIA.h"
#import "EVSettingsManager.h"
#import "EVHTTPClient.h"
#import "EVAppErrorHandler.h"
#import "EVKeyboardTracker.h"
#import "EVPushManager.h"
#import "EVPINUtility.h"
#import "EVSettingsManager.h"

#import "EVSignInViewController.h"
#import "EVSetPINViewController.h"

#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "ABContactsHelper.h"
#import "EVFacebookManager.h"

#define EV_APP_GRACE_PERIOD_FOR_PIN_REENTRY 60

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

    // STRICTLY TEMPORARY
    if (![[EVCIA sharedInstance] session])
    {
        [self.masterViewController showOnboardingControllerWithCompletion:nil animated:NO];
    }
    else
    {
        [EVSession setSharedSession:[[EVCIA sharedInstance] session]];
        [[NSNotificationCenter defaultCenter] postNotificationName:EVSessionSignedInNotification object:nil];
    }
    
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
        [self handleRemoteNotification:[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] requirePIN:YES];
    }
    
    [self showPINIfSet];
    
    return YES;
}

- (void)registerWithServices {
    [Crashlytics startWithAPIKey:@"57feb0d7e994889c02aae5608c93b9891426fff9"];
    [NewRelicAgent startWithApplicationToken:@"AA4424ba31b14b47817d4f97239eb1accee8d301fc"];
    [Parse setApplicationId:@"O1LVB8cEUNOYvAjjWjKSKzgx3CkEt4jDykr5H8ah"
                  clientKey:@"IylwifyGsv729Cg6HuiIsHkQBUvdrLttQIQTPlFV"];
    
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
    [EVSession setSharedSession:[[EVCIA sharedInstance] session]];
    
    if ([[EVCIA sharedInstance] session]) {
        [EVFacebookManager quietlyOpenSessionWithCompletion:NULL];
    }
    [EVCIA reloadMe];
    
    [[EVKeyboardTracker sharedTracker] registerForNotifications];
    
    // Load user's settings from server.
    [[EVSettingsManager sharedManager] loadSettingsFromServer];
    
}

- (void)setUpAppearance {
    if ([EVUtilities userHasIOS7]) {
        self.window.tintColor = [EVColor blueColor];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        UIImage *clearImage = [EVImageUtility imageWithColor:[UIColor clearColor]];
        [[UINavigationBar appearance] setBackgroundImage:clearImage forBarMetrics:UIBarMetricsDefault];
    }
    else {
        UIImage *blueImage = [EVImageUtility imageWithColor:[EVColor blueColor]];
        [[UINavigationBar appearance] setBackgroundImage:blueImage forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
    
    [[UIBarButtonItem appearance] setBackgroundImage:[EVImages barButtonItemBackground] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:[EVImages barButtonItemBackgroundPress] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    if ([EVSession sharedSession].authenticationToken) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date]
                                                  forKey:EVDateAppEnteredBackgroundKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self showPINIfSet];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if ([[EVCIA sharedInstance] session]) {
        [EVFacebookManager quietlyOpenSessionWithCompletion:NULL];
    }
    [EVCIA reloadMe];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSession.activeSession handleDidBecomeActive];
    [EVAnalyticsUtility trackEvent:EVAnalyticsOpenedApp];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:EVShouldRegisterForPushAtStartup] == YES)
        [EVUtilities registerForPushNotifications];

    EV_DISPATCH_AFTER(0.5, ^{
        if ([[EVCIA sharedInstance] session]) {
            if ([self userHasNotSeenPINAlert])
                [self showPINAlert];
        }
    });
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [FBSession.activeSession handleOpenURL:url];
}

#pragma mark - Push Notifications

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    DLog(@"Did register for remote notifications");
    [EVParseUtility registerChannelsWithDeviceTokenData:deviceToken];
    if (deviceToken)
    {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel.people addPushDeviceToken:deviceToken];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:EVApplicationDidRegisterForPushesNotification
                                                        object:nil
                                                      userInfo:@{ @"deviceToken" : deviceToken }];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:EVShouldRegisterForPushAtStartup];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self handleRemoteNotification:userInfo requirePIN:NO];
    [EVCIA reloadMe];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DLog(@"Registering for push failed: %@", error);
}

- (void)handleRemoteNotification:(NSDictionary *)userInfo requirePIN:(BOOL)requirePIN {
    DLog(@"Remote notification: %@", userInfo);
    [PFPush handlePush:userInfo];
    
    EVObject *object = [[EVPushManager sharedManager] objectFromPushDictionary:userInfo[@"meta"]];
    if ([object isKindOfClass:[EVPayment class]])
    {
        [EVCIA reloadMe];
        [[NSNotificationCenter defaultCenter] postNotificationName:EVReceivedPushAboutNewPaymentNotification object:nil];
    }
    
    EVViewController *viewController = [[EVPushManager sharedManager] viewControllerFromPushDictionary:userInfo[@"meta"]];
    if (viewController)
    {
        EVNavigationController *pushNavController = [[EVNavigationController alloc] initWithRootViewController:viewController];
        
        void (^completionBlock)(void) = nil;
        if (requirePIN && [[EVPINUtility sharedUtility] pinIsSet]) {
            EVEnterPINViewController *pinViewController = [[EVEnterPINViewController alloc] init];
            pinViewController.canDismissManually = NO;
            EVNavigationController *navController = [[EVNavigationController alloc] initWithRootViewController:pinViewController];
            completionBlock = ^{
                [pushNavController presentViewController:navController animated:NO completion:nil];
            };
        }
        
        [self.masterViewController presentViewController:pushNavController animated:YES completion:completionBlock];
    }
}

#pragma mark - PIN Setting

- (void)showPINIfSet {
    if ([EVSession sharedSession].authenticationToken) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date]
                                                  forKey:EVDateAppEnteredBackgroundKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([[EVPINUtility sharedUtility] pinIsSet])
            [[self masterViewController] showPINViewControllerAnimated:NO];
    }
}

- (BOOL)userHasNotSeenPINAlert {
    return ([[NSUserDefaults standardUserDefaults] boolForKey:EVHasSeenPINAlertKey] != YES);
}

- (void)showPINAlert {
    NSDate *dateAppEnteredBackground = [[NSUserDefaults standardUserDefaults] objectForKey:EVDateAppEnteredBackgroundKey];
    if (dateAppEnteredBackground && ![[EVPINUtility sharedUtility] pinIsSet]) {
        [[UIAlertView alertViewWithTitle:nil
                                 message:[EVStringUtility wouldYouLikeToSetPINPrompt]
                       cancelButtonTitle:@"Not now" otherButtonTitles:@[@"Yes"]
                               onDismiss:^(int buttonIndex) {
                                   [self showSetPINController];
                               } onCancel:nil] show];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:EVHasSeenPINAlertKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)showSetPINController {
    EVNavigationController *navController = [[EVNavigationController alloc] initWithRootViewController:[EVSetPINViewController new]];
    [self.masterViewController presentViewController:navController animated:YES completion:nil];
}

@end
