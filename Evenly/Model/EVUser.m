//
//  EVUser.m
//  Evenly
//
//  Created by Joseph Hankin on 3/30/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVUser.h"
#import "EVCIA.h"
#import "EVStory.h"
#import "EVConnection.h"
#import "EVSerializer.h"

/* Used to get and update User via the /me controller */

@interface EVMe : EVUser

@end

@implementation EVMe

+ (NSString *)controllerName {
    return @"me";
}

@end

/* END EVMe */

@interface EVUser ()

@property (nonatomic, strong) UIImage *avatar;

@end

@implementation EVUser

@synthesize avatar;
@synthesize avatarURL;

- (NSDictionary *)modelServerMapping {
    return @{@"name": @"name",
             @"email": @"email",
             @"phoneNumber" : @"phone_number",
             @"email": @"email",
             @"phoneNumber": @"phone_number",
             @"balance": @"balance",
             @"password": @"password",
             @"avatarURL": @"avatar_url",
             @"connections": @"connections",
             @"unconfirmed": @"unconfirmed",
             @"facebookConnected": @"facebook_connected",
             @"roles": @"roles"};
}

- (void)setProperties:(NSDictionary *)properties {
    [super setProperties:properties];
    
    [self mapModelToDictionary:properties];
}

- (void)mapModelToDictionary:(NSDictionary *)dictionary {
    
    NSDictionary *mapping = [self modelServerMapping];
    
    for (NSString *modelKey in mapping.allKeys) {
        NSString *serverKey = mapping[modelKey];
        
        if (dictionary[serverKey]) {
            NSString *mappingSelectorString = [NSString stringWithFormat:@"%@MappingForValue:", modelKey];
            SEL mappingSelector = NSSelectorFromString(mappingSelectorString);
            
            NSObject *value = dictionary[serverKey];
            if (!value || [value isEqual:[NSNull null]] || [value isKindOfClass:[NSNull class]])
                continue;

            if ([self respondsToSelector:mappingSelector])
                [self performSelector:mappingSelector withObject:dictionary[serverKey]];
            else
                [self setValue:dictionary[serverKey] forKey:modelKey];
        }
    }
}

- (void)balanceMappingForValue:(NSObject *)value {
    if (value) {
        if ([value isKindOfClass:[NSDecimalNumber class]])
            self.balance = (NSDecimalNumber *)value;
        else
            self.balance = [NSDecimalNumber decimalNumberWithString:(NSString *)value];
    }
    else {
        if (!self.balance)
            self.balance = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    }
}

- (void)avatarURLMappingForValue:(NSString *)value {
    self.avatarURL = [NSURL URLWithString:value];
    [self loadAvatar];
}

- (void)connectionsMappingForValue:(NSArray *)value {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dictionary in value) {
        EVConnection *connection = (EVConnection *)[EVSerializer serializeDictionary:dictionary];
        [array addObject:connection];
    }
    self.connections = array;
}

- (void)unconfirmedMappingForValue:(NSString *)value {
    self.unconfirmed = ![value boolValue];
}

- (void)facebookConnectedMappingForValue:(NSString *)value {
    self.facebookConnected = [value boolValue];
}

- (NSDictionary *)dictionaryRepresentation {
    
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    
    setValueForKeyIfNonNil(self.name, @"name");
    setValueForKeyIfNonNil(self.email, @"email");
    setValueForKeyIfNonNil(self.phoneNumber, @"phone_number");
    setValueForKeyIfNonNil([self.balance stringValue], @"balance");
    setValueForKeyIfNonNil(self.password, @"password");
    setValueForKeyIfNonNil(self.password, @"password_confirmation");
    setValueForKeyIfNonNil(@(!self.unconfirmed), @"confirmed");
    setValueForKeyIfNonNil(self.currentPassword, @"current_password");
    setValueForKeyIfNonNil(@(self.facebookConnected), @"facebook_connected");
    
    return [NSDictionary dictionaryWithDictionary:mutableDictionary];
}

+ (NSString *)controllerName {
    return @"users";
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<0x%x> User %@: %@ (balance: %@)", (int)self, self.dbid, self.name, [self.balance description]];
}

