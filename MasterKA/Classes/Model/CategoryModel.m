//
//  CategoryModel.m
//  MasterKA
//
//  Created by jinghao on 16/4/20.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"categoryId" : @"id",
             };
}
@end
