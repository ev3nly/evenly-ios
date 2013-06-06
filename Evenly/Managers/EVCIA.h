//
//  EVCentralIntelligence.h
//  Evenly
//
//  Created by Joseph Hankin on 6/4/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVSession.h"

@interface EVCIA : NSObject

@property (nonatomic, strong) NSCache *imageCache;

@property (nonatomic, strong) EVUser *me;
@property (nonatomic, strong) EVSession *session;

+ (instancetype)sharedInstance;

- (void)reloadAllWithCompletion:(void (^)(void))completion;

- (NSArray *)pendingReceivedTransactions;
- (void)reloadPendingReceivedTransactionsWithCompletion:(void (^)(NSArray *transactions))completion;

- (NSArray *)pendingSentTransactions;
- (void)reloadPendingSentTransactionsWithCompletion:(void (^)(NSArray *transactions))completion;

- (NSArray *)history;
- (void)reloadHistoryWithCompletion:(void (^)(NSArray *history))completion;

@end
