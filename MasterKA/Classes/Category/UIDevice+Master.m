//
//  UIDevice+Master.m
//  MasterKA
//
//  Created by jinghao on 15/12/24.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "UIDevice+Master.h"

@implementation UIDevice (Master)

+ (NSString *)systemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

@end
