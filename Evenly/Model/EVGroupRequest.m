//
//  EVGroupRequest.m
//  Evenly
//
//  Created by Joseph Hankin on 4/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequest.h"
#import "EVSerializer.h"
#import "EVGroupRequestTier.h"
#import "EVGroupRequestRecord.h"
#import "EVPayment.h"

@interface EVGroupRequest ()

- (void)saveTier:(EVGroupRequestTier *)tier
     withSuccess:(void (^)(EVGroupRequestTier *tier))success
         failure:(void (^)(NSError *error))failure;

@end

@implementation EVGroupRequest

+ (NSString *)controllerName {
    return @"group-charges";
}

- (void)setProperties:(NSDictionary *)properties {
    [super setProperties:properties];
    
    self.title = properties[@"title"];
    self.memo = properties[@"description"];
    
    if (![properties[@"from"] isKindOfClass:[NSString class]]) {
        EVObject *fromObject = [EVSerializer serializeDictionary:properties[@"from"]];
        if ([fromObject conformsToProtocol:@protocol(EVExchangeable)])
            self.from = (EVObject<EVExchangeable> *)fromObject;
    }
    
    NSMutableArray *tiers = [NSMutableArray array];
    if (properties[@"tiers"]) {
        for (NSDictionary *dictionary in properties[@"tiers"]) {
            EVGroupRequestTier *tier = [[EVGroupRequestTier alloc] initWithGroupRequest:self properties:dictionary];
            [tiers addObject:tier];
        }
    }
    self.tiers = [NSArray arrayWithArray:tiers];
    
    NSMutableArray *records = [NSMutableArray array];
    if (properties[@"records"]) {
        for (NSDictionary *dictionary in properties[@"records"]) {
            EVGroupRequestRecord *record = [[EVGroupRequestRecord alloc] initWithGroupRequest:self properties:dictionary];
            [records addObject:record];
        }
    }
    self.records = records;
    self.completed = [properties[@"completed"] boolValue];
    self.visibility = (properties[@"visibility"]) ? properties[@"visibility"] : [EVStringUtility stringForPrivacySetting:[EVCIA me].privacySetting];
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    
    setValueForKeyIfNonNil(self.title, @"title");
    setValueForKeyIfNonNil(self.memo, @"description");
    setValueForKeyIfNonNil(self.visibility, @"visibility");
    
    [mutableDictionary setObject:[NSNumber numberWithBool:self.completed] forKey:@"completed"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (EVGroupRequestTier *tier in self.tiers) {
        [array addObject:[tier dictionaryRepresentation]];
    }
    [mutableDictionary setObject:array forKey:@"tiers"];
    
    array = [NSMutableArray array];
    for (EVObject<EVExchangeable> *member in self.initialMembers) {
        if ([member isKindOfClass:[EVUser class]]) {
            [array addObject:[member dbid]];
        } else {
            [array addObject:[member email]];
        }
    }
    if ([array count])
        [mutableDictionary setObject:array forKey:@"record_data"];
    
    if ([self.initialAssignments count])
    {
        [mutableDictionary setObject:self.initialAssignments forKey:@"assignments"];
    }    
    return mutableDictionary;
}

- (EVGroupRequestTier *)tierWithID:(NSString *)tierID {
    EVGroupRequestTier *tier = nil;
    for (tier in self.tiers) {
        if ([tier.dbid isEqualToString:tierID]) {
            break;
        }
    }
    return tier;
}

- (EVGroupRequestRecord *)myRecord {
    EVGroupRequestRecord *record = nil;
    for (record in self.records) {
        if (record.user == [EVCIA me])
            break;
    }
    return record;
}

- (NSDecimalNumber *)totalOwed {
    NSDecimalNumber *total = [NSDecimalNumber zero];
    for (EVGroupRequestRecord *record in self.records) {
        if (record.tier)
            total = [total decimalNumberByAdding:record.tier.price];
    }
    return total;
}

- (NSDecimalNumber *)totalPaid {
    NSDecimalNumber *total = [NSDecimalNumber zero];
    for (EVGroupRequestRecord *record in self.records) {
        if (record.amountPaid)
            total = [total decimalNumberByAdding:record.amountPaid];
    }
    return total;
}

- (float)progress {
    if ([[self totalOwed] isEqualToNumber:[NSDecimalNumber zero]])
        return 0.0f;
    return [[[self totalPaid] decimalNumberByDividingBy:[self totalOwed]] floatValue];
}

- (BOOL)isTierEditable:(EVGroupRequestTier *)tier {
    BOOL editable = YES;
    for (EVGroupRequestRecord *record in self.records) {
        if (record.tier == tier && record.numberOfPayments > 0) {
            editable = NO;
            break;
        }
    }
    return editable;
}

#pragma mark - API Interactions

- (void)remindAllWithSuccess:(void (^)(void))success failure:(void(^)(NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"%@/reminders", self.dbid];
    NSMutableURLRequest *request = [[self class] requestWithMethod:@"POST"
                                                              path:path
                                                        parameters:nil];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"Response object: %@", responseObject);
        if (success)
            success();
    };
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                              success:successBlock
                                                                              failure:^(AFHTTPRequestOperation *operation, NSError *error)  {
                                                                                  if (failure)
                                                                                      failure(error);
                                                                              }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

