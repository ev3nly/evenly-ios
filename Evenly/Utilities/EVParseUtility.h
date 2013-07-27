//
//  EVParseUtility.h
//  Evenly
//
//  Created by Joseph Hankin on 7/26/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVParseUtility : NSObject

+ (void)registerChannels;
+ (void)registerChannelsWithDeviceTokenData:(NSData *)deviceToken;
+ (void)unregisterChannels;

@end
