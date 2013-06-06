//
//  EVCentralIntelligence.m
//  Evenly
//
//  Created by Joseph Hankin on 6/4/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVCIA.h"
#import "EVActivity.h"

NSString *const EVCachedUserKey = @"EVCachedUserKey";
NSString *const EVCachedAuthenticationTokenKey = @"EVCachedAuthenticationTokenKey";

static EVCIA *_sharedInstance;

@interface EVCIA ()

@property (nonatomic, strong) NSCache *internalCache;
@property (nonatomic, strong) EVUser *cachedUser;

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

#pragma mark - Me

- (EVUser *)me {
    if (!self.cachedUser)
        self.cachedUser = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:EVCachedUserKey]];
    
    if (self.cachedUser.dbid)
        return self.cachedUser;
    return nil;
}

- (void)setMe:(EVUser *)user {
    self.cachedUser = user;
    if (user == nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:EVCachedUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:EVCachedUserKey];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Session

- (EVSession *)session {
    EVSession *session = [[EVSession alloc] init];
    session.authenticationToken = [[NSUserDefaults standardUserDefaults] objectForKey:EVCachedAuthenticationTokenKey];
    
    if (session.authenticationToken)
        return session;
    return nil;
}

- (void)setSession:(EVSession *)session {
    if (session == nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:EVCachedAuthenticationTokenKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:session.authenticationToken forKey:EVCachedAuthenticationTokenKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
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
