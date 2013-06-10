//
//  EVCentralIntelligence.h
//  Evenly
//
//  Created by Joseph Hankin on 6/4/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVSession.h"

@class EVCreditCard;
@class EVBankAccount;

@interface EVCIA : NSObject

#pragma mark - Image Caching
@property (nonatomic, strong) NSCache *imageCache;
- (UIImage *)imageForURL:(NSURL *)url;
- (void)setImage:(UIImage *)image forURL:(NSURL *)url;

#pragma mark - Data Caching
@property (nonatomic, strong) EVUser *me;
@property (nonatomic, strong) EVSession *session;

+ (instancetype)sharedInstance;

#pragma mark - Exchanges

extern NSString *const EVCIAUpdatedExchangesNotification;

- (void)reloadAllExchangesWithCompletion:(void (^)(void))completion;

- (NSArray *)pendingReceivedExchanges;
- (NSArray *)pendingSentExchanges;
- (NSArray *)history;

- (void)reloadPendingReceivedExchangesWithCompletion:(void (^)(NSArray *exchanges))completion;
- (void)reloadPendingSentExchangesWithCompletion:(void (^)(NSArray *exchanges))completion;
- (void)reloadHistoryWithCompletion:(void (^)(NSArray *history))completion;

#pragma mark - Credit Cards

extern NSString *const EVCIAUpdatedCreditCardsNotification;

- (void)reloadCreditCardsWithCompletion:(void (^)(NSArray *creditCards))completion;

- (NSArray *)creditCards;
- (EVCreditCard *)activeCreditCard;

#pragma mark - Bank Accounts

extern NSString *const EVCIAUpdatedBankAccountsNotification;

- (NSArray *)bankAccounts;

- (EVBankAccount *)activeBankAccount;
- (void)reloadBankAccountsWithCompletion:(void (^)(NSArray *bankAccounts))completion;

@end
