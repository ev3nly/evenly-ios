//
//  EVStringUtility.m
//  Evenly
//
//  Created by Joseph Hankin on 4/2/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVStringUtility.h"
#import "EVExchange.h"
#import "EVWithdrawal.h"
#import "EVPayment.h"
#import "EVRequest.h"
#import "EVGroupRequest.h"
#import "ABContact.h"
#import <DTCoreText/DTCoreText.h>

@interface EVStringUtility (private)

+ (NSMutableAttributedString *)attributedStringForDateString:(NSString *)dateString
                                                amountString:(NSString *)amountString
                                                 amountColor:(UIColor *)amountColor;

+ (NSMutableAttributedString *)attributedStringForSubject:(NSString *)subject
                                                     verb:(NSString *)verb
                                                   object:(NSString *)object
                                              preposition:(NSString *)preposition;
+ (NSDateFormatter *)shortDateFormatter;

@end

@implementation EVStringUtility

static NSDateFormatter *_shortDateFormatter;

+ (NSDateFormatter *)shortDateFormatter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shortDateFormatter = [[NSDateFormatter alloc] init];
        _shortDateFormatter.dateFormat = @"MMM\u00A0d";
    });
    return _shortDateFormatter;
}

#pragma mark - Interaction Strings

+ (NSString *)stringForInteraction:(EVObject *)interaction {
    if ([interaction isKindOfClass:[EVExchange class]])
        return [self stringForExchange:(EVExchange *)interaction];
    else if ([interaction isKindOfClass:[EVGroupRequest class]])
        return [self stringForGroupRequest:(EVGroupRequest *)interaction];
    return nil;
}

#pragma mark - Exchanges

+ (NSString *)stringForExchange:(EVExchange *)exchange {
    
    NSDictionary *components = [self subjectVerbAndObjectForExchange:exchange];
    NSString *string = [NSString stringWithFormat:@"%@ %@ %@ %@ for %@\n%@",
                        components[@"subject"],
                        components[@"verb"],
                        components[@"object"],
                        [self amountStringForAmount:exchange.amount],
                        exchange.memo,
                        [[self shortDateFormatter] stringFromDate:exchange.createdAt]];
    return string;
}

+ (NSDictionary *)subjectVerbAndObjectForExchange:(EVExchange *)exchange {
    NSString *subject;
    NSString *object;
    NSString *verb;
    
    if ([exchange isKindOfClass:[EVPayment class]]) {
        verb = @"paid";
        if (exchange.from == nil) {
            subject = @"You";
            object = exchange.to.name;
        } else { // to = nil
            subject = exchange.from.name;
            object = @"You";
        }
    } else {
        if (exchange.from == nil) {
            subject = exchange.to.name;
            verb = @"owes";
            object = @"You";
        } else { // to = nil
            subject = @"You";
            verb = @"owe";
            object = exchange.from.name;
        }
    }
    return @{ @"subject" : subject, @"verb" : verb, @"object" : object };
}

+ (NSString *)stringForPrivacySetting:(EVPrivacySetting)privacySetting {
    if (privacySetting == EVPrivacySettingFriends)
        return @"friends";
    else if (privacySetting == EVPrivacySettingNetwork)
        return @"network";
    return @"private";
}

+ (NSAttributedString *)attributedStringForPendingExchange:(EVExchange *)exchange {
    NSDictionary *components = [self subjectVerbAndObjectForPendingExchange:exchange];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    NSDictionary *boldAttributes = @{ NSFontAttributeName : [EVFont boldFontOfSize:14],
                                      NSForegroundColorAttributeName : [EVColor darkColor] };
    NSDictionary *regularAttributes = @{ NSFontAttributeName : [EVFont defaultFontOfSize:14],
                                         NSForegroundColorAttributeName : [EVColor darkColor] };
    
    NSAttributedString *space = [[NSAttributedString alloc] initWithString:@" " attributes:regularAttributes];
    
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:components[@"subject"]
                                                                       attributes:[components[@"subject"] isEqualToString:@"You"] ? regularAttributes : boldAttributes]];
    [attrString appendAttributedString:space];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:components[@"verb"]
                                                                       attributes:regularAttributes]];
    [attrString appendAttributedString:space];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:components[@"object"]
                                                                       attributes:[components[@"object"] isEqualToString:@"You"] ? regularAttributes : boldAttributes]];
    return attrString;
}

