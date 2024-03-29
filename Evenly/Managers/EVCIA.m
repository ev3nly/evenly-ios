//
//  EVCentralIntelligence.m
//  Evenly
//
//  Created by Joseph Hankin on 6/4/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVCIA.h"
#import "EVObject.h"
#import "EVCreditCard.h"
#import "EVBankAccount.h"
#import "EVConnection.h"
#import "EVExchange.h"
#import "EVWalletNotification.h"
#import "EVFacebookManager.h"
#import "EVSettingsManager.h"
#import <Mixpanel/Mixpanel.h>
#import <Crashlytics/Crashlytics.h>

NSString *const EVCachedUserKey = @"EVCachedUserKey";
NSString *const EVCachedAuthenticationTokenKey = @"EVCachedAuthenticationTokenKey";

NSString *const EVPendingReceivedExchangesKey = @"pending_received";
NSString *const EVPendingSentExchangesKey = @"pending_sent";

NSString *const EVUserHasCompletedGettingStartedKey = @"EVUserHasCompletedGettingStartedKey";
NSString *const EVUserFacebookFriendCountKey = @"EVUserFacebookFriendCountKey";

static EVCIA *_sharedInstance;

@interface EVCIA ()

@property (nonatomic, strong) NSMutableDictionary *internalCache;
@property (nonatomic, strong) EVUser *cachedUser;
@property (nonatomic, readwrite) BOOL loadingCreditCards;
@property (nonatomic, readwrite) BOOL loadingBankAccounts;
@property (strong) NSMutableDictionary *imageLoadingSuccessBlocks; //to prevent duplicate image request from being fired off

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
        self.imageLoadingSuccessBlocks = [NSMutableDictionary new];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didSignIn:)
                                                     name:EVSessionSignedInNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didSignOut:)
                                                     name:EVSessionSignedOutNotification
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
    [self reloadPendingExchangesWithCompletion:NULL];
    [self reloadHistoryWithCompletion:NULL];
    [self reloadCreditCardsWithCompletion:NULL];
    [self reloadBankAccountsWithCompletion:NULL];
}

- (void)didSignOut:(NSNotification *)notification {
    [self.internalCache removeAllObjects];
    [EVFacebookManager closeAndClearSession];
}

#pragma mark - Image Loading

- (void)loadImageFromURL:(NSURL *)url success:(EVCIAImageLoadedSuccessBlock)success failure:(void (^)(NSError *error))failure {
    [self loadImageFromURL:url size:CGSizeZero success:success failure:failure];
}

- (void)loadImageFromURL:(NSURL *)url size:(CGSize)size success:(EVCIAImageLoadedSuccessBlock)success failure:(void (^)(NSError *error))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        //check for previously cached image and return if one exists
        UIImage *cachedImage = [self imageForURL:url size:size];
        if (cachedImage) {
            if (success) {
                EV_PERFORM_ON_MAIN_QUEUE(^{
                    success(cachedImage);
                });
            }
            return;
        }
        
        //if there's already a request for this url, add the success block to the queue and return
        NSString *cachePath = [EVStringUtility cachePathFromURL:url size:size];
        if (self.imageLoadingSuccessBlocks[cachePath]) {
            NSMutableArray *array = self.imageLoadingSuccessBlocks[cachePath];
            if (success)
                [array addObject:success];
            return;
        } else {
            if (success) {
                //if there isn't a queue for this url yet, make one and continue
                NSMutableArray *array = [NSMutableArray arrayWithObject:success];
                [self.imageLoadingSuccessBlocks setObject:array forKey:cachePath];
            }
        }
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFImageRequestOperation *imageRequestOperation;
        imageRequestOperation = [AFImageRequestOperation imageRequestOperationWithRequest:request
                                                                     imageProcessingBlock:NULL
                                                                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                      EV_PERFORM_ON_BACKGROUND_QUEUE(^{
                                                                                          CGSize constrainedSize = [EVImageUtility sizeForImage:image
                                                                                                                          withInnerBoundingSize:size];
                                                                                          UIImage *resizedImage = [EVImageUtility resizeImage:image
                                                                                                                                       toSize:constrainedSize];
                                                                                          [[EVCIA sharedInstance] setImage:resizedImage
                                                                                                                    forURL:url
                                                                                                                  withSize:size];

                                                                                          //run all the success blocks
                                                                                          if (self.imageLoadingSuccessBlocks[cachePath]) {
                                                                                              NSArray *successArray = [NSArray arrayWithArray:self.imageLoadingSuccessBlocks[cachePath]];
                                                                                              EV_PERFORM_ON_MAIN_QUEUE(^{
                                                                                                  for (EVCIAImageLoadedSuccessBlock successBlock in successArray) {
                                                                                                      successBlock(resizedImage);
                                                                                                  }
                                                                                                  //clear all the blocks for this url
                                                                                                  [self.imageLoadingSuccessBlocks removeObjectForKey:cachePath];
                                                                                              });
                                                                                          }
                                                                                      });
                                                                                  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                      if (failure)
                                                                                          failure(error);
                                                                                      //clear all the blocks, so the user could resend if need be
                                                                                      [self.imageLoadingSuccessBlocks removeObjectForKey:cachePath];
                                                                                  }];
        [[EVNetworkManager sharedInstance] enqueueRequest:imageRequestOperation];
    });
}

