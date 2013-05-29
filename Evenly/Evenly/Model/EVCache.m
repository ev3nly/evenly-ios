//
//  EVUserCache.m
//  Evenly
//
//  Created by Sean Yu on 4/9/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVCache.h"
#import "EVUser.h"
#import "EVSession.h"

#import "SSKeychain.h"

NSString *const EVCachedUserKey = @"EVCachedUserKey";
NSString *const EVCachedAuthenticationTokenKey = @"EVCachedAuthenticationTokenKey";

static EVUser *_cachedUser;

@implementation EVCache

+ (EVUser *)user {
    if (!_cachedUser)
        _cachedUser = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:EVCachedUserKey]];
    
    if (_cachedUser.dbid)
        return _cachedUser;
    return nil;
}

+ (BOOL)setUser:(EVUser *)user {
    _cachedUser = user;
    if (user == nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:EVCachedUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:EVCachedUserKey];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

+ (EVSession *)session {
    EVSession *session = [[EVSession alloc] init];
    session.authenticationToken = [[NSUserDefaults standardUserDefaults] objectForKey:EVCachedAuthenticationTokenKey];
    
    if (session.authenticationToken)
        return session;
    return nil;
}

+ (BOOL)setSession:(EVSession *)session {
    if (session == nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:EVCachedAuthenticationTokenKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:session.authenticationToken forKey:EVCachedAuthenticationTokenKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

static NSCache *_imageCache;

+ (NSCache *)imageCache {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _imageCache = [[NSCache alloc] init];
    });
    return _imageCache;    
}

@end
