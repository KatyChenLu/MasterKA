//
//  MasterShareListModel.m
//  MasterKA
//
//  Created by jinghao on 16/4/25.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MasterShareListModel.h"

@implementation MasterShareListModel
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"share_list" : @"MasterShareModel",
             @"master_list" : @"MasterShareHotModel",
             @"banner_list" : @"MasterShareBannerModel"
             };
}
@end
