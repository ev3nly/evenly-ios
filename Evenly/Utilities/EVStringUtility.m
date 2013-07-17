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
    NSString *string = [NSString stringWithFormat:@"%@ %@ %@ %@ for %@\u00A0\u00A0\u00A0•\u00A0\u00A0\u00A0%@",
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

#pragma mark - Group Requests

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
        object = groupRequest.from.name;
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

+ (NSArray *)attributedStringsForObject:(EVObject *)object {
	if ([object isKindOfClass:[EVExchange class]])
		return [self attributedStringsForExchange:(EVExchange *)object];
	else if ([object isKindOfClass:[EVWithdrawal class]])
		return [self attributedStringsForWithdrawal:(EVWithdrawal *)object];
	
	return nil;
}

+ (NSArray *)attributedStringsForExchange:(EVExchange *)exchange {
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *subject;
    NSString *object;
    NSString *verb;
    NSString *description = exchange.memo;
    NSString *amount = [self amountStringForAmount:exchange.amount];
    
    UIColor *amountColor = [UIColor blackColor]; // ([exchange isIncoming] ? [EVColor incomingColor] : [EVColor outgoingColor]);
    
    NSString *date = [[self shortDateFormatter] stringFromDate:exchange.createdAt];
    
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
    
    [array addObject:[self attributedStringForSubject:subject verb:verb object:object preposition:@"for"]];
    [array addObject:[[NSMutableAttributedString alloc] initWithString:description]];
    [array addObject:[self attributedStringForDateString:date amountString:amount amountColor:amountColor]];
    return array;
}

+ (NSArray *)attributedStringsForWithdrawal:(EVWithdrawal *)withdrawal {
    NSString *amount = [self amountStringForAmount:withdrawal.amount];
    NSString *date = [[self shortDateFormatter] stringFromDate:withdrawal.createdAt];

    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[self attributedStringForSubject:@"You" verb:@"deposited into" object:@"" preposition:@""]];
    [array addObject:[self attributedStringForSubject:withdrawal.bankName verb:@"" object:@"" preposition:@""]];
    [array addObject:[self attributedStringForDateString:date amountString:amount amountColor:[UIColor blackColor] /* [EVColor withdrawalColor] */]];
    
    return array;
}

+ (NSMutableAttributedString *)attributedStringForSubject:(NSString *)subject
                                                     verb:(NSString *)verb
                                                   object:(NSString *)object
                                              preposition:(NSString *)preposition {
    
    if (subject == nil)
        subject = @"Unknown";
    if (object == nil)
        object = @"Unknown";
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:subject
                                                                       attributes:@{ NSFontAttributeName : [UIFont boldSystemFontOfSize:12] }]];
    NSString *format = @" %@ ";
    if (EV_IS_EMPTY_STRING(subject))
        format = @"%@ ";
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:format, verb]
                                                                       attributes:@{ NSFontAttributeName : [EVFont defaultFontOfSize:14] }]];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:object
                                                                       attributes:@{ NSFontAttributeName : [EVFont boldFontOfSize:14] }]];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", preposition]
                                                                       attributes:@{ NSFontAttributeName : [EVFont defaultFontOfSize:14] }]];
    return attrString;
}

+ (NSMutableAttributedString *)attributedStringForDateString:(NSString *)dateString
                                                amountString:(NSString *)amountString
                                                 amountColor:(UIColor *)amountColor {
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   •   ", dateString]
                                                                       attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12] }]];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:amountString
                                                                       attributes:@{ NSFontAttributeName : [UIFont boldSystemFontOfSize:12],
                                                  NSForegroundColorAttributeName : amountColor}]];
    
    return attrString;
}

+ (NSString *)userNameForObject:(EVObject<EVExchangeable> *)object {
    if (EV_IS_EMPTY_STRING(object.name)) {
        return @"You";
    }
    return object.name;
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
    return @"Name, email, phone number";
}

+ (NSString *)requestDescriptionPlaceholder {
    return @"Lunch, dinner, taxi, or anything else";
}

+ (NSString *)groupRequestTitlePlaceholder {
    return @"BBQ, Sunday Dinner, or anything else";
}

+ (NSString *)groupRequestDescriptionPlaceholder {
   return @"Add any additional details.";
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

#pragma mark - Contacts

+ (NSString *)displayNameForContact:(ABContact *)contact {
    NSString *name = @"";
    if (!EV_IS_EMPTY_STRING(contact.firstname))
        name = [contact.firstname stringByAppendingString:@" "];
    if (!EV_IS_EMPTY_STRING(contact.lastname))
        name = [name stringByAppendingString:contact.lastname];
    return name;
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
    return @"support@paywithivy.com";
}

+ (NSString *)supportEmailSubjectLine {
    return @"Evenly Help";
}

+ (NSString *)feedbackEmail {
    return @"feedback@paywithivy.com";
}

+ (NSString *)generalEmail {
    return @"info@paywithivy.com";
}

#pragma mark - Error Messaging

+ (NSString *)serverMaintenanceError {
    return @"Sorry about this -- we're temporarily down for server maintenance.  Please try again soon.";
}

#pragma mark - File Naming

+ (NSString *)cachePathFromURL:(NSURL *)url {
    NSString *hashedURL = EV_STRING_FROM_INT([url hash]);
    NSString *cachePath = EV_CACHE_PATH(hashedURL);
    return cachePath;
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

#pragma mark - Password Reset

+ (NSString *)confirmResetForEmail:(NSString *)email {
    return [NSString stringWithFormat:@"Would you like to reset the password for %@?", email];
}

+ (NSString *)resetSuccessMessage {
    return @"Alright! Check your email for instructions on resetting the password to your account";
}

+ (NSString *)resetFailureMessageGivenError:(NSError *)error {
    return @"Sorry, there was an issue! Please try again";
}

@end