- (UIImage *)imageForURL:(NSURL *)url {
    return [self imageForURL:url size:CGSizeZero];
}

- (UIImage *)imageForURL:(NSURL *)url size:(CGSize)size {
    UIImage *image = nil;
    NSString *cachePath = [EVStringUtility cachePathFromURL:url size:size];
    // Check memory cache
    if ((image = [self.imageCache objectForKey:cachePath]))
        return image;
    else // Check disk cache
    {
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfFile:cachePath
                                              options:0
                                                error:&error];
        if (data && !error)
        {
            image = [UIImage imageWithData:data];
            [self.imageCache setObject:image forKey:cachePath];
        }
    }
    return image;
}

- (void)setImage:(UIImage *)image forURL:(NSURL *)url {
    [self setImage:image forURL:url withSize:CGSizeZero]; //CGSizeZero signifies full size image
}

- (void)setImage:(UIImage *)image forURL:(NSURL *)url withSize:(CGSize)size {
    EV_PERFORM_ON_BACKGROUND_QUEUE(^{
        NSString *cachePath = [EVStringUtility cachePathFromURL:url size:size];
        if (!image) // remove image from memory and disk caches
        {
            [self.imageCache removeObjectForKey:cachePath];
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtPath:cachePath
                                                       error:&error];
            if (error)
                DLog(@"Error: %@", error);
            return;
        }
        else // store in memory and disk caches
        {
            [self.imageCache setObject:image forKey:cachePath];
            [UIImagePNGRepresentation(image) writeToFile:cachePath
                                              atomically:YES];
        }
    });
}

#pragma mark - Me

NSString *const EVCIAUpdatedMeNotification = @"EVCIAUpdatedMeNotification";

+ (EVUser *)me {
    return ((EVCIA *)[self sharedInstance]).me;
}

+ (void)reloadMe {
    [self reloadMeWithCompletion:nil];
}

