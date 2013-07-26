//
//  EVBankAccount.m
//  Evenly
//
//  Created by Joseph Hankin on 3/31/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVBankAccount.h"
#import "EVConstants.h"
#import <Balanced/Balanced.h>

@implementation EVBankAccount

static NSDateFormatter *_dateFormatter = nil;
+ (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        _dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    }
    return _dateFormatter;
}

- (void)setProperties:(NSDictionary *)properties {
    [super setProperties:properties];
    
    self.bankName = [properties valueForKey:@"bank_name"];
    self.type = [properties valueForKey:@"type"];
    self.routingNumber = [properties valueForKey:@"routing_number"];
    self.accountNumber = [properties valueForKey:@"account_number"];
}

+ (NSString *)controllerName {
    return @"bankaccounts";
}

- (void)tokenizeWithSuccess:(void(^)(void))success failure:(void(^)(NSError *))failure
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        
        NSString *balancedURL = [[EVNetworkManager sharedInstance] balancedURLStringForServerSelection:[[EVNetworkManager sharedInstance] serverSelection]];
        Balanced *balanced = [[Balanced alloc] initWithMarketplaceURI:balancedURL];
        
        BPBankAccount *bankAccount = [[BPBankAccount alloc] initWithRoutingNumber:self.routingNumber
                                                                 andAccountNumber:self.accountNumber
                                                                   andAccountType:self.type
                                                                          andName:self.name];
        
        NSError *error;
        NSDictionary *response = [balanced tokenizeBankAccount:bankAccount error:&error];
        
        if (!error) {
            self.uri = response[@"uri"];
        }
        else {
            NSLog(@"%@", [error description]);
        }
        
        if (self.uri) {
            if (success)
                success();
        } else {
            error = [NSError errorWithDomain:@"Balanced" code:[response[@"status_code"] intValue] userInfo:response];
            if (failure)
                failure(error);
        }
        
    });
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<0x%x> %@ account number %@", (int)self, self.bankName, self.accountNumber];
}

#pragma mark - Overrides

- (void)validate {
    BOOL isValid;
    
    if (EV_IS_EMPTY_STRING(self.bankName))
        isValid = NO;
    else if (EV_IS_EMPTY_STRING(self.type))
        isValid = NO;
    else if (EV_IS_EMPTY_STRING(self.routingNumber))
        isValid = NO;
    else if (EV_IS_EMPTY_STRING(self.accountNumber))
        isValid = NO;
    else
        isValid = YES;
    
    self.valid = isValid;
}

@end
