//
//  MasterShareHotModel.m
//  MasterKA
//
//  Created by jinghao on 16/4/25.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MasterShareHotModel.h"

@implementation MasterShareHotModel


- (void)setIs_follow:(NSString *)is_follow
{
    _is_follow = is_follow;
    if (is_follow==nil) {
        self.isFollow = NO;
    }else{
        self.isFollow = [is_follow boolValue];
    }
}


@end
