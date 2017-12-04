//
//  UIViewController+Share.h
//  MasterKA
//
//  Created by jinghao on 15/12/21.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>
#import "ThirdShareView.h"
#import "ShopTopImageBtn.h"
//#import "UMSocialSnsService.h"
//#import "UMSocialSnsPlatformManager.h"

@interface UIViewController (Share)

@property(nonatomic ,strong) ThirdShareView * shareView;
- (void)shareContentOfApp:(NSString*)title content:(NSString*)content imageUrl:(NSString*)imageUrl shareToPlatform:(UMSocialPlatformType)type;


- (void)shareContentOfApp:(NSDictionary*)shareInfo;

- (void)shareContentOfApp:(NSString*)title content:(NSString*)content imageUrl:(NSString*)imageUrl linkUrl:(NSString*)linkUrl shareToPlatform:(UMSocialPlatformType)type;

@end
