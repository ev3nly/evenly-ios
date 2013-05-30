//
//  EVSerializer.h
//  Evenly
//
//  Created by Sean Yu on 4/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EVObject;

@interface EVSerializer : NSObject

+ (EVObject *)serializeDictionary:(NSDictionary *)dictionary;

@end