+ (NSDictionary *)subjectVerbAndObjectForPendingExchange:(EVExchange *)exchange {
    NSDictionary *dictionary = [self subjectVerbAndObjectForExchange:exchange];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    NSString *key, *value;
    if ([mutableDict[@"subject"] isEqualToString:@"You"]) {
        key = @"object";
    } else {
        key = @"subject";
    }
    value = mutableDict[key];
    mutableDict[key] = [self firstNameAndInitialFromString:value];
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

+ (NSString *)firstNameAndInitialFromString:(NSString *)string {
    NSString *outString = string;
    NSMutableArray *components = [NSMutableArray arrayWithArray:[string componentsSeparatedByString:@" "]];
    if ([components count] > 1) {
        NSString *lastName = [components lastObject];
        if ([lastName length] > 0)
            lastName = [lastName substringToIndex:1];
        [components replaceObjectAtIndex:[components count] - 1 withObject:lastName];
        outString = [components componentsJoinedByString:@" "];
    }
    return outString;
}

#pragma mark - Group Requests

+ (NSAttributedString *)attributedStringForGroupRequest:(EVGroupRequest *)groupRequest {
    NSDictionary *components = [self subjectVerbAndObjectForGroupRequest:groupRequest];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    NSDictionary *boldAttributes = @{ NSFontAttributeName : [EVFont boldFontOfSize:14],
                                      NSForegroundColorAttributeName : [EVColor darkColor] };
    NSDictionary *regularAttributes = @{ NSFontAttributeName : [EVFont defaultFontOfSize:14],
                                         NSForegroundColorAttributeName : [EVColor darkColor] };
    
    NSAttributedString *space = [[NSAttributedString alloc] initWithString:@" " attributes:regularAttributes];
    
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:components[@"subject"]
                                                                       attributes:[components[@"subject"] isEqualToString:@"You"] ? regularAttributes : boldAttributes]];
    [attrString appendAttributedString:space];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:components[@"verb"]
                                                                       attributes:regularAttributes]];
    [attrString appendAttributedString:space];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:components[@"object"]
                                                                       attributes:[components[@"object"] isEqualToString:@"You"] ? regularAttributes : boldAttributes]];
    return attrString;
}

+ (NSString *)stringForGroupRequest:(EVGroupRequest *)groupRequest {
    NSDictionary *components = [self subjectVerbAndObjectForGroupRequest:groupRequest];
    NSString *string = [NSString stringWithFormat:@"%@ %@ %@ for %@\u00A0\u00A0\u00A0•\u00A0\u00A0\u00A0%@",
                        components[@"subject"],
                        components[@"verb"],
                        components[@"object"],
                        groupRequest.title,
                        [[self shortDateFormatter] stringFromDate:groupRequest.createdAt]];
    return string;
}

+ (NSDictionary *)subjectVerbAndObjectForGroupRequest:(EVGroupRequest *)groupRequest {
    NSString *subject;
    NSString *object;
    NSString *verb;
    if (groupRequest.from == nil) {
        subject = [self stringForNumberOfPeople:[groupRequest.records count]];
        object = @"You";
        verb = ([groupRequest.records count] == 1 ? @"owes" : @"owe");
    } else {
        subject = @"You";
        object = [self firstNameAndInitialFromString:groupRequest.from.name];
        
        verb = @"owe";
    }
    return @{ @"subject" : subject, @"verb" : verb, @"object" : object };
}

+ (NSString *)stringForNumberOfPeople:(NSInteger)numberOfPeople {
    if (numberOfPeople == 1) {
        return @"1 person";
    }
    return [NSString stringWithFormat:@"%d people", numberOfPeople];
}

static NSDateFormatter *_detailDateFormatter;

+ (NSDateFormatter *)detailDateFormatter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _detailDateFormatter = [[NSDateFormatter alloc] init];
        _detailDateFormatter.dateFormat = @"h:mm a 'on' MMM d, YYYY";
    });
    return _detailDateFormatter;
}

+ (NSString *)nameForDetailField:(EVExchangeDetailField)field {
    NSString *name = nil;
    switch (field) {
        case EVExchangeDetailFieldFrom:
            name = @"From:";
            break;
        case EVExchangeDetailFieldTo:
            name = @"To:";
            break;
        case EVExchangeDetailFieldAmount:
            name = @"Amount:";
            break;
        case EVExchangeDetailFieldNote:
            name = @"Note:";
            break;
        case EVExchangeDetailFieldDate:
            name = @"Date:";
            break;
        default:
            break;
    }
    return name;
}

+ (NSString *)detailStringFromDate:(NSDate *)date {
    return [[self detailDateFormatter] stringFromDate:date];
}

+ (NSString *)toFieldPlaceholder {
    return @"Name, email, or phone number";
}

+ (NSString *)groupToFieldPlaceholder {
    return @"Add at least 2 friends";
}

+ (NSString *)requestDescriptionPlaceholder {
    return @"What'd you share?\n(e.g. gas, rent or anything else)";
}

+ (NSString *)groupRequestTitlePlaceholder {
    return @"What'd you share?";
}

+ (NSString *)groupRequestDescriptionPlaceholder {
   return @"Add any additional details.";
}

