//
//  HttpManagerCenter+App.h
//  MasterKA
//
//  Created by jinghao on 16/4/20.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "HttpManagerCenter.h"

@interface HttpManagerCenter (App)
//视频上传
- (RACSignal*)uploadMovie:(NSString*)upload_data resultClass:(Class)resultClass;


- (RACSignal*)appConfig:(Class)resultClass;


/**
 *  多图上传
 *
 *  @param upload_data        base64格式图片数据
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)uploadImages:(NSArray*)upload_data resultClass:(Class)resultClass;


/**
 *  单图上传
 *
 *  @param upload_data        base64格式图片数据
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)uploadImageOne:(NSString*)upload_data resultClass:(Class)resultClass;

/**
 *  根据关键字搜索标签名
 *
 *  @param keywords    搜索关键字
 *  @param page        页面
 *  @param pageSize    搜索条数
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)queryTagListByKeywords:(NSString*)keywords page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;

@end
