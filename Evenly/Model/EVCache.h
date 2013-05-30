//
//  EVUserCache.h
//  Evenly
//
//  Created by Sean Yu on 4/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  EVUser,
        EVSession;

@interface EVCache : NSObject

+ (EVUser *)user;
+ (BOOL)setUser:(EVUser *)user;

+ (EVSession *)session;
+ (BOOL)setSession:(EVSession *)session;

+ (NSCache *)imageCache;

@end