+ (void)meWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure reload:(BOOL)reload {
    if (reload || [EVCIA me] == nil) {
        [EVMe allWithSuccess:^(id result){
            //setting properties on existing me because ReactiveCocoa depends on this.
            //this might not be the right call, in the long term.
            if ([[EVCIA sharedInstance] me]) {
                [[[EVCIA sharedInstance] me] setProperties:[result originalDictionary]];
                [[EVCIA sharedInstance] cacheMe];
            } else
                [[EVCIA sharedInstance] setMe:[[EVMe alloc] initWithDictionary:[result originalDictionary]]];
            
            if (success) {
                EV_PERFORM_ON_MAIN_QUEUE(^{
                    success();
                });
            }
        } failure:^(NSError *error){
            if (failure) {
                EV_PERFORM_ON_MAIN_QUEUE(^{
                    failure(error);
                });
            }
            
        }];
    } else {
        if (success)
            success();
    }
}

+ (void)newsfeedWithSuccess:(void (^)(NSArray *newsfeed))success failure:(void (^)(NSError *error))failure {
    [self newsfeedStartingAtPage:1 success:success failure:failure];
}

+ (void)newsfeedStartingAtPage:(int)pageNumber
                       success:(void (^)(NSArray *newsfeed))success
                       failure:(void (^)(NSError *error))failure {
    EV_ONLY_PERFORM_IN_BACKGROUND(^{
        [self newsfeedStartingAtPage:pageNumber success:success failure:failure];
    });

    NSMutableURLRequest *request = [EVMe requestWithMethod:@"GET"
                                                      path:@"newsfeed"
                                                parameters:@{
                                    @"page" : @(pageNumber),
                                    @"per" : @(EV_ITEMS_PER_PAGE)
                                    }];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        EV_PERFORM_ON_BACKGROUND_QUEUE(^{
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in responseObject)
            {
                EVStory *story = [[EVStory alloc] init];
                [story setProperties:dict];
                [array addObject:story];
            }
            EV_PERFORM_ON_MAIN_QUEUE(^{
                if (success)
                    success(array);
            });
        });
    };
    
    AFJSONRequestOperation *operation = [self JSONRequestOperationWithRequest:request
                                                                      success:successBlock
                                                                      failure:^(AFHTTPRequestOperation *operation, NSError *error)  {
                                                                          if (failure)
                                                                              failure(error);
                                                                      }];
    
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}


+ (void)historyStartingAtPage:(int)pageNumber
                      success:(void (^)(NSArray *history))success
                      failure:(void (^)(NSError *error))failure {
    NSMutableURLRequest *request = [EVMe requestWithMethod:@"GET"
                                                      path:@"history"
                                                parameters:@{
                                                                @"page" : @(pageNumber),
                                                                @"per" : @(EV_ITEMS_PER_PAGE)
                                                            }];
    EV_ONLY_PERFORM_IN_BACKGROUND(^{
        [self historyStartingAtPage:pageNumber success:success failure:failure];
    });
    
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        EV_PERFORM_ON_BACKGROUND_QUEUE(^{
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in responseObject)
            {
                id obj = [EVSerializer serializeDictionary:dict];
                if (obj)
                    [array addObject:obj];
            }
            EV_PERFORM_ON_MAIN_QUEUE(^{
                if (success)
                    success(array);
            });
        });
    };
    
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                              success:successBlock
                                                                              failure:^(AFHTTPRequestOperation *operation, NSError *error)  {
                                                                                  if (failure)
                                                                                      failure(error);
                                                                              }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

+ (void)pendingWithSuccess:(void (^)(NSArray *pending))success
                   failure:(void (^)(NSError *error))failure {
    NSMutableURLRequest *request = [EVMe requestWithMethod:@"GET"
                                                      path:@"pending"
                                                parameters:nil];
    EV_ONLY_PERFORM_IN_BACKGROUND(^{
        [self pendingWithSuccess:success failure:failure];
    });
    
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        EV_PERFORM_ON_BACKGROUND_QUEUE(^{
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in responseObject) {
                [array addObject:[EVSerializer serializeDictionary:dict]];
            }
            EV_PERFORM_ON_MAIN_QUEUE(^{
                if (success)
                    success(array);                
            });
        });
    };
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                              success:successBlock
                                                                              failure:^(AFHTTPRequestOperation *operation, NSError *error)  {
                                                                                  if (failure)
                                                                                      failure(error);
                                                                              }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}


