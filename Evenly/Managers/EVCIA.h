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

- (void)reloadAllWithCompletion:(void (^)(void))completion;

- (NSArray *)pendingReceivedExchanges;
- (void)reloadPendingReceivedExchangesWithCompletion:(void (^)(NSArray *exchanges))completion;

- (NSArray *)pendingSentExchanges;
- (void)reloadPendingSentExchangesWithCompletion:(void (^)(NSArray *exchanges))completion;

- (NSArray *)history;
- (void)reloadHistoryWithCompletion:(void (^)(NSArray *history))completion;

- (NSArray *)creditCards;
- (EVCreditCard *)activeCreditCard;
- (void)reloadCreditCardsWithCompletion:(void (^)(NSArray *creditCards))completion;

- (NSArray *)bankAccounts;
- (EVBankAccount *)activeBankAccount;
- (void)reloadBankAccountsWithCompletion:(void (^)(NSArray *bankAccounts))completion;

@end
