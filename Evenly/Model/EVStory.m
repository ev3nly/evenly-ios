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
#import "EVCharge.h"
#import "EVExchange.h"

@interface EVStory ()

@property (nonatomic, assign) EVStoryType storyType;

@end

@implementation EVStory

+ (EVStory *)storyFromPendingExchange:(EVExchange *)exchange {
    NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithCapacity:0];
    [properties setObject:@"requested" forKey:@"verb"];
    [properties setObject:exchange.memo forKey:@"description"];
    [properties setObject:exchange.createdAt forKey:@"published_at"];
    [properties setObject:exchange.amount forKey:@"amount"];
    [properties setObject:exchange.from forKey:@"subject"];
    [properties setObject:[EVCIA me] forKey:@"target"];
    [properties setObject:@"User" forKey:@"owner_type"];
    [properties setObject:[EVCIA me].dbid forKey:@"owner_id"];
    
    EVStory *story = [EVStory new];
    [story setProperties:properties];
    return story;
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
    if ([properties[@"amount"] isKindOfClass:[NSDecimalNumber class]])
        self.amount = properties[@"amount"];
    else
        self.amount = [NSDecimalNumber decimalNumberWithString:properties[@"amount"]];
    

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
        if ([properties[@"target"] isKindOfClass:[EVUser class]])
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
    if (self.target && self.storyType != EVStoryTypePendingOutgoing) {
        NSString *targetName = [[self.target dbid] isEqualToString:[EVCIA me].dbid] ? @"You" : [self.target name];
        target = [[NSAttributedString alloc] initWithString:targetName
                                                 attributes:nounAttributes];
    }
    
    if (self.storyType == EVStoryTypeOutgoing || self.storyType == EVStoryTypePendingOutgoing)
        amount = [[NSAttributedString alloc] initWithString:[EVStringUtility amountStringForAmount:self.amount]
                                                 attributes:negativeAttributes];
    else if (self.storyType == EVStoryTypeNotInvolved || self.storyType == EVStoryTypeWithdrawal)
        amount = [[NSAttributedString alloc] initWithString:[EVStringUtility amountStringForAmount:self.amount]
                                                 attributes:nounAttributes];
    else
        amount = [[NSAttributedString alloc] initWithString:[EVStringUtility amountStringForAmount:self.amount]
                                                 attributes:positiveAttributes];
    if (!EV_IS_EMPTY_STRING(self.storyDescription))
        description = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"for %@", self.storyDescription]
                                                      attributes:copyAttributes];
    NSAttributedString *space = [[NSAttributedString alloc] initWithString:@" " attributes:copyAttributes];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithAttributedString:subject];
    [attrString appendAttributedString:space];
    [attrString appendAttributedString:verb];
    if (target) {
        [attrString appendAttributedString:space];
        [attrString appendAttributedString:target];
    }
    [attrString appendAttributedString:space];
    [attrString appendAttributedString:amount];
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

- (NSString *)description {
    return [NSString stringWithFormat:@"<EVStory: 0x%x> %@ %@ %@ for %@", (int)self, [self.subject name], self.verb, [self.target name], self.storyDescription];
}

@end