#pragma mark Tiers
- (void)allTiersWithSuccess:(void (^)(NSArray *tiers))success
                    failure:(void (^)(NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"%@/tiers", self.dbid];
    NSMutableURLRequest *request = [[self class] requestWithMethod:@"GET"
                                                              path:path
                                                        parameters:nil];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *mutableTiers = [NSMutableArray array];
        for (NSDictionary *dict in responseObject)
        {
            EVGroupRequestTier *tier = [[EVGroupRequestTier alloc] initWithDictionary:dict];
            [mutableTiers addObject:tier];
        }
        NSArray *tiers = [NSArray arrayWithArray:mutableTiers];
        self.tiers = tiers;
        if (success)
            success(tiers);
    };
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                      success:successBlock
                                                                      failure:^(AFHTTPRequestOperation *operation, NSError *error)  {
                                                                          if (failure)
                                                                              failure(error);
                                                                      }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

- (EVGroupRequestTier *)replaceOrInsertTier:(EVGroupRequestTier *)tier withResponseObject:(NSDictionary *)responseObject {
    EVGroupRequestTier *newTier = [[EVGroupRequestTier alloc] initWithDictionary:responseObject];
    NSMutableArray *tmpTiers = [NSMutableArray arrayWithArray:self.tiers];
    if ([tmpTiers indexOfObject:tier] == NSNotFound) {
        [tmpTiers addObject:newTier];
    } else {
        [tmpTiers replaceObjectAtIndex:[tmpTiers indexOfObject:tier] withObject:newTier];
    }
    self.tiers = (NSArray *)tmpTiers;
    return newTier;
}

- (void)saveTier:(EVGroupRequestTier *)tier
     withSuccess:(void (^)(EVGroupRequestTier *tier))success
         failure:(void (^)(NSError *error))failure {
    NSString *method, *path;
    if (tier.dbid)
    {
        method = @"PUT";
        path = [NSString stringWithFormat:@"%@/tiers/%@", self.dbid, tier.dbid];
    }
    else
    {
        method = @"POST";
        path = [NSString stringWithFormat:@"%@/tiers", self.dbid];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!EV_IS_EMPTY_STRING(tier.name))
        [params setObject:tier.name forKey:@"name"];
    if ([method isEqualToString:@"POST"])
        [params setObject:[tier.price stringValue] forKey:@"price"];
    NSMutableURLRequest *request = [[self class] requestWithMethod:method
                                                              path:path
                                                        parameters:params];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        EVGroupRequestTier *newTier = [self replaceOrInsertTier:tier withResponseObject:responseObject];
        if (success)
            success(newTier);
    };
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                              success:successBlock
                                                                              failure:^(AFHTTPRequestOperation *operation, NSError *error)  {
                                                                                  if (failure)
                                                                                      failure(error);
                                                                              }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];    
}

- (void)addTier:(EVGroupRequestTier *)tier
    withSuccess:(void (^)(EVGroupRequestTier *tier))success
        failure:(void (^)(NSError *error))failure {
    [self saveTier:tier withSuccess:success failure:failure];
}

- (void)updateTier:(EVGroupRequestTier *)tier
       withSuccess:(void (^)(EVGroupRequestTier *tier))success
           failure:(void (^)(NSError *error))failure {
    [self updateTier:tier withSuccess:success failure:failure];
}

