//
//  EVInviteActivityItem.m
//  Evenly
//
//  Created by Joseph Hankin on 9/4/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVInviteActivityItem.h"

@implementation EVInviteActivityItem

- (id)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    if ([activityType isEqualToString:UIActivityTypeCopyToPasteboard])
        return self.url;
    return [NSString stringWithFormat:@"Join me on Evenly! Sign up with this link and we both get free money! %@", [self.url absoluteString]];
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return self.url;
}

@end
