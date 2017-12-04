//
//  MasterSearchListModel.m
//  MasterKA
//
//  Created by lijiachao on 16/9/30.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MasterSearchListModel.h"

@implementation MasterSearchListModel
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"share_list" : @"MasterShareModel",
             @"master_list" : @"HostManShareModel",
             @"banner_list" : @"MasterShareBannerModel"
             };
}
@end