+ (NSString *)tipDescriptionPlaceholder {
    return @"Add a personal note...";
}

+ (NSString *)displayStringForPhoneNumber:(NSString *)phoneNumber {
    if (phoneNumber.length == 11)
        phoneNumber = [phoneNumber substringFromIndex:1];
    if (phoneNumber.length == 10) {
        NSString *areaCode = [phoneNumber substringWithRange:NSMakeRange(0, 3)];
        NSString *firstThree = [phoneNumber substringWithRange:NSMakeRange(3, 3)];
        NSString *lastFour = [phoneNumber substringWithRange:NSMakeRange(6, 4)];
        return [NSString stringWithFormat:@"(%@) %@-%@", areaCode, firstThree, lastFour];
    }
    return phoneNumber;
}

+ (NSString *)strippedPhoneNumber:(NSString *)phoneNumber {
    NSArray *components = [phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
    NSString *newNumber = [components componentsJoinedByString:@""];
    if (newNumber.length == 11)
        newNumber = [newNumber substringFromIndex:1];
    return newNumber;
}

#pragma mark - Contacts

+ (NSString *)displayNameForContact:(ABContact *)contact {
    NSString *name = @"";
    if (!EV_IS_EMPTY_STRING(contact.firstname))
        name = [contact.firstname stringByAppendingString:@" "];
    if (!EV_IS_EMPTY_STRING(contact.lastname))
        name = [name stringByAppendingString:contact.lastname];
    if (EV_IS_EMPTY_STRING(name) && !EV_IS_EMPTY_STRING([contact organization]))
        name = [contact organization];
    return name;
}

+ (NSString *)addHyphensToPhoneNumber:(NSString *)phoneNumber {
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (phoneNumber.length > 10)
        phoneNumber = [phoneNumber substringToIndex:10];
    if (phoneNumber.length > 6) {
        NSString *firstThree = [phoneNumber substringWithRange:NSMakeRange(0, 3)];
        NSString *nextThree = [phoneNumber substringWithRange:NSMakeRange(3, 3)];
        NSString *rest = [phoneNumber substringFromIndex:6];
        phoneNumber = [NSString stringWithFormat:@"%@-%@-%@", firstThree, nextThree, rest];
    } else if (phoneNumber.length > 3) {
        NSString *firstThree = [phoneNumber substringWithRange:NSMakeRange(0, 3)];
        NSString *rest = [phoneNumber substringFromIndex:3];
        phoneNumber = [NSString stringWithFormat:@"%@-%@", firstThree, rest];
    }
    return phoneNumber;
}

#pragma mark - Marketing Materials

+ (NSString *)appName {
    return @"Evenly";
}

+ (NSString *)tagline {
    return @"Free & Simple Payments";
}

#pragma mark - Contact Methods

+ (NSString *)supportEmail {
    return @"support@evenly.com";
}

+ (NSString *)supportEmailSubjectLine {
    return @"Evenly Help";
}

+ (NSString *)feedbackEmail {
    return @"feedback@evenly.com";
}

+ (NSString *)generalEmail {
    return @"info@evenly.com";
}

+ (NSString *)supportTwitterHandle {
    return @"@EvenlySupport";
}

+ (NSURL *)faqURL {
    return [NSURL URLWithString:@"http://help.evenly.com"];
}


#pragma mark - Error Messaging

+ (NSString *)serverMaintenanceError {
    return @"Sorry about this -- we're temporarily down for server maintenance.  Please try again soon.";
}

#pragma mark - File Naming

+ (NSString *)cachePathFromURL:(NSURL *)url {
    return [self cachePathFromURL:url size:CGSizeZero];
}

+ (NSString *)cachePathFromURL:(NSURL *)url size:(CGSize)size {
    NSString *hashedURL = EV_STRING_FROM_INT([url hash]);
    NSString *cachePath = EV_CACHE_PATH(hashedURL);
    return [NSString stringWithFormat:@"%@-%f-%f", cachePath, size.width, size.height];
}

#pragma mark - Amounts


+ (NSString *)amountStringForAmount:(NSDecimalNumber *)amount {
    if (!amount || [amount isEqualToNumber:[NSDecimalNumber zero]])
        return @"$0.00";
    return [NSNumberFormatter localizedStringFromNumber:amount
                                            numberStyle:NSNumberFormatterCurrencyStyle];
}

+ (NSDecimalNumber *)amountFromAmountString:(NSString *)amountString {
    if (EV_IS_EMPTY_STRING(amountString))
        return [NSDecimalNumber zero];
    return [NSDecimalNumber decimalNumberWithString:[amountString stringByReplacingOccurrencesOfString:@"$"
                                                                                            withString:@""]];
}

+ (NSString *)inviteAmountStringForNumberOfInvitees:(NSInteger)numberOfPeople {
    NSInteger potentialDollars = (numberOfPeople / EV_INVITES_NEEDED_FOR_PRIZE) * EV_DOLLARS_PER_PRIZE;
    NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:EV_STRING_FROM_INT(potentialDollars)];
    NSString *amountString = [self amountStringForAmount:number];
    amountString = [amountString substringToIndex:amountString.length - 3]; // truncate ".00" from end
    return amountString;
}

