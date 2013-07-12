//
//  EVStory.m
//  Evenly
//
//  Created by Joseph Hankin on 6/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVStory.h"
#import "EVUser.h"
#import "EVPayment.h"
#import "EVRequest.h"
#import "EVWithdrawal.h"
#import "EVGroupRequest.h"

NSString *const EVStoryLocallyCreatedNotification = @"EVStoryLocallyCreatedNotification";

@interface EVStory ()

@property (nonatomic, assign) EVStoryType storyType;

@end

@implementation EVStory

+ (EVStory *)storyFromPendingExchange:(EVExchange *)exchange {
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    
    setValueForKeyIfNonNil(@"requested", @"verb")
    setValueForKeyIfNonNil(exchange.memo, @"description")
    setValueForKeyIfNonNil(exchange.createdAt, @"published_at")
    setValueForKeyIfNonNil(exchange.amount, @"amount")
    setValueForKeyIfNonNil((exchange.from ?: [EVCIA me]), @"subject")
    setValueForKeyIfNonNil((exchange.to ?: [EVCIA me]), @"target")
    setValueForKeyIfNonNil(@"User", @"owner_type")
    setValueForKeyIfNonNil([EVCIA me].dbid, @"owner_id")
    
    EVStory *story = [EVStory new];
    [story setProperties:mutableDictionary];
    story.displayType = EVStoryDisplayTypePendingTransactionDetail;
    return story;
}

+ (EVStory *)storyFromCompletedExchange:(EVExchange *)exchange {
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    EVObject *fromUser = exchange.from ? exchange.from : [EVCIA me];
    EVObject *toUser = exchange.to ? exchange.to : [EVCIA me];
    NSString *verb = [exchange isKindOfClass:[EVPayment class]] ? @"paid" : @"charged";
        
    setValueForKeyIfNonNil(verb, @"verb")
    setValueForKeyIfNonNil(exchange.memo, @"description")
    setValueForKeyIfNonNil(exchange.createdAt, @"published_at")
    setValueForKeyIfNonNil(exchange.amount, @"amount")
    setValueForKeyIfNonNil(fromUser, @"subject")
    setValueForKeyIfNonNil(toUser, @"target")
    setValueForKeyIfNonNil(@"User", @"owner_type")
    setValueForKeyIfNonNil(fromUser.dbid, @"owner_id")
    
    EVStory *story = [EVStory new];
    [story setProperties:mutableDictionary];
    story.displayType = EVStoryDisplayTypeCompletedTransactionDetail;
    return story;
}

+ (EVStory *)storyFromGroupRequest:(EVGroupRequest *)groupRequest {
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    
    setValueForKeyIfNonNil(@"requested", @"verb")
    setValueForKeyIfNonNil(groupRequest.title, @"description")
    setValueForKeyIfNonNil(groupRequest.createdAt, @"published_at")
    setValueForKeyIfNonNil((groupRequest.from ?: [EVCIA me]), @"subject")
    setValueForKeyIfNonNil(@"User", @"owner_type")
    setValueForKeyIfNonNil([EVCIA me].dbid, @"owner_id")
    
    EVStory *story = [EVStory new];
    [story setProperties:mutableDictionary];
    story.displayType = EVStoryDisplayTypePendingTransactionDetail;
    return story;
}

+ (EVStory *)storyFromWithdrawal:(EVWithdrawal *)withdrawal {
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    EVObject *fromUser = [EVCIA me];
    NSString *verb = @"withdrew";
    
    setValueForKeyIfNonNil(verb, @"verb")
    setValueForKeyIfNonNil(withdrawal.bankName, @"description")
    setValueForKeyIfNonNil(withdrawal.createdAt, @"published_at")
    setValueForKeyIfNonNil(withdrawal.amount, @"amount")
    setValueForKeyIfNonNil(fromUser, @"subject")
    setValueForKeyIfNonNil(@"User", @"owner_type")
    setValueForKeyIfNonNil(fromUser.dbid, @"owner_id")
    
    EVStory *story = [EVStory new];
    [story setProperties:mutableDictionary];
    story.displayType = EVStoryDisplayTypeCompletedTransactionDetail;
    return story;
}