+ (void)reloadMeWithCompletion:(void (^)(void))completion {
    [EVUser meWithSuccess:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:EVCIAUpdatedMeNotification object:nil];
        
        EVUser *me = [[self sharedInstance] me];
        [[self sharedInstance] reloadPendingExchangesWithCompletion:NULL];
        [[self sharedInstance] reloadHistoryWithCompletion:NULL];
        [[EVSettingsManager sharedManager] loadSettingsFromServer];
        
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        
        [mixpanel identify:me.dbid];
        [Crashlytics setUserIdentifier:[EVParseUtility userIdentifier]];
        
        [mixpanel.people set:@"$name"       to:me.name];
        [Crashlytics setUserName:me.name];
        if (me.email) {
            [mixpanel.people set:@"$email"      to:me.email];
            [Crashlytics setUserEmail:me.email];
        }
        [mixpanel.people set:@"$created"    to:me.createdAt];
        [mixpanel.people set:@"$last_login" to:[NSDate date]];
        [mixpanel.people set:@"iOS App True Version"    to:EV_APP_VERSION];
        [mixpanel.people set:@"iOS App True Build"      to:EV_APP_BUILD];
        
        mixpanel.nameTag = me.name;
        
        if (me.roles)
            [Crashlytics setObjectValue:me.roles forKey:@"user_roles"];
        [EVParseUtility registerChannels];
        
        me.facebookFriendCount = [[NSUserDefaults standardUserDefaults] integerForKey:EVUserFacebookFriendCountKey];        
        if ([EVFacebookManager isConnected]) {
            [EVFacebookManager loadFriendsWithCompletion:^(NSArray *friends) {
                me.facebookFriendCount = [friends count];
                [[NSUserDefaults standardUserDefaults] setInteger:[friends count] forKey:EVUserFacebookFriendCountKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } failure:^(NSError *error) {
                DLog(@"Could not load friends: %@", error);
            }];
        }        
        if (completion)
            completion();
    } failure:^(NSError *error) {
        DLog(@"ERROR?! %@", error);
    } reload:YES];
}

- (void)cacheNewSession {
    //retrieve user from session call, cache user
    NSDictionary *originalDictionary = [EVSession sharedSession].originalDictionary[@"user"];
    EVUser *me = [[EVUser alloc] initWithDictionary:originalDictionary];
    [self setMe:me];
    
    [EVUtilities registerForPushNotifications];
    [[EVSettingsManager sharedManager] loadSettingsFromServer];
    
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

- (void)clearCache {
    [self.internalCache removeAllObjects];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:EVCachedUserKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:EVCachedAuthenticationTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray *)myConnections {
    NSMutableArray *array = [NSMutableArray array];
    [[[self me] connections] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id user = [(EVConnection *)obj user];
        if (user)
            [array addObject:user];
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
    if (EV_IS_EMPTY_STRING(className) || EV_IS_EMPTY_STRING(dbid))
        return nil;
    return [self.internalCache objectForKey:[self cacheStringFromClassName:className dbid:dbid]];
}

- (void)cacheObject:(EVObject *)object {
    [self.internalCache setObject:object forKey:[self cacheStringFromObject:object]];
}


#pragma mark - Exchanges

NSString *const EVCIAUpdatedExchangesNotification = @"EVCIAUpdatedExchangesNotification";

- (NSArray *)pendingExchanges {
    NSArray *received = [[self pendingReceivedExchanges] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj2 createdAt] compare:[obj1 createdAt]];
    }];
    NSArray *sent = [[self pendingSentExchanges] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj2 createdAt] compare:[obj1 createdAt]];
    }];
    NSArray *everything = [received arrayByAddingObjectsFromArray:sent];
    
    if (self.me.needsGettingStartedHelp) {
        everything = [@[ [EVWalletNotification unconfirmedNotification] ] arrayByAddingObjectsFromArray:everything];
    }
    return everything;
}

- (NSArray *)pendingReceivedExchanges {
    return [self.internalCache objectForKey:EVPendingReceivedExchangesKey];
}

- (void)reloadPendingExchangesWithCompletion:(void (^)(NSArray *exchanges))completion {
    [EVUser pendingWithSuccess:^(NSArray *pending) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSArray *incoming = [pending filter:^BOOL(id object) {
                return [object isIncoming];
            }];
            NSArray *outgoing = [pending filter:^BOOL(id object) {
                return ![object isIncoming];
            }];
            
            NSArray *oldIncoming = [self.internalCache objectForKey:EVPendingSentExchangesKey];
            NSArray *oldOutgoing = [self.internalCache objectForKey:EVPendingReceivedExchangesKey];
            @try {
                if (!oldIncoming || ![oldIncoming isEqualToArray:incoming]) {
                    [self.internalCache setObject:incoming forKey:EVPendingSentExchangesKey];
                }
                if (!oldOutgoing || ![oldOutgoing isEqualToArray:outgoing]) {
                    [self.internalCache setObject:outgoing forKey:EVPendingReceivedExchangesKey];
                }
            }
            @catch (NSException *exception) {
                DRaise(exception);
                [self.internalCache removeObjectForKey:EVPendingSentExchangesKey];
                [self.internalCache removeObjectForKey:EVPendingReceivedExchangesKey];
                oldIncoming = nil;
                oldOutgoing = nil;
            }
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[outgoing count]];
            EV_PERFORM_ON_MAIN_QUEUE(^{
                if (completion)
                    completion(pending);
                [[NSNotificationCenter defaultCenter] postNotificationName:EVCIAUpdatedExchangesNotification
                                                                    object:self
                                                                  userInfo:nil];
            });
        });
    } failure:^(NSError *error) {
        
    }];
}

