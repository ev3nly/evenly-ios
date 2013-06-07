//
//  EVCentralIntelligence.m
//  Evenly
//
//  Created by Joseph Hankin on 6/4/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVCIA.h"
#import "EVActivity.h"
#import "EVCreditCard.h"
#import "EVBankAccount.h"

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

#pragma mark - Image Caching



- (UIImage *)imageForURL:(NSURL *)url {
    UIImage *image = nil;
    // Check memory cache
    if ((image = [self.imageCache objectForKey:url]))
        return image;
    else // Check disk cache
    {
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfFile:[EVStringUtility cachePathFromURL:url]
                                              options:0
                                                error:&error];
        if (data && !error)
        {
            DLog(@"Got disk-cached data at path %@", [EVStringUtility cachePathFromURL:url]);
            image = [UIImage imageWithData:data];
            [self.imageCache setObject:image forKey:url];
        }
    }
    return image;
}

- (void)setImage:(UIImage *)image forURL:(NSURL *)url {
    if (!image) // remove image from memory and disk caches
    {
        [self.imageCache removeObjectForKey:url];
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:[EVStringUtility cachePathFromURL:url]
                                                   error:&error];
        if (error)
            DLog(@"Error: %@", error);
        return;
    }
    else // store in memory and disk caches
    {
        [self.imageCache setObject:image forKey:url];
        BOOL success = [UIImagePNGRepresentation(image) writeToFile:[EVStringUtility cachePathFromURL:url]
                                                         atomically:YES];
        if (success)
            DLog(@"Wrote to file at %@", [EVStringUtility cachePathFromURL:url]);
    }
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

#pragma mark - Credit Cards

- (NSArray *)creditCards {
    return [self.internalCache objectForKey:@"credit_cards"];
}

- (EVCreditCard *)activeCreditCard {
    return (EVCreditCard *)[EVUtilities activeFundingSourceFromArray:[self creditCards]];
}

- (void)reloadCreditCardsWithCompletion:(void (^)(NSArray *creditCards))completion {
    [EVCreditCard allWithSuccess:^(id result){
        
        NSArray *cards = [result sortedArrayUsingSelector:@selector(compareByBrandAndLastFour:)];
        [self.internalCache setObject:cards forKey:@"credit_cards"];
        if (completion)
            completion(cards);
    } failure:^(NSError *error){
        
    }];
}

#pragma mark - Bank Accounts

- (NSArray *)bankAccounts {
    return [self.internalCache objectForKey:@"bank_accounts"];
}

- (EVBankAccount *)activeBankAccount {
    return (EVBankAccount *)[EVUtilities activeFundingSourceFromArray:[self bankAccounts]];
}

- (void)reloadBankAccountsWithCompletion:(void (^)(NSArray *bankAccounts))completion {
    [EVBankAccount allWithSuccess:^(id result){
        [self.internalCache setObject:result forKey:@"bank_accounts"];
        if (completion)
            completion(result);
    } failure:^(NSError *error){
        
    }];
}




@end
