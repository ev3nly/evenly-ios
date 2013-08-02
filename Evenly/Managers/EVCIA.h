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

#pragma mark - Image Loading

- (void)loadImageFromURL:(NSURL *)url success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
- (void)loadImageFromURL:(NSURL *)url size:(CGSize)size success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;

@property (nonatomic, strong) NSCache *imageCache;
- (UIImage *)imageForURL:(NSURL *)url;
- (UIImage *)imageForURL:(NSURL *)url size:(CGSize)size;
- (void)setImage:(UIImage *)image forURL:(NSURL *)url;
- (void)setImage:(UIImage *)image forURL:(NSURL *)url withSize:(CGSize)size;

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

- (NSArray *)pendingExchanges;
- (NSArray *)pendingReceivedExchanges;
- (NSArray *)pendingSentExchanges;
- (NSArray *)history;

- (void)reloadPendingExchangesWithCompletion:(void (^)(NSArray *exchanges))completion;
- (void)reloadPendingReceivedExchangesWithCompletion:(void (^)(NSArray *exchanges))completion;
- (void)reloadPendingSentExchangesWithCompletion:(void (^)(NSArray *exchanges))completion;
- (void)reloadHistoryWithCompletion:(void (^)(NSArray *history))completion;

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

#pragma mark - Reset Password

- (void)resetPasswordForEmail:(NSString *)email withSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure;

@end
