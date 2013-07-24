//
//  EVNetworkManager.m
//  Evenly
//
//  Created by Joseph Hankin on 3/30/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVNetworkManager.h"
#import "AFNetworking.h"
#import "EVUser.h"

static EVNetworkManager *_instance;

@implementation EVNetworkManager {
    EVHTTPClient *_httpClient;
    NSOperationQueue *_operationQueue;
    int _activityIndicatorCounter;
}

+ (EVNetworkManager *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[EVNetworkManager alloc] init];
    });
    return _instance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self reloadHTTPClient];
        _operationQueue = [[NSOperationQueue alloc] init];
        _activityIndicatorCounter = 0;
    }
    return self;
}

- (void)reloadHTTPClient {
    _httpClient = nil;
    _httpClient = [[EVHTTPClient alloc] initWithBaseURL:[self urlForServerSelection:[self serverSelection]]];
    [_httpClient registerHTTPOperationClass:[EVJSONRequestOperation class]];
}

- (BOOL)enqueueRequest:(NSOperation *)request {
    
    // TODO: I'm pretty sure this doesn't actually work, this is just noting the concept.  Make sure this works.
    
    if ([[_operationQueue operations] containsObject:request])
        return NO;
    [_operationQueue addOperation:request];
//    [self increaseActivityIndicatorCounter];
    return YES;
}

- (void)increaseActivityIndicatorCounter {
    @synchronized (self) {
        _activityIndicatorCounter++;
        if (_activityIndicatorCounter == 1)
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

- (void)decreaseActivityIndicatorCounter {
    @synchronized (self) {
        _activityIndicatorCounter--;
        if (_activityIndicatorCounter == 0)
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (void)setServerSelection:(EVServerSelection)serverSelection {
    [[NSUserDefaults standardUserDefaults] setInteger:serverSelection forKey:@"serverSelection"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (EVServerSelection)serverSelection {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"serverSelection"];
}


- (NSURL *)urlForServerSelection:(EVServerSelection)serverSelection {
#ifdef DEBUG
    NSURL *url = nil;
    switch (serverSelection) {
        case EVServerSelectionProduction:
            url = [NSURL URLWithString:EV_API_PRODUCTION_URL];
            break;
        case EVServerSelectionStaging:
            url = [NSURL URLWithString:EV_API_STAGING_URL];
            break;
        case EVServerSelectionLocal:
            url = [NSURL URLWithString:EV_API_LOCAL_URL];
            break;
        default:
            break;
    }
    return url;
#else
    return [NSURL URLWithString:EV_API_PRODUCTION_URL];
#endif
}


@end
