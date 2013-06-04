//
//  EVCentralIntelligence.h
//  Evenly
//
//  Created by Joseph Hankin on 6/4/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVCentralIntelligence : NSObject

@property (nonatomic, strong) NSCache *imageCache;

+ (instancetype)sharedInstance;

- (void)reloadAllWithCompletion:(void (^)(void))completion;

- (NSArray *)pendingReceivedTransactions;
- (void)reloadPendingReceivedTransactionsWithCompletion:(void (^)(NSArray *transactions))completion;

- (NSArray *)pendingSentTransactions;
- (void)reloadPendingSentTransactionsWithCompletion:(void (^)(NSArray *transactions))completion;

- (NSArray *)history;
- (void)reloadHistoryWithCompletion:(void (^)(NSArray *history))completion;

@end