- (void)reloadPendingReceivedExchangesWithCompletion:(void (^)(NSArray *exchanges))completion {
    [self reloadPendingExchangesWithCompletion:^(NSArray *exchanges){
        if (completion)
            completion([self pendingReceivedExchanges]);
    }];
}

- (NSArray *)pendingSentExchanges {
    return [self.internalCache objectForKey:EVPendingSentExchangesKey];
}

- (void)reloadPendingSentExchangesWithCompletion:(void (^)(NSArray *exchanges))completion {
    [self reloadPendingExchangesWithCompletion:^(NSArray *exchanges){
        if (completion)
            completion([self pendingSentExchanges]);
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
        EV_PERFORM_ON_BACKGROUND_QUEUE(^{
            self.loadingCreditCards = NO;
            NSArray *cards = [result sortedArrayUsingSelector:@selector(compareByBrandAndLastFour:)];
            NSArray *oldCards = [self creditCards];
            if (cards && ![cards isEqualToArray:oldCards])
            {
                [self.internalCache setObject:cards forKey:@"credit_cards"];
                EV_PERFORM_ON_MAIN_QUEUE(^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:EVCIAUpdatedCreditCardsNotification
                                                                        object:self
                                                                      userInfo:@{ @"cards" : cards }];
                });

            }
            if (completion) {
                EV_PERFORM_ON_MAIN_QUEUE(^{
                    completion(cards);
                });
            }
        });
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
        if (![oldAccounts isEqualToArray:result] && result)
        {
            [self.internalCache setObject:result forKey:@"bank_accounts"];
            EV_PERFORM_ON_MAIN_QUEUE(^{
                [[NSNotificationCenter defaultCenter] postNotificationName:EVCIAUpdatedBankAccountsNotification
                                                                    object:self
                                                                  userInfo:@{ @"accounts" : result }];
            });

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
        EV_PERFORM_ON_BACKGROUND_QUEUE(^{
            NSMutableArray *fundingSources;
            if ([fundingSource isKindOfClass:[EVBankAccount class]]) {
                fundingSources = [NSMutableArray arrayWithArray:[self bankAccounts]];
                [fundingSources removeObject:fundingSource];
                [self.internalCache setObject:fundingSources forKey:@"bank_accounts"];
                EV_PERFORM_ON_MAIN_QUEUE(^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:EVCIAUpdatedBankAccountsNotification
                                                                        object:self
                                                                      userInfo:@{ @"accounts" : fundingSources }];
                });
            } else if ([fundingSource isKindOfClass:[EVCreditCard class]]) {
                fundingSources = [NSMutableArray arrayWithArray:[self creditCards]];
                [fundingSources removeObject:fundingSource];
                [self.internalCache setObject:fundingSources forKey:@"credit_cards"];
                EV_PERFORM_ON_MAIN_QUEUE(^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:EVCIAUpdatedCreditCardsNotification
                                                                        object:self
                                                                      userInfo:@{ @"cards" : fundingSources }];
                });
            }
            EV_PERFORM_ON_MAIN_QUEUE(^{
                if (success)
                    success();
            });
        });
    } failure:^(NSError *error) {
        EV_PERFORM_ON_MAIN_QUEUE(^{
            if (failure)
                failure(error);
        });
    }];
}

#pragma mark - Reset Password

- (void)resetPasswordForEmail:(NSString *)email withSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    [EVUser resetPasswordForEmail:email
                      withSuccess:success
                          failure:failure];
}

@end
