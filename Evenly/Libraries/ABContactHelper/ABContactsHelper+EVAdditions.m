//
//  ABContactsHelper+EVAdditions.m
//  Evenly
//
//  Created by Joseph Hankin on 8/14/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "ABContactsHelper+EVAdditions.h"

@implementation ABContactsHelper (EVAdditions)

+ (NSArray *)autocompletableContacts {
    
    NSArray *contacts = [[ABContactsHelper contacts] filter:^BOOL(id object) {
        ABContact *contact = (ABContact *)object;
        if ([[contact phoneLabels] containsObject:(NSString *)kABPersonPhoneIPhoneLabel] ||
            [[contact phoneLabels] containsObject:(NSString *)kABPersonPhoneMobileLabel]) {
            return YES;
        }
        return [[contact emailArray] count] > 0;
    }];
    return contacts;
}

+ (NSArray *)autocompletableContactsMatchingName:(NSString *)name {
    NSPredicate *pred;
    NSArray *contacts = [self autocompletableContacts];
	pred = [NSPredicate predicateWithFormat:@"firstname BEGINSWITH[cd] %@ OR lastname BEGINSWITH[cd] %@ OR compositeName BEGINSWITH[cd] %@", name, name, name];
	return [contacts filteredArrayUsingPredicate:pred];
}

+ (NSArray *)contactsWithEmail {
    NSArray *contacts = [[ABContactsHelper contacts] filter:^BOOL(id object) {
        return [[(ABContact *)object emailArray] count] > 0;
    }];
    return contacts;
}

+ (NSArray *)contactsWithEmailMatchingName:(NSString *)name {
    NSPredicate *pred;
    NSArray *contacts = [self contactsWithEmail];
	pred = [NSPredicate predicateWithFormat:@"firstname BEGINSWITH[cd] %@ OR lastname BEGINSWITH[cd] %@ OR compositeName BEGINSWITH[cd] %@", name, name, name];
	return [contacts filteredArrayUsingPredicate:pred];
}

@end