+ (void)loadUser:(EVUser *)user withSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    [EVUser allWithSuccess:^(id result) {
        if (user)
            [user setProperties:[result originalDictionary]];
        if (success)
            success();
    } failure:^(NSError *error){
        if (failure)
            failure(error);
    }];
}

+ (void)createWithParams:(NSDictionary *)params
                 success:(void (^)(EVObject *))success
                 failure:(void (^)(NSError *error))failure
{
    EV_ONLY_PERFORM_IN_BACKGROUND(^{
        [self createWithParams:params success:success failure:failure];
    });
    
    if (![params objectForKey:@"avatar"]) {
        [super createWithParams:params success:success failure:failure];
        return;
    }
    
    NSMutableURLRequest *request = nil;
    void (^formBlock)(id<AFMultipartFormData> formData) = NULL;
    NSString *method = @"POST";
    NSString *path = nil;
    
    formBlock = ^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation([params objectForKey:@"avatar"], 0.9)
                                    name:@"avatar"
                                fileName:@"avatar.jpg"
                                mimeType:@"image/jpeg"];
    };
    
    request = [[self class] multipartFormRequestWithMethod:method path:path parameters:params constructingBodyWithBlock:formBlock];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        EV_PERFORM_ON_MAIN_QUEUE(^{
            if (success)
                success(responseObject);
        });
    };
    
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                              success:successBlock
                                                                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                  if (failure)
                                                                                      failure(error);
                                                                              }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

+ (void)resetPasswordForEmail:(NSString *)email withSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    EV_ONLY_PERFORM_IN_BACKGROUND(^{
        [self resetPasswordForEmail:email withSuccess:success failure:failure];
    });
    
    NSMutableURLRequest *request = [EVMe requestWithMethod:@"POST" path:@"reset-password" parameters:@{@"email": email}];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        EV_PERFORM_ON_MAIN_QUEUE(^{
            if (success)
                success();
        });
    };
    
    AFJSONRequestOperation *operation = [self JSONRequestOperationWithRequest:request
                                                                      success:successBlock
                                                                      failure:^(AFHTTPRequestOperation *operation, NSError *error)  {
                                                                          if (failure)
                                                                              failure(error);
                                                                      }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

+ (void)sendConfirmationEmailWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    EV_ONLY_PERFORM_IN_BACKGROUND(^{
        [self sendConfirmationEmailWithSuccess:success failure:failure];
    });
    
    NSMutableURLRequest *request = [EVMe requestWithMethod:@"POST" path:@"send-confirmation" parameters:nil];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        EV_PERFORM_ON_MAIN_QUEUE(^{
            if (success)
                success();
        });
    };
    
    AFJSONRequestOperation *operation = [self JSONRequestOperationWithRequest:request
                                                                      success:successBlock
                                                                      failure:^(AFHTTPRequestOperation *operation, NSError *error)  {
                                                                          if (failure)
                                                                              failure(error);
                                                                      }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
    
}

+ (void)updateMeWithFacebookToken:(NSString *)token
                       facebookID:(NSString *)facebookID
                          success:(void (^)(void))success
                          failure:(void (^)(NSError *))failure {
    EV_ONLY_PERFORM_IN_BACKGROUND(^{
        [self updateMeWithFacebookToken:token facebookID:facebookID success:success failure:failure];
    });
    
    NSMutableURLRequest *request = [EVMe requestWithMethod:@"PUT"
                                                      path:@""
                                                parameters:@{ @"facebook_token" : (token ?: [NSNull null]),
                                                                 @"facebook_id" : (facebookID ?: [NSNull null])}];
    
    DLog(@"Request body: %@", [NSString stringWithUTF8String:[[request HTTPBody] bytes]]);
    
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        EV_PERFORM_ON_MAIN_QUEUE(^{
            if (success)
                success();
        });
    };
    
    AFJSONRequestOperation *operation = [self JSONRequestOperationWithRequest:request
                                                                      success:successBlock
                                                                      failure:^(AFHTTPRequestOperation *operation, NSError *error)  {
                                                                          if (failure)
                                                                              failure(error);
                                                                      }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}


