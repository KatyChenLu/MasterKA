//
//  AppDelegate+umeng.m
//  MasterKA
//
//  Created by jinghao on 15/12/21.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "AppDelegate+umeng.h"
#import <UMSocialCore/UMSocialCore.h>

#import "UMMobClick/MobClick.h"
//#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
//#import "UMSocialSinaSSOHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"

@implementation AppDelegate (umeng)
- (void)initUmnegSDK{
    
    
    //设置友盟社会化组件appkey
    UMConfigInstance.appKey = UMENG_APPKEY;
    UMConfigInstance.channelId = @"App Store";
    //    UMConfigInstance.eSType = E_UM_GAME; //仅适用于游戏场景，应用统计不用设置
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
    
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
//    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
 
    //lulu_fix
//    [UMSocialData setAppKey:UMENG_APPKEY];
    [[UMSocialManager defaultManager] openLog:YES];
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMENG_APPKEY];
    
    [self configUSharePlatforms];

//    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
//    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];

//    //注册微信
//    [UMSocialWechatHandler setWXAppId:WeixinScheme appSecret:Weixin_APPSECRET url:@"http://www.umeng.com/social"];

//    // 打开新浪微博的SSO开关
//    // 将在新浪微博注册的应用appkey、redirectURL替换下面参数，并在info.plist的URL Scheme中相应添加wb+appkey，如"wb3921700954"，详情请参考官方文档。
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:Weibo_APPKEY
//                                              secret:WeiboAPPSECRET
//                                         RedirectURL:@"https://api.weibo.com/oauth2/default.html"];
//    //注册QQ分享
//    //    //设置分享到QQ空间的应用Id，和分享url 链接
//    [UMSocialQQHandler setQQWithAppId:QQ_APPKEY appKey:QQ_APPSECRET url:@"http://www.umeng.com/social"];
//    //    //设置支持没有客户端情况下使用SSO授权
//    [UMSocialQQHandler setSupportWebView:YES];

    
//#ifdef DEBUG
//    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
//    [UMSocialData openLog:YES];
//#endif

}

- (void)configUSharePlatforms {
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WeixinScheme appSecret:Weixin_APPSECRET redirectURL:@"http://www.umeng.com/social"];
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:Weibo_APPKEY  appSecret:WeiboAPPSECRET redirectURL:@"https://api.weibo.com/oauth2/default.html"];
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_APPKEY/*设置QQ平台的appID*/  appSecret:QQ_APPSECRET redirectURL:@"http://mobile.umeng.com/social"];
    
}
@end
