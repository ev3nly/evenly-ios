//
//  EVGroupRequest.h
//  Evenly
//
//  Created by Joseph Hankin on 4/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVObject.h"

@class EVGroupRequestTier;
@class EVGroupRequestRecord;

@interface EVGroupRequest : EVObject

@property (nonatomic, strong) EVObject<EVExchangeable> *from;
@property (nonatomic, strong) NSArray *tiers;
@property (nonatomic, strong) NSArray *members;
@property (nonatomic, strong) NSArray *records;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *memo;
@property (nonatomic) BOOL completed;

@property (nonatomic, readonly) UIImage *avatar;

- (EVGroupRequestTier *)tierWithID:(NSString *)tierID;
- (EVGroupRequestRecord *)myRecord;

- (NSDecimalNumber *)totalOwed;
- (NSDecimalNumber *)totalPaid;
- (float)progress;

- (BOOL)isTierEditable:(EVGroupRequestTier *)tier;

#pragma mark - API Interactions
#pragma mark Tiers
- (void)allTiersWithSuccess:(void (^)(NSArray *tiers))success
                    failure:(void (^)(NSError *error))failure;

- (void)saveTier:(EVGroupRequestTier *)tier
     withSuccess:(void (^)(EVGroupRequestTier *tier))success
         failure:(void (^)(NSError *error))failure;

- (void)addTier:(EVGroupRequestTier *)tier
    withSuccess:(void (^)(EVGroupRequestTier *tier))success
        failure:(void (^)(NSError *error))failure;

- (void)updateTier:(EVGroupRequestTier *)tier
       withSuccess:(void (^)(EVGroupRequestTier *tier))success
           failure:(void (^)(NSError *error))failure;

- (void)deleteTier:(EVGroupRequestTier *)tier
       withSuccess:(void (^)(void))success
           failure:(void (^)(NSError *error))failure;

#pragma mark Records
- (void)allRecordsWithSuccess:(void (^)(NSArray *records))success
                      failure:(void (^)(NSError *error))failure;

- (void)addRecord:(EVGroupRequestRecord *)record
      withSuccess:(void (^)(EVGroupRequestRecord *record))success
          failure:(void (^)(NSError *error))failure;

- (void)updateRecord:(EVGroupRequestRecord *)record
         withSuccess:(void (^)(EVGroupRequestRecord *record))success
             failure:(void (^)(NSError *error))failure;

- (void)markRecordCompleted:(EVGroupRequestRecord *)record
                withSuccess:(void (^)(EVGroupRequestRecord *record))success
                    failure:(void (^)(NSError *error))failure;

- (void)deleteRecord:(EVGroupRequestRecord *)record
         withSuccess:(void (^)(void))success
             failure:(void (^)(NSError *error))failure;

- (void)allPaymentsForRecord:(EVGroupRequestRecord *)record
                 withSuccess:(void (^)(NSArray *payments))success
                     failure:(void (^)(NSError *error))failure;

- (void)makePaymentOfAmount:(NSDecimalNumber *)amount
                  forRecord:(EVGroupRequestRecord *)record
                withSuccess:(void (^)(EVPayment *payment))success
                    failure:(void (^)(NSError *error))failure;
@end
