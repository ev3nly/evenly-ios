//
//  ABContactsHelper+EVAdditions.h
//  Evenly
//
//  Created by Joseph Hankin on 8/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "ABContactsHelper.h"

@interface ABContactsHelper (EVAdditions)

+ (NSArray *)autocompletableContacts;
+ (NSArray *)autocompletableContactsMatchingName:(NSString *)name;

+ (NSArray *)contactsWithEmail;
+ (NSArray *)contactsWithEmailMatchingName:(NSString *)name;

@end
