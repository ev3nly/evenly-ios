//
//  EVError.m
//  Evenly
//
//  Created by Sean Yu on 4/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVError.h"

@implementation EVError

+ (EVError *)errorWithCode:(NSInteger)code andDictionary:(NSDictionary *)dictionary {
    NSMutableDictionary *mutable = [NSMutableDictionary dictionary];
    for (NSString *key in dictionary) {
        if (![dictionary[key] isKindOfClass:[NSNull class]])
            [mutable setObject:dictionary[key] forKey:key];
    }
    
    EVError *error = [[EVError alloc] initWithDomain:@"Vine" code:code userInfo:mutable];
    error.message = dictionary[@"message"];
    error.errors = [NSMutableSet set];
    for (NSString *errorString in dictionary[@"errors"]) {
        [error.errors addObject:errorString];
    }
    if (dictionary[@"error"])
        [error.errors addObject:dictionary[@"error"]];

    return error;
}

- (NSString *)errorMessages
{
    NSString *messages = @"";
    for (NSString *message in self.errors)
        messages = [messages stringByAppendingFormat:@"%@\n", message];
    return messages;
}

@end
