//
//  AllCategoryModel.m
//  MasterKA
//
//  Created by 余伟 on 16/12/13.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "AllCategoryModel.h"

@implementation AllCategoryModel

+(NSDictionary *)replacedkeyFromPropertyName
{
    
    return @{
             @"ID":@"id"
             };
}


+(NSDictionary *)objectClassInArray
{
    return @{@"sub_category_list":@"SubCategoryModel"};
}

@end
