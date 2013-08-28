
/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import "ABContactsHelper.h"

#define CFAutorelease(obj) ({CFTypeRef _obj = (obj); (_obj == NULL) ? NULL : [(id)CFMakeCollectable(_obj) autorelease]; })

@implementation ABContactsHelper
/*
 Note: You cannot CFRelease the addressbook after CFAutorelease(ABAddressBookCreateWithOptions(NULL, NULL));
 */
+ (ABAddressBookRef) addressBook
{
	return CFAutorelease(ABAddressBookCreateWithOptions(NULL, NULL));
}

+ (NSArray *) contacts
{
    if (ABAddressBookRequestAccessWithCompletion != NULL &&
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        CFErrorRef myError = NULL;
        ABAddressBookRef myAddressBook = ABAddressBookCreateWithOptions(NULL, &myError);
        ABAddressBookRequestAccessCompletionHandler addrCompletionHandler = ^(bool granted, CFErrorRef error){CFRelease(myAddressBook);};
        ABAddressBookRequestAccessWithCompletion (myAddressBook, addrCompletionHandler);
    }
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreateWithOptions(NULL, NULL));
    CFArrayRef peopleRefs = ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSArray *thePeople = nil;
    if (peopleRefs){
        CFMutableArrayRef mutablePeopleRefs = CFArrayCreateMutableCopy(kCFAllocatorDefault, CFArrayGetCount(peopleRefs), peopleRefs);
        if (mutablePeopleRefs){
            
            //sort
            CFArraySortValues(mutablePeopleRefs, CFRangeMake(0, CFArrayGetCount(mutablePeopleRefs)), (CFComparatorFunction) ABPersonComparePeopleByName, (void*) ABPersonGetSortOrdering());
            thePeople = (NSArray *)mutablePeopleRefs;
//            result = arc_retain([self peopleForABRecordRefs:mutablePeopleRefs]);
//            CFAutorelease(mutablePeopleRefs);
            
        }
        
        CFRelease(peopleRefs);
        
    }
//	NSArray *thePeople = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:thePeople.count];
	for (id person in thePeople)
		[array addObject:[ABContact contactWithRecord:(ABRecordRef)person]];
	[thePeople release];
	return array;
}

+ (NSArray *)contactsMinusDuplicates
{
    NSArray *fullContactList = [self contacts];
    NSMutableArray *newList = [NSMutableArray arrayWithCapacity:0];
    NSMutableSet *nameSet = [NSMutableSet setWithCapacity:0];
    
    for (ABContact *contact in fullContactList) {
        NSString *fullNameString = [NSString stringWithFormat:@"%@ %@ %@", contact.firstname, contact.middlename, contact.lastname];
        if (![nameSet containsObject:fullNameString])
            [newList addObject:contact];
        [nameSet addObject:fullNameString];
    }
    return newList;
}

+ (int) contactsCount
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreateWithOptions(NULL, NULL));
	return ABAddressBookGetPersonCount(addressBook);
}

+ (int) contactsWithImageCount
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreateWithOptions(NULL, NULL));
	NSArray *peopleArray = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
	int ncount = 0;
	for (id person in peopleArray) if (ABPersonHasImageData(person)) ncount++;
	[peopleArray release];
	return ncount;
}

+ (int) contactsWithoutImageCount
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreateWithOptions(NULL, NULL));
	NSArray *peopleArray = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
	int ncount = 0;
	for (id person in peopleArray) if (!ABPersonHasImageData(person)) ncount++;
	[peopleArray release];
	return ncount;
}

// Groups
+ (int) numberOfGroups
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreateWithOptions(NULL, NULL));
	NSArray *groups = (NSArray *)ABAddressBookCopyArrayOfAllGroups(addressBook);
	int ncount = groups.count;
	[groups release];
	return ncount;
}

+ (NSArray *) groups
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreateWithOptions(NULL, NULL));
	NSArray *groups = (NSArray *)ABAddressBookCopyArrayOfAllGroups(addressBook);
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:groups.count];
	for (id group in groups)
		[array addObject:[ABGroup groupWithRecord:(ABRecordRef)group]];
	[groups release];
	return array;
}

// Sorting
//+ (BOOL) firstNameSorting
//{
//	return (ABPersonGetCompositeNameFormat() == kABPersonCompositeNameFormatFirstNameFirst);
//}

#pragma mark Contact Management

// Thanks to Eridius for suggestions re: error
+ (BOOL) addContact: (ABContact *) aContact withError: (NSError **) error
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreateWithOptions(NULL, NULL));
	if (!ABAddressBookAddRecord(addressBook, aContact.record, (CFErrorRef *) error)) return NO;
	return ABAddressBookSave(addressBook, (CFErrorRef *) error);
}

+ (BOOL) addGroup: (ABGroup *) aGroup withError: (NSError **) error
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreateWithOptions(NULL, NULL));
	if (!ABAddressBookAddRecord(addressBook, aGroup.record, (CFErrorRef *) error)) return NO;
	return ABAddressBookSave(addressBook, (CFErrorRef *) error);
}

+ (NSArray *) contactsMatchingName: (NSString *) fname
{
	NSPredicate *pred;
	NSArray *contacts = [ABContactsHelper contacts];
	pred = [NSPredicate predicateWithFormat:@"firstname contains[cd] %@ OR lastname contains[cd] %@ OR nickname contains[cd] %@ OR middlename contains[cd] %@", fname, fname, fname, fname];
	return [contacts filteredArrayUsingPredicate:pred];
}

+ (NSArray *) contactsMatchingName: (NSString *) fname andName: (NSString *) lname
{
	NSPredicate *pred;
	NSArray *contacts = [ABContactsHelper contacts];
	pred = [NSPredicate predicateWithFormat:@"firstname contains[cd] %@ OR lastname contains[cd] %@ OR nickname contains[cd] %@ OR middlename contains[cd] %@", fname, fname, fname, fname];
	contacts = [contacts filteredArrayUsingPredicate:pred];
	pred = [NSPredicate predicateWithFormat:@"firstname contains[cd] %@ OR lastname contains[cd] %@ OR nickname contains[cd] %@ OR middlename contains[cd] %@", lname, lname, lname, lname];
	contacts = [contacts filteredArrayUsingPredicate:pred];
	return contacts;
}

+ (NSArray *) contactsMatchingPhone: (NSString *) number
{
	NSPredicate *pred;
	NSArray *contacts = [ABContactsHelper contacts];
	pred = [NSPredicate predicateWithFormat:@"phonenumbers contains[cd] %@", number];
	return [contacts filteredArrayUsingPredicate:pred];
}

+ (NSArray *) groupsMatchingName: (NSString *) fname
{
	NSPredicate *pred;
	NSArray *groups = [ABContactsHelper groups];
	pred = [NSPredicate predicateWithFormat:@"name contains[cd] %@ ", fname];
	return [groups filteredArrayUsingPredicate:pred];
}

@end