+ (NSString *)verbFromExchange:(EVExchange *)exchange isPending:(BOOL)isPending {
    return nil;
}

- (void)setProperties:(NSDictionary *)properties {
    [super setProperties:properties];
    
    // Easy things first
    self.verb = properties[@"verb"];
    self.isPrivate = [properties[@"private"] boolValue];
    self.storyDescription = properties[@"description"];
    if (![properties[@"published_at"] isKindOfClass:[NSNull class]]) {
        if ([properties[@"published_at"] isKindOfClass:[NSString class]])
            self.publishedAt = [[[self class] dateFormatter] dateFromString:properties[@"published_at"]];
        else
            self.publishedAt = properties[@"published_at"];
    }
    if (properties[@"amount"] != [NSNull null]) {
        if ([properties[@"amount"] isKindOfClass:[NSDecimalNumber class]])
            self.amount = properties[@"amount"];
        else
            self.amount = [NSDecimalNumber decimalNumberWithString:properties[@"amount"]];
    }
    

    // Subject
    if ([properties[@"subject"] isKindOfClass:[EVUser class]])
        self.subject = properties[@"subject"];
    else {
        NSDictionary *subject = properties[@"subject"];
        NSString *subjectClass = [NSString stringWithFormat:@"EV%@", subject[@"class"]];
        self.subject = [[NSClassFromString(subjectClass) alloc] initWithDictionary:subject];
    }
    
    // Target
    if (properties[@"target"] != [NSNull null])
    {
        if ([properties[@"target"] conformsToProtocol:@protocol(EVExchangeable)])
            self.target = properties[@"target"];
        else {
            NSDictionary *target = properties[@"target"];
            NSString *targetClass = [NSString stringWithFormat:@"EV%@", target[@"class"]];
            self.target = [[NSClassFromString(targetClass) alloc] initWithDictionary:target];
        }
    }
    
    // Owner
    NSString *ownerClass = [NSString stringWithFormat:@"EV%@", properties[@"owner_type"]];
    self.owner = [[NSClassFromString(ownerClass) alloc] init];
    if ([properties[@"owner_id"] isKindOfClass:[NSString class]])
        [self.owner setDbid:properties[@"owner_id"]];
    else
        [self.owner setDbid:[properties[@"owner_id"] stringValue]];
    
    [self determineStoryType];
}

- (void)determineStoryType {
    EVUser *me = [[EVCIA sharedInstance] me];
    if (![[self.subject dbid] isEqualToString:me.dbid] && ![[self.target dbid] isEqualToString:me.dbid])
        self.storyType = EVStoryTypeNotInvolved;
    else
    {
        if ([[self.subject dbid] isEqualToString:me.dbid])
        {
            if ([self.verb isEqualToString:@"paid"]) {
                self.storyType = EVStoryTypeOutgoing;
            } else if ([self.verb isEqualToString:@"requested"] || [self.verb isEqualToString:@"charged"]) {
                self.storyType = EVStoryTypePendingIncoming;
            } else if ([self.verb isEqualToString:@"withdrew"]) {
                self.storyType = EVStoryTypeWithdrawal;
            }
        }
        else
        {
            if ([self.verb isEqualToString:@"paid"]) {
                self.storyType = EVStoryTypeIncoming;
            } else if ([self.verb isEqualToString:@"requested"] || [self.verb isEqualToString:@"charged"]) {
                self.storyType = EVStoryTypePendingOutgoing;
            }
        }
    }
}

