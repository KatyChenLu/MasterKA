//
//  HttpManagerCenter.h
//  MasterKA
//
//  Created by jinghao on 15/12/9.
//  Copyright © 2015年 jinghao. All rights reserved.


#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "AFHTTPSessionManager+RACSupport.h"
#import "BaseModel.h"

typedef void (^WebServiceBlock) (id data,NSError* error);

typedef NS_ENUM(NSInteger, HttpMethod) {
    HttpMethodGet,//默认从0开始
    HttpMethodPost,
    HttpMethodPut,
    HttpMethodDelete,
    HttpMethodPatch,
    HttpMethodHead
};

static NSString *timeOut = @"timeout";

@interface HttpManagerCenter : AFHTTPSessionManager
@property (nonatomic,strong)NSString *networtType;
@property (nonatomic,strong,readonly)NSString *sessionId;


+ (instancetype)sharedHttpManager;


- (NSURLSessionTask*)doGet:(NSString*)url
                parameters:(NSDictionary *)parameters
               resultClass:(Class)resultClass
           webServiceBlock:(void (^)(id data,NSError* error))webServiceBlock;


- (NSURLSessionTask*)doPost:(NSString*)url
                 parameters:(NSDictionary *)parameters
                resultClass:(Class)resultClass
            webServiceBlock:(void (^)(id data,NSError* error))webServiceBlock;

- (NSURLSessionTask*)doDelete:(NSString*)url
                   parameters:(NSDictionary *)parameters
                  resultClass:(Class)resultClass
              webServiceBlock:(void (^)(id data,NSError* error))webServiceBlock;

- (NSURLSessionTask*)doPut:(NSString*)url
                parameters:(NSDictionary *)parameters
               resultClass:(Class)resultClass
           webServiceBlock:(void (^)(id data,NSError* error))webServiceBlock;

- (NSURLSessionTask*)doPath:(NSString*)url
                 parameters:(NSDictionary *)parameters
                resultClass:(Class)resultClass
            webServiceBlock:(void (^)(id data,NSError* error))webServiceBlock;

- (NSURLSessionTask*)doHead:(NSString*)url
                 parameters:(NSDictionary *)parameters
                resultClass:(Class)resultClass
            webServiceBlock:(void (^)(id data,NSError* error))webServiceBlock;

- (RACSignal*)doRacGet:(NSString*)url parameters:(NSDictionary *)parameters resultClass:(Class)resultClass;

- (RACSignal*)doRacPost:(NSString*)url parameters:(NSDictionary *)parameters resultClass:(Class)resultClass;

- (RACSignal*)doRacDelete:(NSString*)url parameters:(NSDictionary *)parameters resultClass:(Class)resultClass;

- (RACSignal*)doRacPut:(NSString*)url parameters:(NSDictionary *)parameters resultClass:(Class)resultClass;

- (RACSignal*)doRacPath:(NSString*)url parameters:(NSDictionary *)parameters resultClass:(Class)resultClass;

- (RACSignal*)doRacHead:(NSString*)url parameters:(NSDictionary *)parameters resultClass:(Class)resultClass;
@end
