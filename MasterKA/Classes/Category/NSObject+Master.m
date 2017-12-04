//
//  NSObject+Master.m
//  MasterKA
//
//  Created by jinghao on 16/5/19.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "NSObject+Master.h"

@implementation NSObject (Master)
- (BOOL)isEmpty
{
    BOOL empty = NO;
    if (self==nil || [self isKindOfClass:[NSNull class]]) {
        empty = YES;
    }else if ([self isKindOfClass:[NSString class]] &&((NSString*)self).length<1) {
        empty = YES;
    }
    return empty;
}
@end
