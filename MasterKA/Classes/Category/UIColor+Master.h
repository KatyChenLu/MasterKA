//
//  UIColor+Master.h
//  MasterKA
//
//  Created by jinghao on 15/12/24.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Master)
/**
 *  @brief  渐变颜色
 *
 *  @param c1     开始颜色
 *  @param c2     结束颜色
 *  @param height 渐变高度
 *
 *  @return 渐变颜色
 */
+ (UIColor *)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;

+ (UIColor *)colorSolidWith:(NSInteger)integer;

+ (UIColor *)colorSolidWith:(NSInteger)integer alpha:(CGFloat)alpha;;

+ (UIColor *)colorWithHex:(UInt32)hex;

+ (UIColor *)colorWithHex:(UInt32)hex alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

- (NSString *)HEXString;



@end