- (NSAttributedString *)attributedString {
    
    CGFloat fontSize = 15;
    NSDictionary *nounAttributes = @{ NSFontAttributeName : [EVFont boldFontOfSize:fontSize],
                                      NSForegroundColorAttributeName : [EVColor newsfeedNounColor] };
    NSDictionary *copyAttributes = @{ NSFontAttributeName : [EVFont defaultFontOfSize:fontSize],
                                      NSForegroundColorAttributeName : [EVColor newsfeedTextColor] };
    NSDictionary *positiveAttributes = @{ NSFontAttributeName : [EVFont boldFontOfSize:fontSize],
                                          NSForegroundColorAttributeName : [EVColor lightGreenColor] };
    NSDictionary *negativeAttributes =  @{ NSFontAttributeName : [EVFont boldFontOfSize:fontSize],
                                           NSForegroundColorAttributeName : [EVColor lightRedColor] };
    
    NSAttributedString *subject, *verb, *target, *amount, *description = nil;
    NSString *subjectName = [[self.subject dbid] isEqualToString:[EVCIA me].dbid] ? @"You" : [self.subject name];
    subject = [[NSAttributedString alloc] initWithString:subjectName
                                              attributes:nounAttributes];
    verb = [[NSAttributedString alloc] initWithString:self.verb
                                           attributes:copyAttributes];
    if (self.target) {
        if (self.displayType != EVStoryDisplayTypePendingTransactionDetail || self.storyType == EVStoryTypePendingIncoming) {
        NSString *targetName = [[self.target dbid] isEqualToString:[EVCIA me].dbid] ? @"You" : [self.target name];
        target = [[NSAttributedString alloc] initWithString:targetName
                                                 attributes:nounAttributes];
        }
    }
    if (self.amount == nil || [self.amount isEqualToNumber:[NSDecimalNumber notANumber]])
    {
        amount = [[NSAttributedString alloc] initWithString:@"money" attributes:copyAttributes];
    }
    else
    {
        if (self.storyType == EVStoryTypeOutgoing || self.storyType == EVStoryTypePendingOutgoing)
            amount = [[NSAttributedString alloc] initWithString:[EVStringUtility amountStringForAmount:self.amount]
                                                     attributes:negativeAttributes];
        else if (self.storyType == EVStoryTypeNotInvolved || self.storyType == EVStoryTypeWithdrawal)
            amount = [[NSAttributedString alloc] initWithString:[EVStringUtility amountStringForAmount:self.amount]
                                                     attributes:nounAttributes];
        else
            amount = [[NSAttributedString alloc] initWithString:[EVStringUtility amountStringForAmount:self.amount]
                                                     attributes:positiveAttributes];
    }

    if (!EV_IS_EMPTY_STRING(self.storyDescription)) {
        NSString *preposition = (self.storyType == EVStoryTypeWithdrawal) ? @"into" : @"for";
        description = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", preposition, self.storyDescription]
                                                      attributes:copyAttributes];
    }
    NSAttributedString *space = [[NSAttributedString alloc] initWithString:@" " attributes:copyAttributes];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithAttributedString:subject];
    [attrString appendAttributedString:space];
    [attrString appendAttributedString:verb];
    
    if (self.displayType == EVStoryDisplayTypePendingTransactionDetail && self.storyType == EVStoryTypePendingIncoming) {
        NSAttributedString *from = [[NSAttributedString alloc] initWithString:@"from" attributes:copyAttributes];
        [attrString appendAttributedString:space];
        [attrString appendAttributedString:amount];
        if (target) {
            [attrString appendAttributedString:space];
            [attrString appendAttributedString:from];
            [attrString appendAttributedString:space];
            [attrString appendAttributedString:target];
        }

    } else {
        if (target) {
            [attrString appendAttributedString:space];
            [attrString appendAttributedString:target];
        }
        [attrString appendAttributedString:space];
        [attrString appendAttributedString:amount];
    }
    if (description) {
        [attrString appendAttributedString:space];
        [attrString appendAttributedString:description];
    }
    return attrString;
}

- (NSString *)likeButtonString {
    NSString *string = nil;
    if (self.liked)
    {
        if (self.likeCount == 0)
            string = @"You like this";
        else
            string = [NSString stringWithFormat:@"You + %d", self.likeCount];
    }
    else
    {
        if (self.likeCount == 0)
            string = @"Like";
        else
            string = EV_STRING_FROM_INT(self.likeCount);
    }
    return string;
}

- (void)likeWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    NSMutableURLRequest *request = [[self class] requestWithMethod:@"POST"
                                                              path:[NSString stringWithFormat:@"%@/likes", self.dbid]
                                                        parameters:nil];
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                  if (success)
                                                                                      success();
                                                                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                  if (failure)
                                                                                      failure(error);
                                                                              }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<EVStory: 0x%x> %@ %@ %@ for %@", (int)self, [self.subject name], self.verb, [self.target name], self.storyDescription];
}

@end
