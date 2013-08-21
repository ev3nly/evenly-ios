//
//  EVConnection.m
//  Evenly
//
//  Created by Joseph Hankin on 6/30/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVConnection.h"
#import "EVSerializer.h"

@implementation EVConnection

- (void)setProperties:(NSDictionary *)properties {
    [super setProperties:properties];
    
    self.strength = [properties[@"strength"] intValue];
    self.user = (EVUser *)[EVSerializer serializeDictionary:properties[@"friend"]];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Connection: %@ (strength: %d)", self.user.name, self.strength];
}
@end
