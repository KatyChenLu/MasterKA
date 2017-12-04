//
//  CategoryUserModel.m
//  MasterKA
//
//  Created by 余伟 on 16/10/11.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "CategoryUserModel.h"

@implementation CategoryUserModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"category_list_id" : @"id",
             };
}

@end
