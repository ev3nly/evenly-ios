//
//  EVNetworkManager.h
//  Evenly
//
//  Created by Joseph Hankin on 3/30/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVHTTPClient.h"

@interface EVNetworkManager : NSObject

+ (EVNetworkManager *)sharedInstance;
@property (nonatomic, readonly) EVHTTPClient *httpClient;
@property (nonatomic) EVServerSelection serverSelection;

- (NSURL *)urlForServerSelection:(EVServerSelection)serverSelection;
- (NSString *)balancedURLStringForServerSelection:(EVServerSelection)serverSelection;

/* For debugging purposes, to switch between dev and prod */
- (void)reloadHTTPClient;

- (BOOL)enqueueRequest:(NSOperation *)request;

- (void)increaseActivityIndicatorCounter;
- (void)decreaseActivityIndicatorCounter;

@end
