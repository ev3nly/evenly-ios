//
//  EVObject.m
//  Evenly
//
//  Created by Joseph Hankin on 3/30/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVObject.h"
#import "EVUtilities.h"
#import "EVNetworkManager.h"
#import "EVSerializer.h"

@interface EVObject ()

@end

@implementation EVObject

@synthesize originalDictionary = _originalDictionary;


#pragma mark - Class Methods

+ (NSString *)controllerName {
    return nil; // abstract
}

+ (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
    
    EVHTTPClient *httpClient = [[EVNetworkManager sharedInstance] httpClient];
    NSString *reformedPath = nil;
    if (EV_IS_EMPTY_STRING(path)) {
        reformedPath = [NSString stringWithFormat:@"%@", [self controllerName]];
    } else {
        reformedPath = [NSString stringWithFormat:@"%@/%@", [self controllerName], path];
    }
    NSMutableURLRequest *urlRequest = [httpClient requestWithMethod:method
                                                               path:reformedPath
                                                         parameters:parameters];
    [urlRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    return urlRequest;
}

+ (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method
                                                   path:(NSString *)path
                                             parameters:(NSDictionary *)parameters
                              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block {
    EVHTTPClient *httpClient = [[EVNetworkManager sharedInstance] httpClient];
    NSString *reformedPath = nil;
    if (EV_IS_EMPTY_STRING(path)) {
        reformedPath = [NSString stringWithFormat:@"%@", [self controllerName]];
    } else {
        reformedPath = [NSString stringWithFormat:@"%@/%@", [self controllerName], path];
    }
    NSMutableURLRequest *urlRequest = [httpClient multipartFormRequestWithMethod:method
                                                                            path:reformedPath
                                                                      parameters:parameters
                                                       constructingBodyWithBlock:block];
    [urlRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    return urlRequest;
}

+ (EVJSONRequestOperation *)JSONRequestOperationWithRequest:(NSMutableURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    AFSuccessBlock modifiedSuccess = ^(AFHTTPRequestOperation *operation, id responseObject) {
        [[EVNetworkManager sharedInstance] decreaseActivityIndicatorCounter];
        success(operation, responseObject);
    };
    AFFailureBlock modifiedFailure =  ^(AFHTTPRequestOperation *operation, NSError *error)  {
        [[EVNetworkManager sharedInstance] decreaseActivityIndicatorCounter];
        failure(operation, error);
    };
    
    EVHTTPClient *httpClient = [[EVNetworkManager sharedInstance] httpClient];
    EVJSONRequestOperation *operation = (EVJSONRequestOperation *)[httpClient HTTPRequestOperationWithRequest:request
                                                                                                      success:modifiedSuccess
                                                                                                      failure:modifiedFailure
                                                                                                hijackFailure:YES];
    [operation setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
        return nil;
    }];
    [[EVNetworkManager sharedInstance] increaseActivityIndicatorCounter];
    return operation;
}

static NSDateFormatter *_dateFormatter = nil;
+ (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        _dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    }
    return _dateFormatter;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    id cachedObject = [[EVCIA sharedInstance] cachedObjectWithClassName:NSStringFromClass([self class])
                                                                   dbid:[EVUtilities dbidFromDictionary:dictionary]];
    if (cachedObject)
    {
        self = cachedObject;
        self->_originalDictionary = dictionary;
        [self setProperties:dictionary];
    }
    else
    {
        self = [super init];
        if (self)
        {
            _originalDictionary = dictionary;
            [self setProperties:dictionary];
            [[EVCIA sharedInstance] cacheObject:self];
        }
    }
    return self;
}

- (id)initWithID:(NSString *)dbid {
    id cachedObject = [[EVCIA sharedInstance] cachedObjectWithClassName:NSStringFromClass([self class])
                                                                   dbid:dbid];
    if (cachedObject)
    {
        self = cachedObject;
    }
    else
    {
        self = [super init];
        if (self) {
            _dbid = dbid;
            [self reloadWithSuccess:^(id object) {
                
            } failure:^(NSError *error) {
                DLog(@"error: %@", error);
            }];
        }
    }
    return self;
}

- (void)setProperties:(NSDictionary *)properties {
    if ([[properties valueForKey:@"id"] respondsToSelector:@selector(stringValue)])
        _dbid = [[properties valueForKey:@"id"] stringValue];
    else
        _dbid = [properties valueForKey:@"id"];
    if (![properties[@"created_at"] isKindOfClass:[NSNull class]])
        self.createdAt = [[[self class] dateFormatter] dateFromString:properties[@"created_at"]];
}

- (NSDictionary *)dictionaryRepresentation {
    return _originalDictionary;
}

- (void)validate {
    self.valid = YES;
}

#pragma mark - CRUD methods

+ (void)allWithSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure {
    [self allWithParams:nil success:success failure:failure];
}

+ (void)allWithParams:(NSDictionary *)params success:(void (^)(id result))success failure:(void (^)(NSError *error))failure {
    EV_ONLY_PERFORM_IN_BACKGROUND(^{
        [self allWithParams:params success:success failure:failure];
    });
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:nil parameters:params];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id result = nil;
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            result = [NSMutableArray array];
            for (NSDictionary *object in responseObject) {
                EVObject *serializedObject = [EVSerializer serializeDictionary:object];
                if (serializedObject)
                    [result addObject:serializedObject];
            }
        } else if ([responseObject isKindOfClass:[NSDictionary class]] && responseObject[@"class"] != nil) {
            result = [EVSerializer serializeDictionary:responseObject];
        }
        else {
            result = responseObject;
        }
        EV_PERFORM_ON_MAIN_QUEUE(^{
            if (success)
                success(result);
        });
    };
    
    AFJSONRequestOperation *operation = [self JSONRequestOperationWithRequest:request
                                                                      success:successBlock
                                                                      failure:[self standardFailureBlockWithFailure:failure]];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

