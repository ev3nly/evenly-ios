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

static EVUser *_me;

@interface EVUser ()

@property (nonatomic, strong) UIImage *avatar;

@end

@implementation EVUser

@synthesize avatar;
@synthesize avatarURL;

- (void)setProperties:(NSDictionary *)properties {
    [super setProperties:properties];
    
    self.name = [properties valueForKey:@"name"];
    self.email = [properties valueForKey:@"email"];
    self.phoneNumber = [properties valueForKey:@"phone_number"];
    if (properties[@"balance"])
    {
        if ([properties[@"balance"] isKindOfClass:[NSDecimalNumber class]])
            self.balance = properties[@"balance"];
        else
            self.balance = [NSDecimalNumber decimalNumberWithString:properties[@"balance"]];
    }
    else {
        if (!self.balance)
            self.balance = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    }
    self.password = [properties valueForKey:@"password"];
    
    if (properties[@"avatar_url"] && ![properties[@"avatar_url"] isKindOfClass:[NSNull class]]) {
        self.avatarURL = [NSURL URLWithString:properties[@"avatar_url"]];
        [self loadAvatar];
    }
    
    if (properties[@"connections"]) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dictionary in properties[@"connections"]) {
            EVConnection *connection = (EVConnection *)[EVSerializer serializeDictionary:dictionary];
            [array addObject:connection];
        }
        self.connections = array;
    }
    
    self.confirmed = [[properties valueForKey:@"confirmed"] boolValue];
}

- (NSDictionary *)dictionaryRepresentation {
    
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    
    setValueForKeyIfNonNil(self.name, @"name");
    setValueForKeyIfNonNil(self.email, @"email");
    setValueForKeyIfNonNil(self.phoneNumber, @"phone_number");
    setValueForKeyIfNonNil([self.balance stringValue], @"balance");
    setValueForKeyIfNonNil(self.password, @"password");
    setValueForKeyIfNonNil(self.password, @"password_confirmation");
    setValueForKeyIfNonNil(@(self.isConfirmed), @"confirmed");
    
    return [NSDictionary dictionaryWithDictionary:mutableDictionary];
}

+ (NSString *)controllerName {
    return @"users";
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<0x%x> User %@: %@ (balance: %@)", (int)self, self.dbid, self.name, [self.balance description]];
}

+ (EVUser *)me {
    return _me;
}

+ (void)setMe:(EVUser *)user {
    _me = user;
}

+ (void)meWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure reload:(BOOL)reload {
    if (reload || _me == nil) {
        [EVMe allWithSuccess:^(id result){
            
            
            //setting properties on existing me because ReactiveCocoa depends on this.
            //this might not be the right call, in the long term.
            if (_me) {
                [_me setProperties:[result originalDictionary]];
            } else {
                _me = [[EVMe alloc] initWithDictionary:[result originalDictionary]];
            }
            
            if ([[EVCIA sharedInstance] me]) {
                [[[EVCIA sharedInstance] me] setProperties:[result originalDictionary]];
                [[EVCIA sharedInstance] cacheMe];
            } else
                [[EVCIA sharedInstance] setMe:_me];
            
            if (success)
                success();
            
        } failure:^(NSError *error){
            if (failure)
                failure(error);
            
        }];
    } else {
        if (success)
            success();
    }
}

+ (void)saveMeWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure {
	EVMe *me = [[EVMe alloc] initWithDictionary:[EVUser me].dictionaryRepresentation];
	[me updateWithSuccess:success failure:failure];
}

+ (void)newsfeedWithSuccess:(void (^)(NSArray *newsfeed))success failure:(void (^)(NSError *error))failure {
    NSMutableURLRequest *request = [EVMe requestWithMethod:@"GET" path:@"newsfeed" parameters:nil];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in responseObject)
        {
            EVStory *story = [[EVStory alloc] init];
            [story setProperties:dict];
            [array addObject:story];
        }
        success(array);
    };
    
    AFJSONRequestOperation *operation = [self JSONRequestOperationWithRequest:request
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
        success(responseObject);
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
    NSMutableURLRequest *request = [EVMe requestWithMethod:@"POST" path:@"reset-password" parameters:@{@"email": email}];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    };
    
    AFJSONRequestOperation *operation = [self JSONRequestOperationWithRequest:request
                                                                      success:successBlock
                                                                      failure:^(AFHTTPRequestOperation *operation, NSError *error)  {
                                                                          if (failure)
                                                                              failure(error);
                                                                      }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

- (void)saveWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    [super saveWithSuccess:^{
        
        if (success)
            success();
        _me = self;
        
    } failure:failure];
}

- (void)updateWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    if (self == _me) {
        EVMe *me = [[EVMe alloc] initWithDictionary:[_me dictionaryRepresentation]];
        if (self.updatedAvatar)
        {
            [me updateWithNewAvatar:self.updatedAvatar success:success failure:failure];
        }
        else
        {
            [me updateWithSuccess:success failure:failure];
        }
    } else {
        [super updateWithSuccess:success failure:failure];
    }
}

- (void)updateWithNewAvatar:(UIImage *)newAvatar success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
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
        success();
    };
    
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                              success:successBlock
                                                                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                  if (failure)
                                                                                      failure(error);
                                                                              }];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

#pragma mark Images

- (void)loadAvatar {
    UIImage *image = [[EVCIA sharedInstance] imageForURL:self.avatarURL];
    if (image) {
        self.avatar = image;
        return;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:self.avatarURL];
    AFImageRequestOperation *imageRequestOperation = [AFImageRequestOperation imageRequestOperationWithRequest:request
                                                                                          imageProcessingBlock:NULL
                                                                                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                                           [[EVCIA sharedInstance] setImage:image forURL:self.avatarURL];
                                                                                                           self.avatar = image;
                                                                                                           DLog(@"Downloaded image, see? %@", self.avatar);
                                                                                                       } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                           //                                                                                                           DLog(@"Houston, you know what's coming next: %@", error);
                                                                                                       }];
    [[EVNetworkManager sharedInstance] enqueueRequest:imageRequestOperation];
}

- (void)evictAvatarFromCache {
    [[EVCIA sharedInstance] setImage:nil forURL:self.avatarURL];
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
        self.confirmed = [aDecoder decodeBoolForKey:@"EVUser_confirmed"];
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
    [aCoder encodeBool:self.confirmed forKey:@"EVUser_confirmed"];
}

@end



@implementation EVContact

@synthesize avatar;
@synthesize avatarURL;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        self.name = [dictionary valueForKey:@"name"];
        self.information = [dictionary valueForKey:@"information"];
    }
    return self;
}

#pragma mark - Properties

- (NSString *)email {
    return self.information;
}

- (void)setEmail:(NSString *)email {
    self.information = email;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[self class]])
        return NO;
    return (EV_OBJECTS_EQUAL_OR_NIL(self.name, [object name]) && EV_OBJECTS_EQUAL_OR_NIL(self.information, [object information]));
}

- (NSUInteger)hash {
    return [self.name hash] + 7*[self.information hash];
}

@end