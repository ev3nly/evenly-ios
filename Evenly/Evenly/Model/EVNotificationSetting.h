//
//  EVNotificationSetting.h
//  Evenly
//
//  Created by Joseph Hankin on 5/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVObject.h"

@interface EVNotificationSetting : EVObject

@property (nonatomic, strong) NSString *event;
@property (nonatomic) BOOL push;
@property (nonatomic) BOOL email;
@property (nonatomic) BOOL sms;

@end
