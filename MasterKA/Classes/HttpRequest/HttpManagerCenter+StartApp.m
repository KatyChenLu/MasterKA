//
//  HttpManagerCenter+StartApp.m
//  MasterKA
//
//  Created by 余伟 on 16/12/14.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "HttpManagerCenter+StartApp.h"

@implementation HttpManagerCenter (StartApp)


-(RACSignal*)getSubCategoryResultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    
    return [self doRacPost:@"c=ipublic&a=subcategory" parameters:params resultClass:resultClass];
}

-(RACSignal *)bindCategorys:(NSArray *)categorys WithUserResultClass:(Class)resultClass;
{
     NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:categorys forKey:@"category_ids"];
    
    return [self doRacPost:@"c=iuser&a=user_category_link" parameters:params resultClass:resultClass];
}


@end
