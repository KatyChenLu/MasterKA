//
//  NSMutableURLRequest+Master.m
//  MasterKA
//
//  Created by jinghao on 16/5/31.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "NSMutableURLRequest+Master.h"

@implementation NSMutableURLRequest (Master)
- (void)addMasterHeadInfo
{
    if([self.URL.absoluteString rangeOfString:@"gomaster.cn"].location==NSNotFound){
        return;
    }
    [self addValue:@"1" forHTTPHeaderField:@"master"];
    [self addValue:SharedAppDelegate.locationLat forHTTPHeaderField:@"lat"];
    [self addValue:SharedAppDelegate.locationLng forHTTPHeaderField:@"lng"];
    [self addValue:[UserClient sharedUserClient].city_code forHTTPHeaderField:@"cityCode"];
    [self addValue:[NSString stringWithFormat:@"%.0f x %.0f",ScreenWidth,ScreenHeight] forHTTPHeaderField:@"screen"];
    [self addValue:@"ios" forHTTPHeaderField:@"client"];
    [self addValue:App_Version forHTTPHeaderField:@"appVersion"];
    [self addValue:[[UIDevice currentDevice] systemName] forHTTPHeaderField:@"dBrand"];
    [self addValue:[[UIDevice currentDevice] model] forHTTPHeaderField:@"dModel"];
    [self addValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"osVersion"];
    [self addValue:[HttpManagerCenter sharedHttpManager].networtType forHTTPHeaderField:@"networtType"];
//    NSString *appIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [self addValue:[NSString UUID] forHTTPHeaderField:@"uuid"];
    [self addValue:[UserClient sharedUserClient].accessToken forHTTPHeaderField:@"token"];
}
@end
