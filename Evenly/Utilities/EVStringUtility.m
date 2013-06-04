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
#import "EVCharge.h"
#import "EVGroupCharge.h"

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
        _shortDateFormatter.dateFormat = @"MMM d";
    });
    return _shortDateFormatter;
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

+ (NSArray *)attributedStringsForGroupCharge:(EVGroupCharge *)groupCharge {
    if (groupCharge.from != nil)
        return [self attributedStringsForExchange:groupCharge];
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[[NSAttributedString alloc] initWithString:groupCharge.memo]];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Group charge to "
                                                                       attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12] }]];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:[groupCharge originalDictionary][@"to"] 
                                                                       attributes:@{ NSFontAttributeName : [UIFont boldSystemFontOfSize:12] }]];
    [array addObject:attrString];
    NSString *amount = [NSString stringWithFormat:@"%@/pp", [self amountStringForAmount:groupCharge.amount]];
    NSString *date = [[self shortDateFormatter] stringFromDate:groupCharge.createdAt];
    [array addObject:[self attributedStringForDateString:date amountString:amount amountColor:[UIColor blackColor] /* [EVColor incomingColor] */]];
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
                                                                       attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12] }]];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:object
                                                                       attributes:@{ NSFontAttributeName : [UIFont boldSystemFontOfSize:12] }]];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", preposition]
                                                                       attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12] }]];
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

+ (NSString *)amountStringForAmount:(NSDecimalNumber *)amount {
    return [NSNumberFormatter localizedStringFromNumber:amount
                                            numberStyle:NSNumberFormatterCurrencyStyle];
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

+ (NSString *)nameForDetailField:(EVTransactionDetailField)field {
    NSString *name = nil;
    switch (field) {
        case EVTransactionDetailFieldFrom:
            name = @"From:";
            break;
        case EVTransactionDetailFieldTo:
            name = @"To:";
            break;
        case EVTransactionDetailFieldAmount:
            name = @"Amount:";
            break;
        case EVTransactionDetailFieldNote:
            name = @"Note:";
            break;
        case EVTransactionDetailFieldDate:
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



@end