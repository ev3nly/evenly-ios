//
//  EVNotificationSetting.m
//  Evenly
//
//  Created by Joseph Hankin on 5/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVNotificationSetting.h"

@implementation EVNotificationSetting

+ (NSString *)controllerName {
    return @"me/notifications";
}

- (void)setProperties:(NSDictionary *)properties {
    [super setProperties:properties];
    
    self.event = [properties objectForKey:@"event"];
    self.push = [[properties objectForKey:@"push"] boolValue];
    self.email = [[properties objectForKey:@"email"] boolValue];
    self.sms = [[properties objectForKey:@"sms"] boolValue];
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
                 @"event":      self.event,
                 @"push":       @(self.push),
                 @"email":      @(self.email),
                 @"sms":        @(self.sms)
             };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<0x%x> %@ notification setting: Push? %@  Email? %@  SMS? %@",
            (int)self,
            self.event,
            (self.push ? @"YES" : @"NO"),
            (self.email ? @"YES" : @"NO"),
            (self.sms ? @"YES" : @"NO")];
}


@end
