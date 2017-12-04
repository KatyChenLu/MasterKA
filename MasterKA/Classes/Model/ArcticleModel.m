//
//  ArcticleModel.m
//  MasterKA
//
//  Created by 余伟 on 16/10/11.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "ArcticleModel.h"

@implementation ArcticleModel

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"banner_list" : @"AticleBannerListModel",
             @"article_list" : @"AticleListModel",
             @"category_user_list":@"CategoryUserModel"
             
             };
}


@end
