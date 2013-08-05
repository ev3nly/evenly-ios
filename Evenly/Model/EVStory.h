//
//  EVStory.h
//  Evenly
//
//  Created by Joseph Hankin on 6/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVObject.h"

extern NSString *const EVStoryLocallyCreatedNotification;
extern NSTimeInterval const EVStoryLocalMaxLifespan;

@class EVExchange;
@class EVGroupRequest;
@class EVWalletNotification;

typedef enum {
    EVStorySourceTypeNormal,
    EVStorySourceTypeUser,
    EVStorySourceTypeHint,
    EVStorySourceTypeGettingStarted,
    EVStorySourceTypeWalletNotification
} EVStorySourceType;

typedef enum {
    EVStoryTransactionTypeNotInvolved,
    EVStoryTransactionTypePendingIncoming,
    EVStoryTransactionTypePendingOutgoing,
    EVStoryTransactionTypeIncoming,
    EVStoryTransactionTypeOutgoing,
    EVStoryTransactionTypeWithdrawal,
    EVStoryTransactionTypeInformational
} EVStoryTransactionType;

typedef enum {
    EVStoryDisplayTypeMainFeed,
    EVStoryDisplayTypeCompletedTransactionDetail,
    EVStoryDisplayTypePendingTransactionDetail
} EVStoryDisplayType;

@interface EVStory : EVObject

@property (nonatomic, strong) id subject;
@property (nonatomic, strong) NSString *verb;
@property (nonatomic, strong) id target;
@property (nonatomic, strong) NSString *storyDescription;
@property (nonatomic, strong) NSDecimalNumber *amount;
@property (nonatomic, assign) BOOL isPrivate;
@property (nonatomic, strong) id owner;
@property (nonatomic, strong) id source;
@property (nonatomic, strong) NSDate *publishedAt;
@property (nonatomic) BOOL liked;
@property (nonatomic, strong) NSArray *likes;
@property (nonatomic, readonly) NSInteger likeCount;

@property (nonatomic, strong) NSAttributedString *attributedString;
@property (nonatomic, readonly) EVStoryTransactionType transactionType;
@property (nonatomic, assign) EVStoryDisplayType displayType;
@property (nonatomic, assign) EVStorySourceType sourceType;
@property (nonatomic, readonly) NSString *likeButtonString;

@property (nonatomic, strong) NSURL *imageURL;


+ (EVStory *)storyFromObject:(EVObject *)object;
+ (EVStory *)storyFromPendingExchange:(EVExchange *)exchange;
+ (EVStory *)storyFromCompletedExchange:(EVExchange *)exchange;
+ (EVStory *)storyFromGroupRequest:(EVGroupRequest *)groupRequest;
+ (EVStory *)storyFromWithdrawal:(EVWithdrawal *)withdrawal;

- (void)likeWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure;
- (void)unlikeWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure;

@end
