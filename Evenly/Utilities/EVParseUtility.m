//
//  EVParseUtility.m
//  Evenly
//
//  Created by Joseph Hankin on 7/26/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVParseUtility.h"
#import <Parse/Parse.h>

@implementation EVParseUtility


+ (NSString *)stringWithNamespace:(NSString *)namespace string:(NSString *)string {
    return [NSString stringWithFormat:@"%@_%@", namespace, string];
}


+ (void)registerChannels {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [self registerChannelsWithInstallation:currentInstallation];
    [currentInstallation saveInBackground];
}

+ (void)registerChannelsWithDeviceTokenData:(NSData *)deviceToken {

    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [self registerChannelsWithInstallation:currentInstallation];
    [currentInstallation saveInBackground];
}

+ (void)registerChannelsWithInstallation:(PFInstallation *)currentInstallation {
    NSString *namespace = @"VINE";
    if ([[EVNetworkManager sharedInstance] serverSelection] != EVServerSelectionProduction)
        namespace = @"GERM";
    [currentInstallation setObject:[self stringWithNamespace:namespace string:[[EVCIA me] dbid]]
                            forKey:@"user_id"];
    [currentInstallation addUniqueObject:[self stringWithNamespace:namespace string:@"all"]
                                  forKey:@"channels"];
#ifdef DEBUG
    [currentInstallation addUniqueObject:[self stringWithNamespace:namespace string:@"evenly"]
                                  forKey:@"channels"];
#endif
    NSString *channelName = [NSString stringWithFormat:@"user_%@", [[EVCIA me] dbid]];
    [currentInstallation addUniqueObject:[self stringWithNamespace:namespace string:channelName]
                                  forKey:@"channels"];
    
    for (NSString *role in [[EVCIA me] roles]) {
        [currentInstallation addUniqueObject:[self stringWithNamespace:namespace string:role]
                                      forKey:@"channels"];
    }
}

+ (void)unregisterChannels {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    NSArray *subscribedChannels = [NSArray arrayWithArray:[currentInstallation channels]];
    subscribedChannels = [subscribedChannels filter:^BOOL(id object) {
        return [(NSString *)object hasSuffix:@"all"];
    }];
    [currentInstallation setChannels:subscribedChannels];
    [currentInstallation saveInBackground];
}

@end