- (void)deleteTier:(EVGroupRequestTier *)tier
       withSuccess:(void (^)(void))success
           failure:(void (^)(NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"%@/tiers/%@", self.dbid, tier.dbid];
    NSMutableURLRequest *request = [[self class] requestWithMethod:@"DELETE"
                                                              path:path
                                                        parameters:nil];
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                  NSMutableArray *newTiers = [NSMutableArray arrayWithArray:self.tiers];
                                                                                  [newTiers removeObject:tier];
                                                                                  self.tiers = newTiers;
                                                                                  if (success)
                                                                                      success();
                                                                              }
                                                                              failure:^(AFHTTPRequestOperation *operation, NSError *error)  {
                                                                                  if (failure)
                                                                                      failure(error);
                                                                              }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

#pragma mark Records
- (void)allRecordsWithSuccess:(void (^)(NSArray *records))success
                      failure:(void (^)(NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"%@/records", self.dbid];
    NSMutableURLRequest *request = [[self class] requestWithMethod:@"GET"
                                                              path:path
                                                        parameters:nil];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *mutableRecords = [NSMutableArray array];
        for (NSDictionary *dict in responseObject)
        {
            EVGroupRequestRecord *record = [[EVGroupRequestRecord alloc] initWithGroupRequest:self properties:dict];
            [mutableRecords addObject:record];
        }
        NSArray *records = [NSArray arrayWithArray:mutableRecords];
        self.records = records;
        if (success)
            success(records);
    };
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                              success:successBlock
                                                                              failure:^(AFHTTPRequestOperation *operation, NSError *error)  {
                                                                                  if (failure)
                                                                                      failure(error);
                                                                              }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

- (EVGroupRequestRecord *)replaceOrInsertRecord:(EVGroupRequestRecord *)record withResponseObject:(NSDictionary *)responseObject {
    EVGroupRequestRecord *newRecord = [[EVGroupRequestRecord alloc] initWithGroupRequest:self properties:responseObject];
    NSMutableArray *tmpRecords = [NSMutableArray arrayWithArray:self.records];
    if ([tmpRecords indexOfObject:record] == NSNotFound) {
        [tmpRecords addObject:newRecord];
    } else {
        [tmpRecords replaceObjectAtIndex:[tmpRecords indexOfObject:record] withObject:newRecord];
    }
    self.records = (NSArray *)tmpRecords;
    return newRecord;
}

- (void)addRecord:(EVGroupRequestRecord *)record
      withSuccess:(void (^)(EVGroupRequestRecord *record))success
          failure:(void (^)(NSError *error))failure {
    [self addRecords:@[ record ]
         withSuccess:^(NSArray *records) {
             if (success)
                 success([records lastObject]);
         } failure:failure];
}

- (void)addRecords:(NSArray *)records
       withSuccess:(void (^)(NSArray *records))success
           failure:(void (^)(NSError *error))failure {
    NSString *method, *path;
    method = @"POST";
    path = [NSString stringWithFormat:@"%@/records", self.dbid];
    
    NSMutableArray *array = [NSMutableArray array];
    for (EVGroupRequestRecord *record in records) {
        [array addObject:[record dictionaryRepresentation]];
    }
    NSDictionary *params = @{ @"users" : array };
    NSMutableURLRequest *request = [[self class] requestWithMethod:method
                                                              path:path
                                                        parameters:params];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i=0; i < [responseObject count]; i++) {
            NSDictionary *responseDictionary = [responseObject objectAtIndex:i];
            EVGroupRequestRecord *newRecord = [[EVGroupRequestRecord alloc] initWithGroupRequest:self properties:responseDictionary];
            [array addObject:newRecord];
        }
        self.records = [self.records arrayByAddingObjectsFromArray:array];
        if (success)
            success(array);
    };
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                              success:successBlock
                                                                              failure:^(AFHTTPRequestOperation *operation, NSError *error)  {
                                                                                  if (failure)
                                                                                      failure(error);
                                                                              }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

- (void)updateRecord:(EVGroupRequestRecord *)record
         withSuccess:(void (^)(EVGroupRequestRecord *record))success
             failure:(void (^)(NSError *error))failure {
    NSString *method, *path;
    method = @"PUT";
    path = [NSString stringWithFormat:@"%@/records/%@", self.dbid, record.dbid];
    
    NSDictionary *params = [record dictionaryRepresentation];
    NSMutableURLRequest *request = [[self class] requestWithMethod:method
                                                              path:path
                                                        parameters:params];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        EVGroupRequestRecord *newRecord = [self replaceOrInsertRecord:record withResponseObject:responseObject];
        if (success)
            success(newRecord);
    };
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                              success:successBlock
                                                                              failure:^(AFHTTPRequestOperation *operation, NSError *error)  {
                                                                                  if (failure)
                                                                                      failure(error);
                                                                              }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
    
}

