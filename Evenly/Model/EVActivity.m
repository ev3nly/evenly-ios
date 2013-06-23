//
//  EVActivity.m
//  Evenly
//
//  Created by Sean Yu on 4/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVActivity.h"
#import "EVSerializer.h"

@implementation EVActivity

+ (NSString *)controllerName {
    return @"activity";
}

+ (void)allWithSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure {
    [super allWithSuccess:^(id result){
        
        NSMutableArray *pending_received = [NSMutableArray array];
        NSMutableArray *pending_sent = [NSMutableArray array];
        NSMutableArray *recent = [NSMutableArray array];
        
        for (NSDictionary *requestDictionary in [result objectForKey:@"pending_received"])
            [pending_received addObject:[EVSerializer serializeDictionary:requestDictionary]];
        
        for (NSDictionary *requestDictionary in [result objectForKey:@"pending_sent"])
            [pending_sent addObject:[EVSerializer serializeDictionary:requestDictionary]];
        
        for (NSDictionary *itemDictionary in [result objectForKey:@"recent"])
            [recent addObject:[EVSerializer serializeDictionary:itemDictionary]];
        
        if (success)
            success(@{ @"pending_received": pending_received, @"pending_sent": pending_sent, @"recent": recent });
        
    } failure:failure];
}

@end
