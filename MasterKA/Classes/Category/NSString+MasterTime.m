//
//  NSString+MasterTime.m
//  MasterKA
//
//  Created by ChenLu on 2017/4/25.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "NSString+MasterTime.h"

@implementation NSString (MasterTime)
#pragma mark - 时间和时间戳的互相转换

- (NSString *)getTime{
    NSDateFormatter *dateFormatter = [ [NSDateFormatter alloc] init ];
    [dateFormatter setDateFormat:@"MMddHHmmssSSS"];
    NSDate *now = [NSDate date];
    NSString *stime = [dateFormatter stringFromDate:now];
    return stime;
}

//获取当前系统时间的时间戳
- (NSString *)getCurrentTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    //设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    //现在时间
    NSDate *datenow = [NSDate date];
    
    NSLog(@"设备当前的时间:%@",[formatter stringFromDate:datenow]);
    
    //时间转时间戳的方法:
    NSNumber *timeSp = [NSNumber numberWithDouble:[datenow timeIntervalSince1970]];
    //时间戳的值
    NSString *timeStamp = [NSString stringWithFormat:@"%@", timeSp];
    NSLog(@"设备当前的时间戳:%@", timeStamp);
    
    return timeStamp;
}
//将某个时间转换为时间戳
- (NSString *)timeSwitchTimestamp:(NSString *)formatTime
                     andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //(@"YYYY-MM-dd hh:mm:ss") 设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:format];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    //将字符串按formatter转成nsdate
    NSDate* date = [formatter dateFromString:formatTime];
    
    //时间转时间戳的方法:
    //NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    NSNumber *timeSp = [NSNumber numberWithDouble:[date timeIntervalSince1970]];
    NSString *timestamp = [NSString stringWithFormat:@"%@", timeSp];
    NSLog(@"将某个时间转化成 时间戳&&&&&&&timeSp:%@", timestamp); //时间戳的值
    
    return timestamp;
}
//将某个时间戳转化成时间
+ (NSString *)timestampSwitchTime:(NSInteger)timestamp
                     andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //（@"YYYY-MM-dd hh:mm:ss"）设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    if (format.length) {
        [formatter setDateFormat:format];
    }else{
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    }
    //  @"Asia/Shanghai"
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    
    return confromTimespStr;
}
@end
