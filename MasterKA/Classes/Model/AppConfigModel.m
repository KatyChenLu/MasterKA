//
//  AppConfigModel.m
//  MasterKA
//
//  Created by jinghao on 16/4/20.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "AppConfigModel.h"

@implementation AppConfigModel
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"city_list" : @"CityModel",
             @"category_list" : @"CategoryModel",
             @"superscript_list" : @"SuperscriptModel",
             @"interest_list" : @"InterestModel",
             @"order_type" : @"OrderTypeModel",
             @"select_type" : @"SelectTypeModel",
             @"category_user_list":@"CategoryUserModel"
             
             };
}

@end
