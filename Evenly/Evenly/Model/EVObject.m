//
//  EVObject.m
//  Evenly
//
//  Created by Joseph Hankin on 3/30/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVObject.h"
#import "EVNetworkManager.h"
#import "EVSerializer.h"

@interface EVObject ()

+ (NSDateFormatter *)dateFormatter;

@end

@implementation EVObject

@synthesize originalDictionary = _originalDictionary;

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
    return operation;
}

static NSDateFormatter *_dateFormatter = nil;
+ (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        _dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    }
    return _dateFormatter;
}


- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _originalDictionary = dictionary;
        [self setProperties:dictionary];
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

- (BOOL)isValid {
    return YES;
}

#pragma mark - CRUD methods

+ (void)allWithSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure {
    [self allWithParams:nil success:success failure:failure];
}

+ (void)allWithParams:(NSDictionary *)params success:(void (^)(id result))success failure:(void (^)(NSError *error))failure {
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:nil parameters:params];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id result = nil;
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            result = [NSMutableArray array];
            for (NSDictionary *object in responseObject) {
                [result addObject:[EVSerializer serializeDictionary:object]];
            }
        } else if ([responseObject isKindOfClass:[NSDictionary class]] && responseObject[@"class"] != nil) {
            result = [EVSerializer serializeDictionary:responseObject];
        }
        else {
            result = responseObject;
        }
        if (success)
            success(result);
        
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
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:nil parameters:params];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        EVObject *object = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]])
            object = [[[self class] alloc] initWithDictionary:responseObject];
        if (success)
            success(object);
    
    };
    
    AFJSONRequestOperation *operation = [self JSONRequestOperationWithRequest:request
                                                                      success:successBlock
                                                                      failure:[self standardFailureBlockWithFailure:failure]];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

- (void)saveWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    
    if (self.dbid) {
        
    } else {        
        [[self class] createWithParams:[self dictionaryRepresentation] success:^(EVObject *object) {
            
            _dbid = object.dbid;
            if (success)
                success();
            
        } failure:failure];
    }
}

- (void)updateWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    NSMutableURLRequest *request = [[self class] requestWithMethod:@"PUT" path:self.dbid parameters:[self dictionaryRepresentation]];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    };
    
    AFJSONRequestOperation *operation = [[self class] JSONRequestOperationWithRequest:request
                                                                      success:successBlock
                                                                      failure:[[self class] standardFailureBlockWithFailure:failure]];
    [[EVNetworkManager sharedInstance] enqueueRequest:operation];
}

- (void)destroyWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    NSMutableURLRequest *request = [[self class] requestWithMethod:@"DELETE" path:self.dbid parameters:nil];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success();
        
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
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", self.dbid, action];
    
    NSMutableURLRequest *request = [[self class] requestWithMethod:method path:path parameters:parameters];
    AFSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
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
