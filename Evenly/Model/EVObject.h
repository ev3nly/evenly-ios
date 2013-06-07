//
//  EVObject.h
//  Evenly
//
//  Created by Joseph Hankin on 3/30/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>
#import "AFNetworking.h"
#import "EVNetworkManager.h"
#import "EVHTTPClient.h"
#import "ReactiveCocoa.h"

#define setValueForKeyIfNonNil(value, key) if (value) { [mutableDictionary setObject:value forKey:key]; };

typedef void (^AFSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^AFFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

@interface EVObject : NSObject <NSCoding> {
    NSDictionary *_originalDictionary;
}

@property (nonatomic, strong) NSString *dbid;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, readonly) NSDictionary *originalDictionary;
@property (nonatomic, assign, getter=isValid) BOOL valid;

+ (NSString *)controllerName;
+ (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters;
+ (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method
                                                   path:(NSString *)path
                                             parameters:(NSDictionary *)parameters
                              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block;
+ (AFFailureBlock)standardFailureBlock;

+ (EVJSONRequestOperation *)JSONRequestOperationWithRequest:(NSMutableURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/** Designated initializer.  Overridden by subclasses as necessary. */
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)setProperties:(NSDictionary *)properties;
- (NSDictionary *)dictionaryRepresentation;
- (void)validate;

#pragma mark - CRUD methods

+ (void)allWithSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure;
+ (void)allWithParams:(NSDictionary *)params success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;
+ (void)createWithParams:(NSDictionary *)params
                 success:(void (^)(EVObject *))success
                 failure:(void (^)(NSError *error))failure;

- (void)saveWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure;
- (void)updateWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure;
- (void)destroyWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure;
- (void)action:(NSString *)action
        method:(NSString *)method
    parameters:(NSDictionary *)parameters
       success:(void (^)(void))success
       failure:(void (^)(NSError *error))failure;


@end 
