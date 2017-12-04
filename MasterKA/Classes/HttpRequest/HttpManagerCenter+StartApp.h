//
//  HttpManagerCenter+StartApp.h
//  MasterKA
//
//  Created by 余伟 on 16/12/14.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "HttpManagerCenter.h"

@interface HttpManagerCenter (StartApp)

/**
 *  启动app获得分类
 *
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */
-(RACSignal*)getSubCategoryResultClass:(Class)resultClass;


/**
 *  绑定分类
 *  @param categorys    分类ID数组
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */
-(RACSignal *)bindCategorys:(NSArray *)categorys WithUserResultClass:(Class)resultClass;


@end
