//
//  UIResponder+Master.m
//  HiGoMaster
//
//  Created by jinghao on 15/3/17.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import "UIResponder+Master.h"

@implementation UIResponder (Master)
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}
@end
