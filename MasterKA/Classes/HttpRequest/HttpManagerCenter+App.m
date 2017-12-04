//
//  HttpManagerCenter+App.m
//  MasterKA
//
//  Created by jinghao on 16/4/20.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "HttpManagerCenter+App.h"

@implementation HttpManagerCenter (App)
- (RACSignal*)appConfig:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:[NSUserDefaults arcObjectForKey:APP_DeviceToken_Key] forKey:@"deviceToken"];
    [params setObjectNotNull:[NSUserDefaults arcObjectForKey:APP_GetuiToken_Key] forKey:@"clientId"];
    
    return [self doRacPost:@"c=ipublic&a=init_conf" parameters:params resultClass:resultClass];
}

//多图上传
- (RACSignal*)uploadImages:(NSArray*)upload_data resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:upload_data forKey:@"upload_data"];
    [params setObjectNotNull:@"60" forKey:timeOut];
    return [self doRacPost:@"c=ipublic&a=multi_upload" parameters:params resultClass:resultClass];
}

//视频上传
- (RACSignal*)uploadMovie:(NSString*)upload_data resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:upload_data forKey:@"upload_data"];
    [params setObjectNotNull:@"60" forKey:timeOut];
    return [self doRacPost:@"c=ipublic&a=movie_upload" parameters:params resultClass:resultClass];
}

//单图上传
- (RACSignal*)uploadImageOne:(NSString*)upload resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:upload forKey:@"upload_data"];
    [params setObjectNotNull:@"60" forKey:timeOut];
    return [self doRacPost:@"c=ipublic&a=upload" parameters:params resultClass:resultClass];
}

- (RACSignal*)queryTagListByKeywords:(NSString*)keywords page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:keywords forKey:@"keywords"];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=ishare&a=tag_list_by_keywords" parameters:params resultClass:resultClass];
}

@end
