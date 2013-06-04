//
//  EVStringUtility.h
//  Evenly
//
//  Created by Joseph Hankin on 4/2/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVUser.h"

@class  EVExchange,
        EVPayment,
        EVCharge,
        EVGroupCharge,
        EVWithdrawal;

@interface EVStringUtility : NSObject

+ (NSArray *)attributedStringsForObject:(EVObject *)object;
+ (NSArray *)attributedStringsForExchange:(EVExchange *)exchange;
+ (NSArray *)attributedStringsForGroupCharge:(EVGroupCharge *)groupCharge;
+ (NSArray *)attributedStringsForWithdrawal:(EVWithdrawal *)withdrawal;
+ (NSString *)amountStringForAmount:(NSDecimalNumber *)amount;
+ (NSString *)userNameForObject:(EVObject<EVExchangeable> *)object;

+ (NSDateFormatter *)detailDateFormatter;
+ (NSString *)nameForDetailField:(EVTransactionDetailField)field;
+ (NSString *)detailStringFromDate:(NSDate *)date;

#pragma mark - Marketing Materials

+ (NSString *)appName;
+ (NSString *)tagline;

#pragma mark - Contact Methods

+ (NSString *)supportEmail;
+ (NSString *)supportEmailSubjectLine;
+ (NSString *)feedbackEmail;
+ (NSString *)generalEmail;

#pragma mark - Error Messaging

+ (NSString *)serverMaintenanceError;

@end
