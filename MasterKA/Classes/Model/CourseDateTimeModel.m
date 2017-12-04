//
//  CourseDateTimeModel.m
//  MasterKA
//
//  Created by jinghao on 16/5/17.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "CourseDateTimeModel.h"


@implementation CourseTimeModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"timeId" : @"id",
             };
}

- (NSInteger)selectedNum
{
    if (_selectedNum==0) {
        _selectedNum = 1;
    }
    return _selectedNum;
}

@end

@interface CourseDateTimeModel ()
@property (nonatomic,strong,readwrite)NSDate *startDate;
@property (nonatomic,strong,readwrite)NSString *startDateShortStr;
@end

@implementation CourseDateTimeModel

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"time_list" : @"CourseTimeModel"
             };
}

- (NSDate*)startDate
{
    if (_startDate==nil) {
        _startDate = [NSDate dateWithTimeIntervalSince1970:self.start_date.doubleValue];
    }
    return _startDate;
}

- (NSString*)startDateShortStr
{
    if (_startDateShortStr == nil) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"YYYY/MM/dd"];
        _startDateShortStr = [df stringFromDate:self.startDate];
    }
    return _startDateShortStr;
}

@end
