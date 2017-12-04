//
//  UserShareModel.m
//  MasterKA
//
//  Created by xmy on 16/4/20.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "UserShareModel.h"
#import "NSObject+MJKeyValue.h"
@implementation UserShareModel
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"detail" : @"NSDictionary"
             };
}

+(NSArray*)ignoredProperties{
    return @[@"detail"];
}

- (NSString*)detailJSON{
    if (self.detail) {
        return [self.detail JSONString];
    }else{
        return nil;
    }
}

- (void)setDetailJSON:(NSString *)imgUrls
{
    if (imgUrls) {
        self.detail = [imgUrls JSONObject];
    }
}

@end
