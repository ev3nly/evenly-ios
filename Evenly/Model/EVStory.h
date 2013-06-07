//
//  EVStory.h
//  Evenly
//
//  Created by Joseph Hankin on 6/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVObject.h"

@interface EVStory : EVObject

@property (nonatomic, strong) id subject;
@property (nonatomic, strong) NSString *verb;
@property (nonatomic, strong) id target;
@property (nonatomic, strong) NSString *storyDescription;
@property (nonatomic, strong) NSDecimalNumber *amount;
@property (nonatomic, assign) BOOL isPrivate;
@property (nonatomic, strong) id owner;
@property (nonatomic, strong) id source;

@end
