//
//  EVCentralIntelligence.m
//  Evenly
//
//  Created by Joseph Hankin on 6/4/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVCIA.h"
#import "EVObject.h"
#import "EVActivity.h"
#import "EVCreditCard.h"
#import "EVBankAccount.h"
#import "EVConnection.h"

NSString *const EVCachedUserKey = @"EVCachedUserKey";
NSString *const EVCachedAuthenticationTokenKey = @"EVCachedAuthenticationTokenKey";

static EVCIA *_sharedInstance;

@interface EVCIA ()

@property (nonatomic, strong) NSMutableDictionary *internalCache;
@property (nonatomic, strong) EVUser *cachedUser;
@property (nonatomic, readwrite) BOOL loadingCreditCards;
@property (nonatomic, readwrite) BOOL loadingBankAccounts;

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
        self.internalCache = [[NSMutableDictionary alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didSignIn:)
                                                     name:EVSessionSignedInNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMemoryWarning:)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning:(NSNotification *)notification {
    [self.internalCache removeAllObjects];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didSignIn:(NSNotification *)notification {
    [self reloadAllExchangesWithCompletion:NULL];
    [self reloadCreditCardsWithCompletion:NULL];
    [self reloadBankAccountsWithCompletion:NULL];
}

#pragma mark - Image Loading

- (void)loadImageFromURL:(NSURL *)url success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure {
    if ([self imageForURL:url]) {
        if (success)
            success([self imageForURL:url]);
        return;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFImageRequestOperation *imageRequestOperation = [AFImageRequestOperation imageRequestOperationWithRequest:request
                                                                                          imageProcessingBlock:NULL
                                                                                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                           [[EVCIA sharedInstance] setImage:image forURL:url];
                                                                                                           if (success)
                                                                                                               success(image);
                                                                                                       } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                           if (failure)
                                                                                                               failure(error);
                                                                                                       }];
    [[EVNetworkManager sharedInstance] enqueueRequest:imageRequestOperation];
}

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
        [UIImagePNGRepresentation(image) writeToFile:[EVStringUtility cachePathFromURL:url]
                                          atomically:YES];
    }
}


#pragma mark - Me

NSString *const EVCIAUpdatedMeNotification = @"EVCIAUpdatedMeNotification";

+ (EVUser *)me {
    return ((EVCIA *)[self sharedInstance]).me;
}

+ (void)reloadMe {
    [EVUser meWithSuccess:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:EVCIAUpdatedMeNotification object:nil];
        DLog(@"Got me: %@", [[self sharedInstance] me]);
        [[self sharedInstance] reloadAllExchangesWithCompletion:NULL];
        
    } failure:^(NSError *error) {
        DLog(@"ERROR?! %@", error);
    } reload:YES];
}


- (void)cacheNewSession {
    //retrieve user from session call, cache user
    EVUser *me = [[EVUser alloc] initWithDictionary:[EVSession sharedSession].originalDictionary[@"user"]];
    [EVUser setMe:me];
    [self setMe:me];
    
    [EVUtilities registerForPushNotifications];
    
    //cache session
    [self setSession:[EVSession sharedSession]];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVSessionSignedInNotification object:nil];
}

- (EVUser *)me {
    if (!self.cachedUser)
        self.cachedUser = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:EVCachedUserKey]];
    
    if (self.cachedUser.dbid)
        return self.cachedUser;
    return nil;
}

- (void)setMe:(EVUser *)user {
    self.cachedUser = user;
    [self cacheMe];
}

- (void)cacheMe {
    if (self.cachedUser == nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:EVCachedUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.cachedUser]
                                                  forKey:EVCachedUserKey];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray *)myConnections {
    NSMutableArray *array = [NSMutableArray array];
    [[[self me] connections] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [array addObject:[(EVConnection *)obj user]];
    }];
    return array;
}

#pragma mark - Session

- (EVSession *)session {
    EVSession *session = [[EVSession alloc] init];
    session.authenticationToken = [[NSUserDefaults standardUserDefaults] objectForKey:EVCachedAuthenticationTokenKey];
    
    if (session.authenticationToken) {
        DLog(@"Auth token: %@", session.authenticationToken);
        return session;
    }
    return nil;
}