- (void)updateWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    if (self == [EVCIA me]) {
        EVMe *me = [[EVMe alloc] initWithDictionary:[[EVCIA me] dictionaryRepresentation]];
        if (self.updatedAvatar)
        {
            [me evictAvatarFromCache];
            [me updateWithNewAvatar:self.updatedAvatar success:success failure:failure];
        }
        else
        {
            [me updateWithSuccess:^{
                [[EVCIA sharedInstance] cacheMe];
                if (success)
                    success();
            } failure:failure];
        }
    } else {
        [super updateWithSuccess:success failure:failure];
    }
}

- (void)updateWithNewAvatar:(UIImage *)newAvatar success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    EV_ONLY_PERFORM_IN_BACKGROUND(^{
        [self updateWithNewAvatar:newAvatar success:success failure:failure];
    });
    
    self.avatar = newAvatar;
    
    NSMutableURLRequest *request = nil;
    void (^formBlock)(id<AFMultipartFormData> formData) = NULL;
    NSString *method = @"PUT";
    NSString *path = self.dbid;
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:[self dictionaryRepresentation] forKey:@"question"];
    
    formBlock = ^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(newAvatar, 0.9)
                                    name:@"avatar"
                                fileName:@"avatar.jpg"
                                mimeType:@"image/jpeg"];
    };
    DLog(@"Parameters: %@", parameters);
    
    request = [[self class] multipartFormRequestWithMethod:method path:path parameters:parameters constructingBodyWithBlock:formBlock];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        [[EVCIA sharedInstance] cacheMe];
        EV_PERFORM_ON_MAIN_QUEUE(^{
            if (success)
                success();
        });
    };
    
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                              success:successBlock
                                                                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                  if (failure)
                                                                                      failure(error);
                                                                              }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

#pragma mark - Getters

- (BOOL)needsGettingStartedHelp {
    if ([self userHasClearedGettingStartedBefore])
        return NO;
    
    if (self.isUnconfirmed)
        return YES;
    if (!self.facebookConnected)
        return YES;
    if (!self.hasAddedCard)
        return YES;
    if (!self.hasAddedBank)
        return YES;
    if (!self.hasSentPayment)
        return YES;
    if (!self.hasSentRequest)
        return YES;
    if (!self.hasInvitedFriends)
        return YES;
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:EVUserHasCompletedGettingStarted];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return NO;
}

- (BOOL)userHasClearedGettingStartedBefore {
    return ([[NSUserDefaults standardUserDefaults] boolForKey:EVUserHasCompletedGettingStarted] == YES);
}

- (BOOL)needsPaymentHelp {
    if (self.isUnconfirmed || !self.hasAddedCard)
        return YES;
    return NO;
}

- (BOOL)needsRequestHelp {
    if (self.isUnconfirmed)
        return YES;
    return NO;
}

- (BOOL)needsDepositHelp {
    if (self.isUnconfirmed || !self.hasAddedBank)
        return YES;
    return NO;
}

- (BOOL)hasAddedCard {
    return [self.roles containsObject:@"buyer"];
}

- (BOOL)hasAddedBank {
    return [self.roles containsObject:@"seller"];
}

- (BOOL)hasSentPayment {
    return [self.roles containsObject:@"payer"];
}

- (BOOL)hasSentRequest {
    return [self.roles containsObject:@"requester"];
}

- (BOOL)hasInvitedFriends {
    return [self.roles containsObject:@"inviter"];
}

#pragma mark Images

- (void)loadAvatar {
    [[EVCIA sharedInstance] loadImageFromURL:self.avatarURL
                                        size:CGSizeMake(EV_USER_DEFAULT_AVATAR_HEIGHT*2, EV_USER_DEFAULT_AVATAR_HEIGHT*2)
                                     success:^(UIImage *image) {
                                         self.avatar = image;
                                     } failure:nil];
}

- (void)evictAvatarFromCache {
    CGSize defaultAvatarSize = CGSizeMake(EV_USER_DEFAULT_AVATAR_HEIGHT*2, EV_USER_DEFAULT_AVATAR_HEIGHT*2);
    [[EVCIA sharedInstance] setImage:nil forURL:self.avatarURL withSize:defaultAvatarSize];
}

#pragma mark - Timeline

