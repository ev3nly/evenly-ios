//
//  EVLike.m
//  Evenly
//
//  Created by Joseph Hankin on 7/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVLike.h"

@implementation EVLike

- (void)setProperties:(NSDictionary *)properties {
    [super setProperties:properties];
    
    if (properties[@"liker"] && ![properties[@"liker"] isKindOfClass:[NSNull class]])
        self.liker = [[EVUser alloc] initWithDictionary:properties[@"liker"]];
}

@end
