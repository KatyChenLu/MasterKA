//
//  NSString+MasterTime.h
//  MasterKA
//
//  Created by ChenLu on 2017/4/25.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MasterTime)

/**
 获取当前系统时间戳
 
 @return <#return value description#>
 */
- (NSString *)getCurrentTimestamp;

- (NSString *)getTime;

/**
 将某个时间转换为时间戳
 
 @param formatTime 时间
 @param format 时间格式 （@"YYYY-MM-dd hh:mm:ss"）--设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
 @return <#return value description#>
 */
- (NSString *)timeSwitchTimestamp:(NSString *)forxxmatTime
                     andFormatter:(NSString *)format;

/**
 将某个时间戳转换为时间
 
 @param timestamp 时间戳
 @param format （@"YYYY-MM-dd hh:mm:ss"）--设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
 @return <#return value description#>
 */
+(NSString *)timestampSwitchTime:(NSInteger)timestamp
                    andFormatter:(NSString *)format;
@end
