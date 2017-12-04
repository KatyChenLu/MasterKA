//
//  ShareRootModel.m
//  MasterKA
//
//  Created by xmy on 16/5/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "ShareRootModel.h"

@implementation ShareRootModel
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"banner_list" : @"MasterShareBannerModel",
             @"category_list" : @"MasterCategoryModel",
             };
}

@end