- (void)timelineWithSuccess:(void (^)(NSArray *timeline))success failure:(void (^)(NSError *error))failure {
    EV_ONLY_PERFORM_IN_BACKGROUND(^{
        [self timelineWithSuccess:success failure:failure];
    });
    
    NSString *path = [NSString stringWithFormat:@"%@/timeline", self.dbid];
    NSMutableURLRequest *request = [[self class] requestWithMethod:@"GET" path:path parameters:nil];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        EV_PERFORM_ON_BACKGROUND_QUEUE(^{
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in responseObject)
            {
                EVStory *story = [[EVStory alloc] init];
                [story setProperties:dict];
                [array addObject:story];
            }
            EV_PERFORM_ON_MAIN_QUEUE(^{
                if (success)
                    success(array);
            });
        });
    };
    
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                      success:successBlock
                                                                      failure:^(AFHTTPRequestOperation *operation, NSError *error)  {
                                                                          if (failure)
                                                                              failure(error);
                                                                      }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.dbid = [aDecoder decodeObjectForKey:@"EVUser_dbid"];
        self.name = [aDecoder decodeObjectForKey:@"EVUser_name"];
        self.email = [aDecoder decodeObjectForKey:@"EVUser_email"];
        self.phoneNumber = [aDecoder decodeObjectForKey:@"EVUser_phoneNumber"];
        self.password = [aDecoder decodeObjectForKey:@"EVUser_password"];
        self.balance = [NSDecimalNumber decimalNumberWithString:[aDecoder decodeObjectForKey:@"EVUser_balance"]
                                                         locale:[NSLocale systemLocale]];
        self.avatarURL = [NSURL URLWithString:[aDecoder decodeObjectForKey:@"EVUser_avatarURL"]];
        self.unconfirmed = [aDecoder decodeBoolForKey:@"EVUser_unconfirmed"];
        [self loadAvatar];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    if ([super respondsToSelector:@selector(encodeWithCoder:)])
        [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.dbid forKey:@"EVUser_dbid"];
    [aCoder encodeObject:self.name forKey:@"EVUser_name"];
    [aCoder encodeObject:self.email forKey:@"EVUser_email"];
    [aCoder encodeObject:self.phoneNumber forKey:@"EVUser_phoneNumber"];
    [aCoder encodeObject:self.password forKey:@"EVUser_password"];
    [aCoder encodeObject:[self.balance descriptionWithLocale:[NSLocale systemLocale]] forKey:@"EVUser_balance"];
    [aCoder encodeObject:[self.avatarURL absoluteString] forKey:@"EVUser_avatarURL"];
    [aCoder encodeBool:self.unconfirmed forKey:@"EVUser_unconfirmed"];
}

- (void)setPrivacySetting:(EVPrivacySetting)privacySetting {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:privacySetting] forKey:@"privacySetting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (EVPrivacySetting)privacySetting {
    NSNumber *setting = [NSNumber numberWithInt:EVPrivacySettingFriends];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"privacySetting"])
        setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"privacySetting"];
    return [setting intValue];
}

- (void)setRewardSharingSetting:(BOOL)rewardSharingSetting {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:rewardSharingSetting] forKey:@"rewardSharingSetting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)rewardSharingSetting {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"rewardSharingSetting"] boolValue];
}

@end



@implementation EVContact

@synthesize avatar;
@synthesize avatarURL;
@synthesize name;
@synthesize email;
@synthesize phoneNumber;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if ([[dictionary valueForKey:@"name"] isEqualToString:@"yuzhou zhang"])
        NSLog(@"dafuq");
    self = [super initWithDictionary:dictionary];
    if (self) {
        self.name = [dictionary valueForKey:@"name"];
        NSString *information = [dictionary valueForKey:@"information"];
        if ([information isPhoneNumber])
            self.phoneNumber = information;
        else if ([information isEmail])
            self.email = information;
    }
    return self;
}

#pragma mark - Properties

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[self class]])
        return NO;
    return (EV_OBJECTS_EQUAL_OR_NIL(self.name, [object name]) &&
            EV_OBJECTS_EQUAL_OR_NIL(self.email, [object email]) &&
            EV_OBJECTS_EQUAL_OR_NIL(self.phoneNumber, [object phoneNumber]));
}

- (NSUInteger)hash {
    return [self.name hash] + 7*[self.email hash] + 13*[self.phoneNumber hash];
}

@end