+ (void)createWithParams:(NSDictionary *)params
                 success:(void (^)(EVObject *))success
                 failure:(void (^)(NSError *error))failure
{
    EV_ONLY_PERFORM_IN_BACKGROUND(^{
        [self createWithParams:params success:success failure:failure];
    });
    
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:nil parameters:params];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        EVObject *object = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]])
            object = [[[self class] alloc] initWithDictionary:responseObject];
        EV_PERFORM_ON_MAIN_QUEUE(^{
            if (success)
                success(object);
        });
    };
    NSData *bodyData = [request HTTPBody];
    NSString *bodyString = [NSString stringWithCString:[bodyData bytes] encoding:NSUTF8StringEncoding];
    DLog(@"Body string: %@", bodyString);
    
    AFJSONRequestOperation *operation = [self JSONRequestOperationWithRequest:request
                                                                      success:successBlock
                                                                      failure:[self standardFailureBlockWithFailure:failure]];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

- (void)reloadWithSuccess:(void (^)(id object))success failure:(void (^)(NSError *error))failure {
    EV_ONLY_PERFORM_IN_BACKGROUND(^{
        [self reloadWithSuccess:success failure:failure];
    });
    
    NSMutableURLRequest *request = [[self class] requestWithMethod:@"GET"
                                                              path:self.dbid
                                                        parameters:nil];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        EVObject *object = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]])
            object = [[[self class] alloc] initWithDictionary:responseObject];
        [self setProperties:[object originalDictionary]];
        [[EVCIA sharedInstance] cacheObject:object];
        self.loading = NO;
        if (success)
            success(object);
    };
    
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                      success:successBlock
                                                                      failure:[[self class] standardFailureBlockWithFailure:failure]];
    self.loading = YES;
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

- (void)saveWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    
    if (self.dbid) {
        
    } else {        
        [[self class] createWithParams:[self dictionaryRepresentation] success:^(EVObject *object) {
            
            _dbid = object.dbid;
            [self setProperties:[object originalDictionary]];
            if (success)
                success();
            
        } failure:failure];
    }
}

- (void)updateWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    EV_ONLY_PERFORM_IN_BACKGROUND(^{
        [self updateWithSuccess:success failure:failure];
    });
    
    NSMutableURLRequest *request = [[self class] requestWithMethod:@"PUT" path:self.dbid parameters:[self dictionaryRepresentation]];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        EV_PERFORM_ON_MAIN_QUEUE(^{
            if (success)
                success();
        });
    };
    
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                      success:successBlock
                                                                      failure:[[self class] standardFailureBlockWithFailure:failure]];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

- (void)destroyWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    EV_ONLY_PERFORM_IN_BACKGROUND(^{
        [self destroyWithSuccess:success failure:failure];
    });
    
    NSMutableURLRequest *request = [[self class] requestWithMethod:@"DELETE" path:self.dbid parameters:nil];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        EV_PERFORM_ON_MAIN_QUEUE(^{
            if (success)
                success();
        });
    };
    
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest: request
                                                                              success:successBlock
                                                                              failure:[[self class] standardFailureBlockWithFailure:failure]];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

- (void)action:(NSString *)action
        method:(NSString *)method
    parameters:(NSDictionary *)parameters
       success:(void (^)(void))success
       failure:(void (^)(NSError *error))failure {
    
    EV_ONLY_PERFORM_IN_BACKGROUND(^{
        [self action:action method:method parameters:parameters success:success failure:failure];
    });
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", self.dbid, action];
    
    NSMutableURLRequest *request = [[self class] requestWithMethod:method path:path parameters:parameters];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        EV_PERFORM_ON_MAIN_QUEUE(^{
            if (success)
                success();
        });
    };
    
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                              success:successBlock
                                                                              failure:[[self class] standardFailureBlockWithFailure:failure]];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

#pragma mark - Private Methods

+ (AFFailureBlock)standardFailureBlock {
    return [self standardFailureBlockWithFailure:nil];

}

+ (AFFailureBlock)standardFailureBlockWithFailure:(void (^)(NSError *error))failure {
    return ^(AFHTTPRequestOperation *operation, NSError *error)  {
        
        if (failure)
            failure(error);
    };
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _dbid = [aDecoder decodeObjectForKey:@"dbid"];
        _originalDictionary = [aDecoder decodeObjectForKey:@"originalDictionary"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_dbid forKey:@"dbid"];
    [aCoder encodeObject:_originalDictionary forKey:@"originalDictionary"];
}

#pragma mark - NSObject Overrides

- (BOOL)isEqual:(id)object {
    if ([object isMemberOfClass:[self class]]) {
        EVObject *inObject = (EVObject *)object;
        return [self.dbid isEqualToString:inObject.dbid];
    }
    return NO;
}

- (NSUInteger)hash {
    return [NSStringFromClass([self class]) hash] + 37 * [self.dbid hash];
}


@end