#pragma mark - General

+ (NSString *)onString {
    return @"On";
}

+ (NSString *)offString {
    return @"Off";
}


#pragma mark - Instructions

+ (NSString *)groupRequestCreationInstructions {
    return @"You can add friends now or skip this step and do it later.";
}

+ (NSAttributedString *)groupRequestDashboardInstructions {
    NSDictionary *boldAttributes = @{ NSFontAttributeName : [EVFont boldFontOfSize:14],
                                      NSForegroundColorAttributeName : [UIColor whiteColor],
                                      NSKernAttributeName : @(-0.1) };
    NSDictionary *regularAttributes = @{ NSFontAttributeName : [EVFont defaultFontOfSize:14],
                                         NSForegroundColorAttributeName : [UIColor whiteColor],
                                         NSKernAttributeName : @(-0.1) };
    
    NSString *firstLine = @"Thanks for making your first group request!\n\n";
    NSString *secondLine = @"Whenever you request money from multiple people, Evenly creates this simple dashboard.  From here, you can send invitations and reminders, track progress, and much more.\n\n";
    NSString *thirdLine = @"Give it a spin!";
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@""];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:firstLine attributes:boldAttributes]];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:secondLine attributes:regularAttributes]];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:thirdLine attributes:boldAttributes]];

    return attrString;
}


#pragma mark - Request

+ (NSString *)addAdditionalOptionButtonTitle {
    return @"ADD ANOTHER PAYMENT OPTION";
}

+ (NSString *)noRecipientsErrorMessage {
    return @"Oops. Add a person before advancing. Thanks!";
}

+ (NSString *)notEnoughRecipientsErrorMessage {
    return @"Oops. Add another person to your group. Thanks!";
}

+ (NSString *)missingAmountErrorMessage {
    return @"You're missing at least one amount.";
}

+ (NSString *)assignFriendsErrorMessage {
    return @"You need to assign amounts to\nall your friends before proceeding.";
}

+ (NSString *)minimumRequestErrorMessage {
    return @"You have to request at least $0.50.";
}

+ (NSString *)multiAmountInfoMessage {
    return @"Please assign your friends a payment amount.";
}

#pragma mark - Password Reset

+ (NSString *)confirmResetForEmail:(NSString *)email {
    return [NSString stringWithFormat:@"Would you like to reset the password for %@?", email];
}

+ (NSString *)resetSuccessMessage {
    return @"OK! Check your email for instructions on resetting the password to your account.";
}

+ (NSString *)resetFailureMessageGivenError:(NSError *)error {
    return @"Sorry, there was an issue! Please try again.";
}

#pragma mark - Profile

+ (NSString *)noActivityMessageForSelf {
    return @"No Evenly activity yet. Today's a great day to send your first payment or request.";
}

+ (NSString *)noActivityMessageForOthers {
    return @"No Evenly activity yet. Tap above and show them how it's done.";
}

#pragma mark - PIN

+ (NSString *)wouldYouLikeToSetPINPrompt {
    return @"Would you like to set a PIN to protect your Evenly wallet? You can always set it later in settings.";
}

#pragma mark - HTML Processing


+ (NSAttributedString *)attributedStringWithHTML:(NSString *)html {
    return [self _attributedStringWithHTML:html className:@"NSAttributedString"];
}

+ (NSMutableAttributedString *)mutableAttributedStringWithHTML:(NSString *)html {
    return [self _attributedStringWithHTML:html className:@"NSMutableAttributedString"];
}

static DTCSSStylesheet *_stylesheet;

+ (id)_attributedStringWithHTML:(NSString *)html className:(NSString *)className {
    if (!_stylesheet) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _stylesheet = [[DTCSSStylesheet alloc] initWithStyleBlock:@" strong { color: #282726;  font-family: Avenir; font-weight: bold; } "];
        });
    }
    NSDictionary *options = @{ DTDefaultFontFamily : @"Avenir",
                               DTDefaultFontSize : @(15),
                               DTDefaultTextColor : [EVColor newsfeedTextColor],
                               DTUseiOS6Attributes : @(YES),
                               DTDefaultStyleSheet : _stylesheet,
                               DTDefaultTextAlignment : @(kCTCenterTextAlignment) };
    return [[NSClassFromString(className) alloc] initWithHTMLData:[html dataUsingEncoding:NSUTF8StringEncoding]
                                                          options:options
                                               documentAttributes:nil];    
}

@end