- (void)setSession:(EVSession *)session {
    if (session == nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:EVCachedAuthenticationTokenKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:session.authenticationToken forKey:EVCachedAuthenticationTokenKey];
        DLog(@"Auth token: %@", session.authenticationToken);
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Data Caching

- (NSString *)cacheStringFromClassName:(NSString *)className dbid:(NSString *)dbid {
    return [NSString stringWithFormat:@"%@_%@", className, dbid];
}

- (NSString *)cacheStringFromObject:(EVObject *)object {
    return [self cacheStringFromClassName:NSStringFromClass([object class]) dbid:[object dbid]];
}

- (EVObject *)cachedObjectWithClassName:(NSString *)className dbid:(NSString *)dbid {
    return [self.internalCache objectForKey:[self cacheStringFromClassName:className dbid:dbid]];
}

- (void)cacheObject:(EVObject *)object {
    [self.internalCache setObject:object forKey:[self cacheStringFromObject:object]];
}


#pragma mark - Exchanges

NSString *const EVCIAUpdatedExchangesNotification = @"EVCIAUpdatedExchangesNotification";

- (void)reloadAllExchangesWithCompletion:(void (^)(void))completion {
    [self reloadAllExchangesWithCompletion:completion actOnCache:YES];
}

- (void)reloadAllExchangesWithCompletion:(void (^)(void))completion actOnCache:(BOOL)actOnCache {
    [EVActivity allWithSuccess:^(id result) {
        
        BOOL updated = NO;
        for (id key in [result allKeys]) {
            NSArray *oldResult = [self.internalCache objectForKey:key];
            if (!oldResult || ![oldResult isEqualToArray:[result objectForKey:key]])
            {
                updated = YES;
                [self.internalCache setObject:[result objectForKey:key] forKey:key];
            }
        }
        if (completion)
            completion();
        if (updated)
            [[NSNotificationCenter defaultCenter] postNotificationName:EVCIAUpdatedExchangesNotification
                                                                object:self
                                                              userInfo:nil];
    } failure:^(NSError *error) {
        DLog(@"Failed to reload: %@", error);
    }];
    if (actOnCache && completion)
        completion();
}

- (NSArray *)pendingExchanges {
    NSArray *received = [[self pendingReceivedExchanges] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj2 createdAt] compare:[obj1 createdAt]];
    }];
    NSArray *sent = [[self pendingSentExchanges] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj2 createdAt] compare:[obj1 createdAt]];
    }];
    return [received arrayByAddingObjectsFromArray:sent];
}

- (NSArray *)pendingReceivedExchanges {
    return [self.internalCache objectForKey:@"pending_received"];
}

- (void)reloadPendingReceivedExchangesWithCompletion:(void (^)(NSArray *exchanges))completion {
    [self reloadAllExchangesWithCompletion:^{
        if (completion)
            completion([self.internalCache objectForKey:@"pending_received"]);
    }];
}

- (NSArray *)pendingSentExchanges {
    return [self.internalCache objectForKey:@"pending_sent"];
}

- (void)reloadPendingSentExchangesWithCompletion:(void (^)(NSArray *exchanges))completion {
    [self reloadAllExchangesWithCompletion:^{
        if (completion)
            completion([self.internalCache objectForKey:@"pending_sent"]);
    }];
}

- (NSArray *)history {
    return [self.internalCache objectForKey:@"recent"];
}

- (void)reloadHistoryWithCompletion:(void (^)(NSArray *history))completion {
    [EVUser historyStartingAtPage:1
                          success:^(NSArray *history) {
                              [self.internalCache setObject:history forKey:@"recent"];
                              if (completion)
                                  completion(history);
    } failure:^(NSError *error) {
        DLog(@"Error reloading history: %@", error);
    }];
//    [self reloadAllExchangesWithCompletion:^{
//        if (completion)
//            completion([self.internalCache objectForKey:@"recent"]);
//    }];
}

- (void)refreshHistoryWithCompletion:(void (^)(NSArray *history))completion {
    [self reloadAllExchangesWithCompletion:^{
        if (completion)
            completion([self.internalCache objectForKey:@"recent"]);
    } actOnCache:NO];
}

