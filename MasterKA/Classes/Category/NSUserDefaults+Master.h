//
//  NSUserDefaults+Master.h
//  MasterKA
//
//  Created by jinghao on 16/5/23.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Master)
+ (NSString *)stringForKey:(NSString *)defaultName;

+ (NSArray *)arrayForKey:(NSString *)defaultName;

+ (NSDictionary *)dictionaryForKey:(NSString *)defaultName;

+ (NSData *)dataForKey:(NSString *)defaultName;

+ (NSArray *)stringArrayForKey:(NSString *)defaultName;

+ (NSInteger)integerForKey:(NSString *)defaultName;

+ (float)floatForKey:(NSString *)defaultName;

+ (double)doubleForKey:(NSString *)defaultName;

+ (BOOL)boolForKey:(NSString *)defaultName;

+ (NSURL *)URLForKey:(NSString *)defaultName;

#pragma mark - WRITE FOR STANDARD

+ (void)setObject:(id)value forKey:(NSString *)defaultName;

+ (void)removeObjectWithKey:(NSString *)defaultName;

#pragma mark - READ ARCHIVE FOR STANDARD

+ (id)arcObjectForKey:(NSString *)defaultName;

#pragma mark - WRITE ARCHIVE FOR STANDARD

+ (void)setArcObject:(id)value forKey:(NSString *)defaultName;

@end
