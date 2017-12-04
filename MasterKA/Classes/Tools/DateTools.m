//
//  DateTools.m
//  MasterKA
//
//  Created by jinghao on 16/5/16.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "DateTools.h"

@implementation DateTools
+(NSDate *)init:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [[NSDateComponents alloc]init];
    dateComponent.year = year;
    dateComponent.month = month;
    dateComponent.day = day;
    return [NSDate dateWithTimeInterval:0 sinceDate:[calendar dateFromComponents:dateComponent]];
}
+(NSDate *)dateByAddingMonths:(NSDate *)startDate andMonth:(NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [[NSDateComponents alloc]init];
    dateComponent.month = month;
    return [calendar dateByAddingComponents:dateComponent toDate:startDate options:NSCalendarMatchNextTime];
}
+(NSInteger)numberOfDaysInMonth:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

+(NSInteger)weekday:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitWeekday fromDate:date].weekday;
}
+(NSInteger)hour:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitHour fromDate:date].hour;
    
}
+(NSInteger)second:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitSecond fromDate:date].second;
    
}
+(NSInteger)minute:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitMinute fromDate:date].minute;
    
}
+(NSInteger)day:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitDay fromDate:date].day;
    
}
+(NSInteger)month:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitMonth fromDate:date].month;
    
}
+(NSInteger)year:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitYear fromDate:date].year;
    
}
+(NSInteger)year:(NSDate*)date afterMonth:(NSInteger)afterMonth{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComp = [calendar components:NSCalendarUnitYear fromDate:date];
    dateComp.month = dateComp.month+afterMonth;
    return dateComp.year;
    
}

+(NSDate*)dateByAddingDays:(NSDate *)date day:(NSInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [[NSDateComponents alloc]init];
    dateComponent.day = day;
    return  [calendar dateByAddingComponents:dateComponent toDate:date options:NSCalendarMatchNextTime];
}
+(BOOL)isDateSameDay:(NSDate *)date andTwoDate:(NSDate *)twoDate
{
    if ([DateTools day:twoDate]==[DateTools day:date]&&[DateTools month:twoDate]==[DateTools month:date]&&[DateTools year:twoDate]==[DateTools year:date]) {
        return YES;
    }
    return NO;
}

+(BOOL)isSaturday:(NSDate*)date{
    
    return ([DateTools getWeekday:date]==7);
}
+(BOOL)isFriday:(NSDate*)date{
    return ([DateTools getWeekday:date]==6);
    
}
+(BOOL)isThursday:(NSDate*)date{
    return ([DateTools getWeekday:date]==5);
    
}
+(BOOL)isWednesday:(NSDate*)date{
    return ([DateTools getWeekday:date]==4);
    
}
+(BOOL)isTuesday:(NSDate*)date;
{
    return ([DateTools getWeekday:date]==3);
    
}
+(BOOL)isMonday:(NSDate*)date{
    return ([DateTools getWeekday:date]==2);
    
}
+(BOOL)isSunday:(NSDate*)date{
    return ([DateTools getWeekday:date]==1);
    
}
+(BOOL)isToday:(NSDate*)date{
    
    return [DateTools isDateSameDay:date andTwoDate:[NSDate date]];
    
}

+(NSInteger)getWeekday:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitWeekday fromDate:date].weekday;
}
+(NSString *)monthNameFull:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM月";
    return [dateFormatter stringFromDate:date];
}
@end
