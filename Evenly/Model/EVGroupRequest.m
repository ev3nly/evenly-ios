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

- (void)saveRecord:(EVGroupRequestRecord *)record
       withSuccess:(void (^)(EVGroupRequestRecord *record))success
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
    for (NSDictionary *dictionary in properties[@"tiers"]) {
        [tiers addObject:[EVSerializer serializeDictionary:dictionary]];
    }
    self.tiers = [NSArray arrayWithArray:tiers];
    
    NSMutableArray *records = [NSMutableArray array];
    for (NSDictionary *dictionary in properties[@"records"]) {
        EVGroupRequestRecord *record = (EVGroupRequestRecord *)[EVSerializer serializeDictionary:dictionary];
        record.groupRequest = self;
        [records addObject:record];
    }
    self.records = records;
    self.completed = [properties[@"completed"] boolValue];
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    
    setValueForKeyIfNonNil(self.title, @"title");
    setValueForKeyIfNonNil(self.memo, @"description");
    
    NSMutableArray *array = [NSMutableArray array];
    for (EVGroupRequestTier *tier in self.tiers) {
        [array addObject:[tier dictionaryRepresentation]];
    }
    [mutableDictionary setObject:array forKey:@"tiers"];
    
    array = [NSMutableArray array];
    for (EVObject<EVExchangeable> *member in self.members) {
        if ([member isKindOfClass:[EVUser class]]) {
            [array addObject:[member dbid]];
        } else {
            [array addObject:[member email]];
        }
    }
    if ([array count])
        [mutableDictionary setObject:array forKey:@"record_data"];
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

#pragma mark - API Interactions
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
    [params setObject:[tier.price stringValue] forKey:@"price"];
    NSMutableURLRequest *request = [[self class] requestWithMethod:method
                                                              path:path
                                                        parameters:params];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        EVGroupRequestTier *tier = [[EVGroupRequestTier alloc] initWithDictionary:responseObject];
        self.tiers = [self.tiers arrayByAddingObject:tier];
        success(tier);
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
            EVGroupRequestRecord *record = [[EVGroupRequestRecord alloc] initWithDictionary:dict];
            [mutableRecords addObject:record];
        }
        NSArray *records = [NSArray arrayWithArray:mutableRecords];
        self.records = records;
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

- (void)saveRecord:(EVGroupRequestRecord *)record
       withSuccess:(void (^)(EVGroupRequestRecord *record))success
           failure:(void (^)(NSError *error))failure {
    NSString *method, *path;
    
    if (record.dbid)
    {
        method = @"PUT";
        path = [NSString stringWithFormat:@"%@/records/%@", self.dbid, record.dbid];
    }
    else
    {
        method = @"POST";
        path = [NSString stringWithFormat:@"%@/records", self.dbid];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (record.tier)
        [params setObject:record.tier.dbid forKey:@"tier_id"];
    if (record.user.dbid)
        [params setObject:record.user.dbid forKey:@"user_id"];
    else
        [params setObject:record.user.email forKey:@"user_id"];
    
    NSMutableURLRequest *request = [[self class] requestWithMethod:method
                                                              path:path
                                                        parameters:params];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        EVGroupRequestRecord *record = [[EVGroupRequestRecord alloc] initWithDictionary:responseObject];
        self.records = [self.records arrayByAddingObject:record];
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

- (void)addRecord:(EVGroupRequestRecord *)record
      withSuccess:(void (^)(EVGroupRequestRecord *record))success
          failure:(void (^)(NSError *error))failure {
    [self saveRecord:record withSuccess:success failure:failure];
}

- (void)updateRecord:(EVGroupRequestRecord *)record
         withSuccess:(void (^)(EVGroupRequestRecord *record))success
             failure:(void (^)(NSError *error))failure {
    [self saveRecord:record withSuccess:success failure:failure];    
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
