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
        _httpClient = [[EVHTTPClient alloc] init];
        [_httpClient registerHTTPOperationClass:[EVJSONRequestOperation class]];
        _operationQueue = [[NSOperationQueue alloc] init];
        _activityIndicatorCounter = 0;
    }
    return self;
}

- (BOOL)enqueueRequest:(NSOperation *)request {
    
    // TODO: I'm pretty sure this doesn't actually work, this is just noting the concept.  Make sure this works.
    
    if ([[_operationQueue operations] containsObject:request])
        return NO;
    [_operationQueue addOperation:request];
    [self increaseActivityIndicatorCounter];
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

@end
