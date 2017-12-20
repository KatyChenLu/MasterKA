//
//  KAFristHomeModel.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/4.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAFristHomeModel.h"

@implementation KAFristHomeModel
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"banner" : @"KABannerModel",
             @"course_lists" : @"KAHomeListModel"
             };
}

@end
