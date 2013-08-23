//
//  EVStory.m
//  Evenly
//
//  Created by Joseph Hankin on 6/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVStory.h"
#import "EVLike.h"
#import "EVUser.h"
#import "EVPayment.h"
#import "EVRequest.h"
#import "EVWithdrawal.h"
#import "EVGroupRequest.h"
#import "EVConnection.h"
#import <DTCoreText/DTCoreText.h>

NSString *const EVStoryLocallyCreatedNotification = @"EVStoryLocallyCreatedNotification";
NSTimeInterval const EVStoryLocalMaxLifespan = 60 * 60; // one hour

@interface EVStory ()

@property (nonatomic, assign) EVStoryTransactionType transactionType;
@property (nonatomic, assign) int fakeLikeCount;

@end

@implementation EVStory

+ (NSString *)controllerName {
    return @"stories";
}

+ (EVStory *)storyFromObject:(EVObject *)object {
    if ([object isKindOfClass:[EVRequest class]]) {
        return [self storyFromPendingExchange:(EVExchange *)object];
    } else if ([object isKindOfClass:[EVPayment class]]) {
        return [self storyFromCompletedExchange:(EVExchange *)object];
    } else if ([object isKindOfClass:[EVWithdrawal class]]) {
        return [self storyFromWithdrawal:(EVWithdrawal *)object];
    } else if ([object isKindOfClass:[EVGroupRequest class]]) {
        return [self storyFromGroupRequest:(EVGroupRequest *)object];
    }
    return nil;
}

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
    setValueForKeyIfNonNil([self htmlFromExchange:exchange], @"display_description");

    EVStory *story = [EVStory new];
    [story setProperties:mutableDictionary];
    story.displayType = EVStoryDisplayTypePendingTransactionDetail;
    story.isPrivate = [exchange.visibility isEqualToString:[EVStringUtility stringForPrivacySetting:EVPrivacySettingPrivate]];
    story.createdAt = exchange.createdAt ?: [NSDate date];
    story.publishedAt = exchange.createdAt ?: [NSDate date];
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
    setValueForKeyIfNonNil([self htmlFromExchange:exchange], @"display_description");

    EVStory *story = [EVStory new];
    [story setProperties:mutableDictionary];
    story.displayType = EVStoryDisplayTypeCompletedTransactionDetail;
    story.isPrivate = [exchange.visibility isEqualToString:[EVStringUtility stringForPrivacySetting:EVPrivacySettingPrivate]];
    story.source = exchange;
    story.createdAt = exchange.createdAt ?: [NSDate date];
    story.publishedAt = exchange.createdAt ?: [NSDate date];
    return story;
}

+ (NSString *)htmlFromExchange:(EVExchange *)exchange {
    NSString *fromName = nil, *toName = nil, *whatTheyShared = nil;
    if (!exchange.from)
        fromName = @"You";
    else
    {
        fromName = [exchange.from name];
        if (!fromName)
            fromName = [exchange.from phoneNumber];
        if (!fromName)
            fromName = [exchange.from email];
    }
    
    if (!exchange.to)
        toName = @"You";
    else
    {
        toName = [exchange.to name];
        if (!toName)
            toName = [exchange.to phoneNumber];
        if (!toName)
            toName = [exchange.to email];
    }
    
    whatTheyShared = exchange.memo;
    NSString *htmlString = [NSString stringWithFormat:@"<strong>%@</strong> and <strong>%@</strong> shared %@",
                            fromName,
                            toName,
                            whatTheyShared];
    return htmlString;
}


+ (EVStory *)storyFromGroupRequest:(EVGroupRequest *)groupRequest {
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    
    setValueForKeyIfNonNil(@"requested", @"verb")
    setValueForKeyIfNonNil(groupRequest.title, @"description")
    setValueForKeyIfNonNil(groupRequest.createdAt, @"published_at")
    setValueForKeyIfNonNil((groupRequest.from ?: [EVCIA me]), @"subject")
    setValueForKeyIfNonNil(@"User", @"owner_type")
    setValueForKeyIfNonNil([EVCIA me].dbid, @"owner_id")
    
    if (![groupRequest.from.dbid isEqualToString:[EVCIA me].dbid])
        [mutableDictionary setValue:[EVCIA me] forKey:@"target"];
    
    EVStory *story = [EVStory new];
    [story setProperties:mutableDictionary];
    story.displayType = EVStoryDisplayTypePendingTransactionDetail;
    story.publishedAt = groupRequest.createdAt ?: [NSDate date];
    return story;
}

