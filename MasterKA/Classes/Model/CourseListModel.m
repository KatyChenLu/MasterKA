//
//  CourseListModel.m
//  MasterKA
//
//  Created by xmy on 16/5/11.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "CourseListModel.h"

@implementation CourseListModel

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"course_list" : @"CourseModel",
             @"subject_list" : @"SubCourseModel",
             @"item_list" : @"ItemCourseModel"};
}

@end
