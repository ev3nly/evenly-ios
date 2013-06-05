//
//  EVCentralIntelligence.m
//  Evenly
//
//  Created by Joseph Hankin on 6/4/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVCIA.h"
#import "EVActivity.h"

static EVCIA *_sharedInstance;

@interface EVCIA ()

@property (nonatomic, strong) NSCache *internalCache;

@end

@implementation EVCIA

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[EVCIA alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.imageCache = [[NSCache alloc] init];
        self.internalCache = [[NSCache alloc] init];
        [self reloadAllWithCompletion:NULL];
    }
    return self;
}

- (void)reloadAllWithCompletion:(void (^)(void))completion {
    [EVActivity allWithSuccess:^(id result) {
        for (id key in [result allKeys]) {
            [self.internalCache setObject:[result objectForKey:key] forKey:key];
        }
    } failure:^(NSError *error) {
        DLog(@"Failed to reload: %@", error);
    }];
    if (completion)
        completion();
}

- (NSArray *)pendingReceivedTransactions {
    return [self.internalCache objectForKey:@"pending_received"];
}

- (void)reloadPendingReceivedTransactionsWithCompletion:(void (^)(NSArray *transactions))completion {
    [self reloadAllWithCompletion:^{
        if (completion)
            completion([self.internalCache objectForKey:@"pending_received"]);
    }];
}

- (NSArray *)pendingSentTransactions {
    return [self.internalCache objectForKey:@"pending_sent"];
}

- (void)reloadPendingSentTransactionsWithCompletion:(void (^)(NSArray *transactions))completion {
    [self reloadAllWithCompletion:^{
        if (completion)
            completion([self.internalCache objectForKey:@"pending_sent"]);
    }];
}

- (NSArray *)history {
    return [self.internalCache objectForKey:@"recent"];
}

- (void)reloadHistoryWithCompletion:(void (^)(NSArray *history))completion {
    [self reloadAllWithCompletion:^{
        if (completion)
            completion([self.internalCache objectForKey:@"recent"]);
    }];
}



@end
