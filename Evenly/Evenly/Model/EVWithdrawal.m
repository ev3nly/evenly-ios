//
//  EVWithdrawal.m
//  Evenly
//
//  Created by Joseph Hankin on 3/31/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVWithdrawal.h"
#import "EVBankAccount.h"

@implementation EVWithdrawal

- (void)setProperties:(NSDictionary *)properties {
    [super setProperties:properties];
    
    self.amount = [NSDecimalNumber decimalNumberWithString:[properties valueForKey:@"amount"]];
    self.bankName = [properties valueForKey:@"bank_name"];
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    setValueForKeyIfNonNil([self.amount stringValue], @"amount");
    setValueForKeyIfNonNil(self.bankName, @"bank_name");
    setValueForKeyIfNonNil(self.bankAccount.dbid, @"bank_account_id");
    return [NSDictionary dictionaryWithDictionary:mutableDictionary];
}

+ (NSString *)controllerName {
    return @"withdrawals";
}

@end