+ (NSString *)htmlFromGroupRequest:(EVGroupRequest *)groupRequest {
    NSString *fromName = nil, *toName = nil, *whatTheyShared = nil;
    if (!groupRequest.from)
        fromName = @"You";
    else
    {
        fromName = [groupRequest.from name];
        if (!fromName)
            fromName = [groupRequest.from phoneNumber];
        if (!fromName)
            fromName = [groupRequest.from email];
    }
    
    if (![groupRequest.from.dbid isEqualToString:[EVCIA me].dbid])
        toName = @"You";
    else
        toName = [EVStringUtility stringForNumberOfPeople:[[groupRequest tiers] count]];
    
    whatTheyShared = groupRequest.memo;
    NSString *htmlString = [NSString stringWithFormat:@"<strong>%@</strong> and <strong>%@</strong> shared %@",
                            fromName,
                            toName,
                            whatTheyShared];
    return htmlString;
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
    
    NSString *htmlString = [NSString stringWithFormat:@"<strong>You</strong> withdrew %@", [EVStringUtility amountStringForAmount:withdrawal.amount]];
    setValueForKeyIfNonNil(htmlString, @"display_description");
    
    EVStory *story = [EVStory new];
    [story setProperties:mutableDictionary];
    story.displayType = EVStoryDisplayTypeCompletedTransactionDetail;
    story.publishedAt = withdrawal.createdAt ?: [NSDate date];
    return story;
}

+ (NSString *)verbFromExchange:(EVExchange *)exchange isPending:(BOOL)isPending {
    return nil;
}

- (NSString *)stringFromValue:(id)value {
    NSString *string = nil;
    if (value) {
        if ([value respondsToSelector:@selector(stringValue)])
            string = [value stringValue];
        else if ([value isKindOfClass:[NSString class]])
            string = value;
    }
    return string;
}

