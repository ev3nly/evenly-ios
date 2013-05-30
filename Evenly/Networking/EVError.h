//
//  EVError.h
//  Evenly
//
//  Created by Sean Yu on 4/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVError : NSError

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSMutableSet *errors;

@property (nonatomic, readonly) NSString *errorMessages;

+ (EVError *)errorWithCode:(NSInteger)code andDictionary:(NSDictionary *)dictionary;

@end
