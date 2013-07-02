//
//  EVCentralIntelligence.h
//  Evenly
//
//  Created by Joseph Hankin on 6/4/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVSession.h"

@class EVObject;
@class EVFundingSource;
@class EVCreditCard;
@class EVBankAccount;

@interface EVCIA : NSObject

+ (instancetype)sharedInstance;

#pragma mark - Image Caching

@property (nonatomic, strong) NSCache *imageCache;
- (UIImage *)imageForURL:(NSURL *)url;
- (void)setImage:(UIImage *)image forURL:(NSURL *)url;

#pragma mark - Data Caching

- (void)cacheNewSession;
@property (nonatomic, strong) EVUser *me;
@property (nonatomic, strong) EVSession *session;

extern NSString *const EVCIAUpdatedMeNotification;

+ (EVUser *)me;
+ (void)reloadMe;
- (void)cacheMe;

+ (NSArray *)myConnections;

- (EVObject *)cachedObjectWithClassName:(NSString *)className dbid:(NSString *)dbid;
- (void)cacheObject:(EVObject *)object;

#pragma mark - Exchanges

extern NSString *const EVCIAUpdatedExchangesNotification;

- (void)reloadAllExchangesWithCompletion:(void (^)(void))completion;
- (void)reloadAllExchangesWithCompletion:(void (^)(void))completion actOnCache:(BOOL)actOnCache;

- (NSArray *)pendingExchanges;
- (NSArray *)pendingReceivedExchanges;
- (NSArray *)pendingSentExchanges;
- (NSArray *)history;

- (void)reloadPendingReceivedExchangesWithCompletion:(void (^)(NSArray *exchanges))completion;
- (void)reloadPendingSentExchangesWithCompletion:(void (^)(NSArray *exchanges))completion;
- (void)reloadHistoryWithCompletion:(void (^)(NSArray *history))completion;
- (void)refreshHistoryWithCompletion:(void (^)(NSArray *history))completion;

#pragma mark - Credit Cards

extern NSString *const EVCIAUpdatedCreditCardsNotification;

- (void)reloadCreditCardsWithCompletion:(void (^)(NSArray *creditCards))completion;
@property (nonatomic, readonly) BOOL loadingCreditCards;
- (NSArray *)creditCards;
- (EVCreditCard *)activeCreditCard;

#pragma mark - Bank Accounts

extern NSString *const EVCIAUpdatedBankAccountsNotification;

- (void)reloadBankAccountsWithCompletion:(void (^)(NSArray *bankAccounts))completion;
@property (nonatomic, readonly) BOOL loadingBankAccounts;
- (NSArray *)bankAccounts;
- (EVBankAccount *)activeBankAccount;

#pragma mark - Generic Funding Source

- (void)deleteFundingSource:(EVFundingSource *)fundingSource
                withSuccess:(void(^)(void))success
                    failure:(void(^)(NSError *))failure;

#pragma mark - Facebook

@property (nonatomic, strong) NSString *accessToken;

@end