- (void)setProperties:(NSDictionary *)properties {
    [super setProperties:properties];

    // Easy things first
    self.verb = properties[@"verb"];
    self.isPrivate = [properties[@"visibility"] isEqualToString:@"private"];
    self.storyDescription = properties[@"description"];
    
    if (properties[@"display_title"] && [properties[@"display_title"] isKindOfClass:[NSString class]]) {
        self.displayTitle = [properties[@"display_title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }

    if (properties[@"display_description"] && [properties[@"display_description"] isKindOfClass:[NSString class]]) {
        self.displayDescription = [properties[@"display_description"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.displayDescription = [self.displayDescription stringByReplacingOccurrencesOfString:[EVCIA me].name withString:@"You"];
    }

    if (properties[@"published_at"] && ![properties[@"published_at"] isKindOfClass:[NSNull class]]) {
        if ([properties[@"published_at"] isKindOfClass:[NSString class]])
        {
            @synchronized ([[self class] dateFormatter])
            {
                self.publishedAt = [[[self class] dateFormatter] dateFromString:properties[@"published_at"]];
            }
        }
        else
            self.publishedAt = properties[@"published_at"];
    }
    if (properties[@"amount"] && properties[@"amount"] != [NSNull null]) {
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
        NSString *dbid = [self stringFromValue:subject[@"id"]];

        // Explicitly check for a cached object, so we don't accidentally overwrite our cached
        // data with stale data from the story in initWithDictionary:.
        self.subject = [[EVCIA sharedInstance] cachedObjectWithClassName:subjectClass dbid:dbid];
        if (!self.subject)
            self.subject = [[NSClassFromString(subjectClass) alloc] initWithDictionary:subject];
        if ([self.subject isKindOfClass:[EVConnection class]])
            self.subject = ((EVConnection *)self.subject).user;
    }
    
    // Target
    if (properties[@"target"] != [NSNull null])
    {
        if ([properties[@"target"] conformsToProtocol:@protocol(EVExchangeable)])
            self.target = properties[@"target"];
        else {
            NSDictionary *target = properties[@"target"];
            NSString *targetClass = [NSString stringWithFormat:@"EV%@", target[@"class"]];
            NSString *dbid = [self stringFromValue:target[@"id"]];
            
            // Explicitly check for a cached object, so we don't accidentally overwrite our cached
            // data with stale data from the story in initWithDictionary:.
            self.target = [[EVCIA sharedInstance] cachedObjectWithClassName:targetClass dbid:dbid];
            if (!self.target)
                self.target = [[NSClassFromString(targetClass) alloc] initWithDictionary:target];
            if ([self.target isKindOfClass:[EVConnection class]])
                self.target = ((EVConnection *)self.target).user;
        }
    }
    
    // Owner
    NSString *ownerClass = [NSString stringWithFormat:@"EV%@", properties[@"owner_type"]];
    self.owner = [[NSClassFromString(ownerClass) alloc] init];
    if ([properties[@"owner_id"] isKindOfClass:[NSString class]])
        [self.owner setDbid:properties[@"owner_id"]];
    else
        [self.owner setDbid:[properties[@"owner_id"] stringValue]];
    
    
    // Likes
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *likeDictionary in properties[@"likes"]) {
        EVLike *like = [[EVLike alloc] initWithDictionary:likeDictionary];
        if ([like.liker isEqual:[EVCIA me]]) {
            self.liked = YES;
        }
        [array addObject:like];
    }
    self.likes = array;
    
    if (properties[@"likes_count"])
        self.fakeLikeCount = [properties[@"likes_count"] intValue];
    else
        self.fakeLikeCount = -1;
    
    // Source Object
    if (properties[@"source_type"] && properties[@"source_id"]) {
        self.source = @{ @"type" : properties[@"source_type"],
                         @"id" : properties[@"source_id"] };
    }
    
    self.sourceType = EVStorySourceTypeNormal;
    if (properties[@"source_type"]) {
        NSString *sourceType = properties[@"source_type"];
        if ([sourceType isEqualToString:@"User"])
            self.sourceType = EVStorySourceTypeUser;
        else if ([sourceType isEqualToString:@"Hint"])
            self.sourceType = EVStorySourceTypeHint;
        else if ([sourceType isEqualToString:@"GettingStarted"])
            self.sourceType = EVStorySourceTypeGettingStarted;
        else if ([sourceType isEqualToString:@"Reward"])
            self.sourceType = EVStorySourceTypeReward;
    }
    if (properties[@"image_url"] && ![properties[@"image_url"] isKindOfClass:[NSNull class]]) {
        self.imageURL = [NSURL URLWithString:properties[@"image_url"]];
    }
    

    [self determineStoryType];
    self.attributedString = [self attributedStringFromHTMLDisplayDescription];
}

- (void)determineStoryType {
    EVUser *me = [[EVCIA sharedInstance] me];
    if (![[self.subject dbid] isEqualToString:me.dbid] && ![[self.target dbid] isEqualToString:me.dbid]) {
        if (self.sourceType == EVStorySourceTypeHint || self.sourceType == EVStorySourceTypeGettingStarted)
            self.transactionType = EVStoryTransactionTypeInformational;
        else
            self.transactionType = EVStoryTransactionTypeNotInvolved;
    }
    else
    {
        if ([[self.subject dbid] isEqualToString:me.dbid])
        {
            if ([self.verb isEqualToString:@"paid"]) {
                self.transactionType = EVStoryTransactionTypeOutgoing;
            } else if ([self.verb isEqualToString:@"requested"] || [self.verb isEqualToString:@"charged"]) {
                self.transactionType = EVStoryTransactionTypePendingIncoming;
            } else if ([self.verb isEqualToString:@"withdrew"]) {
                self.transactionType = EVStoryTransactionTypeWithdrawal;
            } else if ([self.verb isEqualToString:@"won"]) {
                self.transactionType = EVStoryTransactionTypeIncoming;
            }
        }
        else
        {
            if ([self.verb isEqualToString:@"paid"]) {
                self.transactionType = EVStoryTransactionTypeIncoming;
            } else if ([self.verb isEqualToString:@"requested"] || [self.verb isEqualToString:@"charged"]) {
                self.transactionType = EVStoryTransactionTypePendingOutgoing;
            }
        }
    }
}

static DTCSSStylesheet *_stylesheet;

- (NSAttributedString *)attributedStringFromHTMLDisplayDescription {
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
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithHTMLData:[self.displayDescription dataUsingEncoding:NSUTF8StringEncoding]
                                                                                        options:options
                                                                             documentAttributes:nil];

    // Remove the paragraph style, which messes up the label textAlignment properties.
    [attrString removeAttribute:NSParagraphStyleAttributeName range:NSMakeRange(0, attrString.length)];
    if (self.displayTitle)
    {
        CGFloat fontSize = 15;
        NSDictionary *nounAttributes = @{ NSFontAttributeName : [EVFont boldFontOfSize:fontSize],
                                          NSForegroundColorAttributeName : [EVColor newsfeedNounColor] };
        NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", self.displayTitle]
                                                                                        attributes:nounAttributes]
        ;
        [titleString appendAttributedString:attrString];
        attrString = titleString;
    }
    
    // Hat tip to Panupan Sriautharawong,
    // http://panupan.com/2012/06/04/trim-leading-and-trailing-whitespaces-from-nsmutableattributedstring/
    // Trim leading whitespace and newlines.
    NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSRange range           = [attrString.string rangeOfCharacterFromSet:charSet];
    while (range.length != 0 && range.location == 0)
    {
        [attrString replaceCharactersInRange:range
                                 withString:@""];
        range = [attrString.string rangeOfCharacterFromSet:charSet];
    }
    
    // Trim trailing whitespace and newlines.
    range = [attrString.string rangeOfCharacterFromSet:charSet
                                              options:NSBackwardsSearch];
    while (range.length != 0 && NSMaxRange(range) == attrString.length)
    {
        [attrString replaceCharactersInRange:range
                                 withString:@""];
        range = [attrString.string rangeOfCharacterFromSet:charSet
                                                  options:NSBackwardsSearch];
    }
    return attrString;
}

- (NSInteger)likeCount {
    if (self.fakeLikeCount >= 0)
        return self.fakeLikeCount;
    return self.likes.count;
}

- (NSString *)likeButtonString {
    if (self.isPrivate)
        return @"Private";
    
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
                                                                                  self.liked = YES;
                                                                                  if (success)
                                                                                      success();
                                                                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                  if (failure)
                                                                                      failure(error);
                                                                              }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

- (void)unlikeWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    NSMutableURLRequest *request = [[self class] requestWithMethod:@"DELETE"
                                                              path:[NSString stringWithFormat:@"%@/likes", self.dbid]
                                                        parameters:nil];
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                  self.liked = NO;
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