- (void)markRecordCompleted:(EVGroupRequestRecord *)record
                withSuccess:(void (^)(EVGroupRequestRecord *record))success
                    failure:(void (^)(NSError *error))failure {
    NSString *method = @"PUT";
    NSString *path = [NSString stringWithFormat:@"%@/records/%@", self.dbid, record.dbid];
    NSDictionary *params = @{ @"completed" : @(YES) };
    NSMutableURLRequest *request = [[self class] requestWithMethod:method
                                                              path:path
                                                        parameters:params];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        record.completed = YES;
        if (success)
            success(record);
    };
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                              success:successBlock
                                                                              failure:^(AFHTTPRequestOperation *operation, NSError *error)  {
                                                                                  if (failure)
                                                                                      failure(error);
                                                                              }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

- (void)remindRecord:(EVGroupRequestRecord *)record
         withSuccess:(void (^)(void))success
             failure:(void (^)(NSError *error))failure {
    
    NSString *method = @"POST";
    NSString *path = [NSString stringWithFormat:@"%@/records/%@/reminders", self.dbid, record.dbid];
    NSMutableURLRequest *request = [[self class] requestWithMethod:method
                                                              path:path
                                                        parameters:nil];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success)
            success();
    };
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                              success:successBlock
                                                                              failure:^(AFHTTPRequestOperation *operation, NSError *error)  {
                                                                                  if (failure)
                                                                                      failure(error);
                                                                              }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];

    
}

- (void)deleteRecord:(EVGroupRequestRecord *)record
         withSuccess:(void (^)(void))success
             failure:(void (^)(NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"%@/records/%@", self.dbid, record.dbid];
    NSMutableURLRequest *request = [[self class] requestWithMethod:@"DELETE"
                                                              path:path
                                                        parameters:nil];
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                  NSMutableArray *newRecords = [NSMutableArray arrayWithArray:self.records];
                                                                                  [newRecords removeObject:record];
                                                                                  self.records = newRecords;
                                                                                  if (success)
                                                                                      success();
                                                                              }
                                                                              failure:^(AFHTTPRequestOperation *operation, NSError *error)  {
                                                                                  if (failure)
                                                                                      failure(error);
                                                                              }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

- (void)allPaymentsForRecord:(EVGroupRequestRecord *)record
                 withSuccess:(void (^)(NSArray *payments))success
                     failure:(void (^)(NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"%@/records/%@/payments", self.dbid, record.dbid];
    NSMutableURLRequest *request = [[self class] requestWithMethod:@"GET"
                                                              path:path
                                                        parameters:nil];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *mutablePayments = [NSMutableArray array];
        for (NSDictionary *dict in responseObject)
        {
            EVPayment *payment = [[EVPayment alloc] initWithDictionary:dict];
            [mutablePayments addObject:payment];
        }
        NSArray *payments = [NSArray arrayWithArray:mutablePayments];
        [record setPayments:payments];
        success(payments);
    };
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                              success:successBlock
                                                                              failure:^(AFHTTPRequestOperation *operation, NSError *error)  {
                                                                                  if (failure)
                                                                                      failure(error);
                                                                              }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

- (void)makePaymentOfAmount:(NSDecimalNumber *)amount
                  forRecord:(EVGroupRequestRecord *)record
                withSuccess:(void (^)(EVPayment *payment))success
                    failure:(void (^)(NSError *error))failure {
    NSDictionary *params = @{ @"amount" : [amount stringValue] };
    NSString *path = [NSString stringWithFormat:@"%@/records/%@/payments", self.dbid, record.dbid];
    NSMutableURLRequest *request = [[self class] requestWithMethod:@"POST"
                                                              path:path
                                                        parameters:params];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        EVPayment *payment = [[EVPayment alloc] initWithDictionary:responseObject];
        [record setPayments:[record.payments arrayByAddingObject:payment]];
        record.numberOfPayments++;
        [record setAmountPaid:[record.amountPaid decimalNumberByAdding:payment.amount]];
        success(payment);
    };
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                              success:successBlock
                                                                              failure:^(AFHTTPRequestOperation *operation, NSError *error)  {
                                                                                  if (failure)
                                                                                      failure(error);
                                                                              }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

- (UIImage *)avatar {
    return self.from.avatar;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<0x%x> Group Request %@\n--------------\nTitle: %@\nDescription: %@\nTiers: %@\nRecords: %@\n",
            (int)self, self.dbid, self.title, self.memo, self.tiers, self.records];
}

@end
