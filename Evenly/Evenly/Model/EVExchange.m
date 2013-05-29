//
//  EVExchange.m
//  Evenly
//
//  Created by Sean Yu on 4/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchange.h"
#import "EVSerializer.h"
#import "EVCharge.h"
#import "EVPayment.h"

/* 
 {
    amount = "10.0";
    class = Charge;
    "created_at" = "2013-04-04T04:56:01Z";
    description = "Lunch @ Sai's";
    from =     {
        class = User;
        "created_at" = "2013-04-03T05:41:57Z";
        id = 8;
        name = "Norole Jones";
    };
    id = 268;
    to = me;
 }
 
 {
    "class": "SignUpCharge",
    "id": 335,
    "created_at": "2013-04-02T22:28:57Z",
    "amount": "10.0",
    "description": "Lunch @ Sai's",
    "to": {
        "class": "SignUpContact",
        "id": 128,
        "created_at": "2013-04-02T22:28:57Z",
        "name": "joe@paywithivy.com",
        "information": "joe@paywithivy.com"
    },
    "from": "me"
 }
*/

@implementation EVExchange

- (void)setProperties:(NSDictionary *)properties {
    [super setProperties:properties];
    
    self.amount = [NSDecimalNumber decimalNumberWithString:properties[@"amount"]];
    self.memo = properties[@"description"];
    
    if (![properties[@"to"] isKindOfClass:[NSString class]]) {
        EVObject *toObject = [EVSerializer serializeDictionary:properties[@"to"]];
        if ([toObject conformsToProtocol:@protocol(EVExchangeable)])
            self.to = (EVObject<EVExchangeable> *)toObject;
    }
    
    if (![properties[@"from"] isKindOfClass:[NSString class]]) {
        EVObject *fromObject = [EVSerializer serializeDictionary:properties[@"from"]];
        if ([fromObject conformsToProtocol:@protocol(EVExchangeable)])
            self.from = (EVObject<EVExchangeable> *)fromObject;
    }
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    
    setValueForKeyIfNonNil(self.to.dbid, @"id");
    setValueForKeyIfNonNil(self.to.email, @"email");
    
    return @{
        @"amount":          [self.amount stringValue],
        @"description":     self.memo,
        @"to":              mutableDictionary
    };
}



- (BOOL)isIncoming {
    if ([self isKindOfClass:[EVCharge class]])
        return (self.from == nil);
    else if ([self isKindOfClass:[EVPayment class]])
        return (self.to == nil);
    else
        [NSException raise:@"EVInvalidExchangeClassException" format:@"Exchange is neither a charge nor a payment but rather a %@", [self class]];
    return NO;
}

@end
