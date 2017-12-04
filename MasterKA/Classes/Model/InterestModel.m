//
//  InterestModel.m
//  MasterKA
//
//  Created by jinghao on 16/4/20.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "InterestModel.h"

@implementation InterestModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"interestId" : @"id",
             };
}
@end
