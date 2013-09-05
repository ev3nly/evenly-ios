//
//  EVInviteActivityItem.h
//  Evenly
//
//  Created by Joseph Hankin on 9/4/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVInviteActivityItem : NSObject<UIActivityItemSource>

@property (nonatomic, strong) NSURL *url;

- (id)initWithURL:(NSURL *)url;

@end
