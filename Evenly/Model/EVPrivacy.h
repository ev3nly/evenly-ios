//
//  EVPrivacy.h
//  Evenly
//
//  Created by Justin Brunet on 6/13/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    EVPrivacySettingNetwork,
    EVPrivacySettingFriends,
    EVPrivacySettingPrivate
} EVPrivacySetting;

@interface EVPrivacy : NSObject

@end
