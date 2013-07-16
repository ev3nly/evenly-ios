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
        EVRequest,
        EVGroupRequest,
        EVWithdrawal,
        ABContact;

@interface EVStringUtility : NSObject

+ (NSString *)stringForInteraction:(EVObject *)interaction;
+ (NSString *)stringForExchange:(EVExchange *)exchange;
+ (NSString *)stringForGroupRequest:(EVGroupRequest *)groupRequest;

+ (NSString *)stringForNumberOfPeople:(NSInteger)numberOfPeople;

+ (NSDictionary *)subjectVerbAndObjectForExchange:(EVExchange *)exchange;

+ (NSArray *)attributedStringsForObject:(EVObject *)object;
+ (NSArray *)attributedStringsForExchange:(EVExchange *)exchange;
+ (NSArray *)attributedStringsForWithdrawal:(EVWithdrawal *)withdrawal;
+ (NSString *)userNameForObject:(EVObject<EVExchangeable> *)object;

+ (NSDateFormatter *)detailDateFormatter;
+ (NSString *)nameForDetailField:(EVExchangeDetailField)field;
+ (NSString *)detailStringFromDate:(NSDate *)date;

+ (NSString *)toFieldPlaceholder;
+ (NSString *)requestDescriptionPlaceholder;
+ (NSString *)groupRequestTitlePlaceholder;
+ (NSString *)groupRequestDescriptionPlaceholder;

+ (NSString *)displayStringForPhoneNumber:(NSString *)phoneNumber;

#pragma mark - Contacts

+ (NSString *)displayNameForContact:(ABContact *)contact;

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

#pragma mark - File Naming

+ (NSString *)cachePathFromURL:(NSURL *)url;

#pragma mark - Amounts
+ (NSString *)amountStringForAmount:(NSDecimalNumber *)amount;
+ (NSDecimalNumber *)amountFromAmountString:(NSString *)amountString;

#pragma mark - General

+ (NSString *)onString;
+ (NSString *)offString;

#pragma mark - Instructions

+ (NSString *)groupRequestCreationInstructions;
+ (NSAttributedString *)groupRequestDashboardInstructions;

#pragma mark - Request

+ (NSString *)addAdditionalOptionButtonTitle;

@end
