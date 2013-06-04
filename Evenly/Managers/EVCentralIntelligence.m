//
//  EVCentralIntelligence.m
//  Evenly
//
//  Created by Joseph Hankin on 6/4/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVCentralIntelligence.h"
#import "EVActivity.h"

static EVCentralIntelligence *_sharedInstance;

@interface EVCentralIntelligence ()

@property (nonatomic, strong) NSCache *dataCache;

@end

@implementation EVCentralIntelligence

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[EVCentralIntelligence alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.dataCache = [[NSCache alloc] init];
    }
    return self;
}

- (void)reloadAllWithCompletion:(void (^)(void))completion {
    [EVActivity allWithSuccess:^(id result) {
        for (id key in [result allKeys]) {
            [self.dataCache setObject:[result objectForKey:key] forKey:key];
        }
    } failure:^(NSError *error) {
        DLog(@"Failed to reload: %@", error);
    }];
    if (completion)
        completion();
}

- (NSArray *)pendingReceivedTransactions {
    return [self.dataCache objectForKey:@"pending_received"];
}

- (void)reloadPendingReceivedTransactionsWithCompletion:(void (^)(NSArray *transactions))completion {
    [self reloadAllWithCompletion:^{
        if (completion)
            completion([self.dataCache objectForKey:@"pending_received"]);
    }];
}

- (NSArray *)pendingSentTransactions {
    return [self.dataCache objectForKey:@"pending_sent"];
}

- (void)reloadPendingSentTransactionsWithCompletion:(void (^)(NSArray *transactions))completion {
    [self reloadAllWithCompletion:^{
        if (completion)
            completion([self.dataCache objectForKey:@"pending_sent"]);
    }];
}

- (NSArray *)history {
    return [self.dataCache objectForKey:@"recent"];
}

- (void)reloadHistoryWithCompletion:(void (^)(NSArray *history))completion {
    [self reloadAllWithCompletion:^{
        if (completion)
            completion([self.dataCache objectForKey:@"recent"]);
    }];
}



@end
