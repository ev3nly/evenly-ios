//
//  EVPushManager.h
//  Evenly
//
//  Created by Joseph Hankin on 7/29/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVPushManager : NSObject

+ (EVPushManager *)sharedManager;

- (EVObject *)objectFromPushDictionary:(NSDictionary *)pushDictionary;

@end
