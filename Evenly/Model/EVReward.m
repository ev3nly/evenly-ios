//
//  EVReward.m
//  Evenly
//
//  Created by Joseph Hankin on 7/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVReward.h"

NSString *const EVRewardRedeemedNotification = @"EVRewardRedeemedNotification";

static EVReward *_rewardsExhaustedSentinel;

@implementation EVReward

+ (NSString *)controllerName {
    return @"rewards";
}

+ (instancetype)rewardsExhaustedSentinel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _rewardsExhaustedSentinel = [[EVReward alloc] init];
        _rewardsExhaustedSentinel.dbid = @"-1";
        _rewardsExhaustedSentinel.options = @[ @"exhausted" ];
    });
    return _rewardsExhaustedSentinel;
}

- (void)setProperties:(NSDictionary *)properties {
    [super setProperties:properties];
    
    NSMutableArray *array = [NSMutableArray array];
    for (id obj in properties[@"options"]) {
        if ([obj isKindOfClass:[NSNull class]])
            [array addObject:obj];
        else if ([obj isKindOfClass:[NSString class]])
            [array addObject:[NSDecimalNumber decimalNumberWithString:obj]];
        else if ([obj respondsToSelector:@selector(stringValue)])
            [array addObject:[NSDecimalNumber decimalNumberWithString:[obj stringValue]]];
    }
    self.options = [NSArray arrayWithArray:array];
    if (properties[@"selected_option_index"] == [NSNull null]) {
        self.selectedOptionIndex = NSNotFound;
    } else {
        self.selectedOptionIndex = [properties[@"selected_option_index"] integerValue];
    }
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    setValueForKeyIfNonNil(self.options, @"options");
    if (self.selectedOptionIndex == NSNotFound)
        [mutableDictionary setValue:[NSNull null] forKey:@"selected_option_index"];
    else
        [mutableDictionary setValue:@(self.selectedOptionIndex) forKey:@"selected_option_index"];
    
    [mutableDictionary setValue:@(self.willShare) forKey:@"will_share"];
    
    if (self.facebookStoryID)
        [mutableDictionary setValue:self.facebookStoryID forKey:@"facebook_story_id"];
    
    return (NSDictionary *)mutableDictionary;
}

- (void)redeemWithSuccess:(void (^)(EVReward *reward))success failure:(void (^)(NSError *error))failure {
    NSMutableURLRequest *request = [[self class] requestWithMethod:@"PUT" 
                                                              path:self.dbid
                                                        parameters:[self dictionaryRepresentation]];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        EVReward *newReward = [[EVReward alloc] initWithDictionary:responseObject];
        [self setProperties:responseObject];
        
        if (success)
            success(newReward);
    };
    
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                              success:successBlock
                                                                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                  if (failure)
                                                                                      failure(error);
                                                                              }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

- (NSDecimalNumber *)selectedAmount {
    if (self.selectedOptionIndex == NSNotFound)
        return nil;
    return [self.options objectAtIndex:self.selectedOptionIndex];
}

@end