#pragma mark - Credit Cards

NSString *const EVCIAUpdatedCreditCardsNotification = @"EVCIAUpdatedCreditCardsNotification";

- (NSArray *)creditCards {
    return [self.internalCache objectForKey:@"credit_cards"];
}

- (EVCreditCard *)activeCreditCard {
    return (EVCreditCard *)[EVUtilities activeFundingSourceFromArray:[self creditCards]];
}

- (void)reloadCreditCardsWithCompletion:(void (^)(NSArray *creditCards))completion {
    self.loadingCreditCards = YES;
    [EVCreditCard allWithSuccess:^(id result){
        self.loadingCreditCards = NO;
        NSArray *cards = [result sortedArrayUsingSelector:@selector(compareByBrandAndLastFour:)];
        NSArray *oldCards = [self creditCards];
        if (![cards isEqualToArray:oldCards])
        {
            [self.internalCache setObject:cards forKey:@"credit_cards"];
            [[NSNotificationCenter defaultCenter] postNotificationName:EVCIAUpdatedCreditCardsNotification
                                                                object:self
                                                              userInfo:@{ @"cards" : cards }];
        }
        if (completion)
            completion(cards);
    } failure:^(NSError *error){
        self.loadingCreditCards = NO;
    }];
}

#pragma mark - Bank Accounts

NSString *const EVCIAUpdatedBankAccountsNotification = @"EVCIAUpdatedBankAccountsNotification";

- (NSArray *)bankAccounts {
    return [self.internalCache objectForKey:@"bank_accounts"];
}

- (EVBankAccount *)activeBankAccount {
    return (EVBankAccount *)[EVUtilities activeFundingSourceFromArray:[self bankAccounts]];
}

- (void)reloadBankAccountsWithCompletion:(void (^)(NSArray *bankAccounts))completion {
    self.loadingBankAccounts = YES;
    [EVBankAccount allWithSuccess:^(id result){
        self.loadingBankAccounts = NO;
        NSArray *oldAccounts = [self bankAccounts];
        if (![oldAccounts isEqualToArray:result])
        {
            [self.internalCache setObject:result forKey:@"bank_accounts"];
            [[NSNotificationCenter defaultCenter] postNotificationName:EVCIAUpdatedBankAccountsNotification
                                                                object:self
                                                              userInfo:@{ @"accounts" : result }];
        }
        if (completion)
            completion(result);
    } failure:^(NSError *error){
        self.loadingBankAccounts = NO;
    }];
}

#pragma mark - Generic Funding Source

- (void)deleteFundingSource:(EVFundingSource *)fundingSource
                withSuccess:(void(^)(void))success
                    failure:(void(^)(NSError *))failure {
    [fundingSource destroyWithSuccess:^{
        
        NSMutableArray *fundingSources;
        if ([fundingSource isKindOfClass:[EVBankAccount class]]) {
            fundingSources = [NSMutableArray arrayWithArray:[self bankAccounts]];
            [fundingSources removeObject:fundingSource];
            [self.internalCache setObject:fundingSources forKey:@"bank_accounts"];
            [[NSNotificationCenter defaultCenter] postNotificationName:EVCIAUpdatedBankAccountsNotification
                                                                object:self
                                                              userInfo:@{ @"accounts" : fundingSources }];
            
        } else if ([fundingSource isKindOfClass:[EVCreditCard class]]) {
            fundingSources = [NSMutableArray arrayWithArray:[self creditCards]];
            [fundingSources removeObject:fundingSource];
            [self.internalCache setObject:fundingSources forKey:@"credit_cards"];
            [[NSNotificationCenter defaultCenter] postNotificationName:EVCIAUpdatedCreditCardsNotification
                                                                object:self
                                                              userInfo:@{ @"cards" : fundingSources }];
        }
        
        if (success)
            success();
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

#pragma mark - Reset Password

- (void)resetPasswordForEmail:(NSString *)email withSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    [EVUser resetPasswordForEmail:email
                      withSuccess:success
                          failure:failure];
}

@end
