//
//  EVSerializer.m
//  Evenly
//
//  Created by Sean Yu on 4/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVSerializer.h"

#import "EVSession.h"

#import "EVObject.h"
#import "EVUser.h"
#import "EVCharge.h"
#import "EVGroupCharge.h"
#import "EVPayment.h"
#import "EVCreditCard.h"
#import "EVBankAccount.h"
#import "EVWithdrawal.h"
#import "EVNotificationSetting.h"

static NSDictionary *_classMapping = nil;

@interface EVSerializer(private)

+ (NSDictionary *)classMapping;

@end

@implementation EVSerializer(private)

+ (NSDictionary *)classMapping {
    if (!_classMapping) {
        _classMapping = @{
                          
          @"User":                  [EVUser class],
          @"SignUpUser":            [EVUser class],
          @"SignUpContact":         [EVContact class],
          @"Charge":                [EVCharge class],
          @"SignUpCharge":          [EVCharge class],
          @"GroupCharge":           [EVGroupCharge class],
          @"Payment":               [EVPayment class],
          @"SignUpPayment":         [EVPayment class],
          @"Withdrawal":            [EVWithdrawal class],
          @"Balanced::Card":        [EVCreditCard class],
          @"Balanced::BankAccount": [EVBankAccount class],
          @"NotificationSetting":   [EVNotificationSetting class]
          
        };
    }
    return _classMapping;
}

@end

@implementation EVSerializer

+ (EVObject *)serializeDictionary:(NSDictionary *)dictionary
{
    if (![dictionary isKindOfClass:[NSDictionary class]])
        return nil;
    
    NSString *classString = dictionary[@"class"];
    if (!classString)
        return nil;
    
    Class class = [self classMapping][classString];
    if (!class)
        return nil;
    
    return [[class alloc] initWithDictionary:dictionary];
}

@end
