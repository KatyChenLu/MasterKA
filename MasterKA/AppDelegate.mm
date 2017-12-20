//
//  AppDelegate.m
//  MasterKA
//
//  Created by jinghao on 15/12/7.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import <CoreSpotlight/CoreSpotlight.h>
#import "ViewModelServicesImpl.h"
#import "WXApi.h"
#import "GeTuiSdk.h"
#import "UPPaymentControl.h"
#import "UserClient.h"
#import "AdvertisementView.h"
#import "SlideMainViewController.h"
//#import <JSPatch/JSPatch.h>
#import "MasterNotificationView.h"
#import "AppAdView.h"
#import "UserClient.h"
//#import "UMSocial.h"
#import <UserNotifications/UserNotifications.h>
#import "MJExtension.h"
#import "AppRootViewController.h"
#import "KAHomeViewController.h"

BMKMapManager* _mapManager;
UserClient * _userClient;


@interface AppDelegate ()<BMKGeneralDelegate,BMKLocationServiceDelegate,WXApiDelegate,GeTuiSdkDelegate,UNUserNotificationCenterDelegate>
@property (nonatomic, strong) ViewModelServicesImpl *services;
@property (nonatomic, strong)BMKLocationService* locService;
@property (nonatomic,strong)AdvertisementView *advertView;
@property (nonatomic,assign)BOOL appRunning;
@property (nonatomic,strong)NSURL *needOpenUrl;
@property (nonatomic,strong)NSURL *trackViewUrl;
@property (nonatomic,strong)NSDictionary *needNotificationInfo;
@property (nonatomic,assign)BOOL appNewVersion;
@property (nonatomic, assign)BOOL isShowNotification;
@property (nonatomic, strong)NSMutableArray *spnArray;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"==== stat app start ====");
    [self newAppLocationVersion];
    [self registerRemoteNotification];
    
    self.spnArray = [[NSMutableArray alloc] init];
    
    [self initAppConfig];
    //    self.services = [[ViewModelServicesImpl alloc] init];
    [self registerBaiduMap];
    [self startLocationGPS];
    [self registerUrl];
    [self initUmnegSDK];
    
    self.needNotificationInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    if (self.needNotificationInfo==nil)
    {
        self.needNotificationInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsLocalNotificationKey"];
    }
    
    [GeTuiSdk resetBadge]; //重置角标计数
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0]; // APP 清空角标
    
    //    [self createItem];
    //    [self createSpotlight];
    
#ifdef DEBUG
//    UIWindow *debugWindow = (UIWindow *)NSClassFromString(@"UIDebuggingInformationOverlay");
//    [debugWindow performSelector:NSSelectorFromString(@"prepareDebuggingOverlay") withObject:nil];
#endif
    
    NSLog(@"==== stat app end ====");
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [GeTuiSdk resetBadge]; //重置角标计数
    [self.spnArray removeAllObjects];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0]; // APP 清空角标
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
        [self getLoginStaue];
    
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



//回到前台获取登陆状态
- (void)getLoginStaue
{
    //    [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = YES;
     UMSocialUserInfoResponse *input = [UMSocialUserInfoResponse mj_objectWithKeyValues:[UserClient sharedUserClient].UserInfoResponse];
    NSString *myUID =   input.uid;
    
    NSString *myOpenID =   input.openid;
    switch (self.userClient.loginType) {
        case MasterLoginType_Phone:
        {
            @weakify(self)
            [[[HttpManagerCenter sharedHttpManager] loginByPhone:self.userClient.userName password:self.userClient.password resultClass:nil] subscribeNext:^(BaseModel *model) {
                @strongify(self)
                if (model.code==200) {
                    [[UserClient sharedUserClient] setUserName:self.userClient.userName password:self.userClient.password];
                    [[UserClient sharedUserClient] setLoginType:MasterLoginType_Phone];
                    [[UserClient sharedUserClient] setUserInfo:model.data];
                    
                }else {
                    
                    [[UserClient sharedUserClient]setValue:@0 forKey:@"rawLogin"];
                    
                }
                NSLog(@"====1 %@",model.message);
                
            } error:^(NSError *error) {
                NSLog(@"====1 %@",error);
                
            } completed:^{
                
                
            }] ;
            
        }
            break;
        case MasterLoginType_QQ:
        {

            [[[HttpManagerCenter sharedHttpManager] otherLoginByPlatform:UMSocialPlatformType_QQ uid:myUID unionId:myOpenID nickname:nil iconUrl:nil gender:nil resultClass:nil] subscribeNext:^(BaseModel *model) {
                
                if (model.code==200) {
                    [[UserClient sharedUserClient] setLoginTypeName:UMSocialPlatformType_QQ];
                    
                    [[UserClient sharedUserClient] setUserInfo:model.data];
                    
                    
                }else {
                    
                    [[UserClient sharedUserClient]setValue:@0 forKey:@"rawLogin"];
                }
            } error:^(NSError *error) {

            } completed:^{
                
            }];
            
        }
            break;
        case MasterLoginType_Sina:
        {
            
            [[[HttpManagerCenter sharedHttpManager] otherLoginByPlatform:UMSocialPlatformType_Sina uid:myUID unionId:myOpenID nickname:nil iconUrl:nil gender:nil resultClass:nil] subscribeNext:^(BaseModel *model) {
                
                if (model.code==200) {
                    [[UserClient sharedUserClient] setLoginTypeName:UMSocialPlatformType_Sina];
                    
                    [[UserClient sharedUserClient] setUserInfo:model.data];
                    
                    
                }else {
                    
                    [[UserClient sharedUserClient]setValue:@0 forKey:@"rawLogin"];
                }
            } error:^(NSError *error) {
                
            } completed:^{
                
            }];
        }
            break;
        case MasterLoginType_Weixin:
        {
            
            [[[HttpManagerCenter sharedHttpManager] otherLoginByPlatform:UMSocialPlatformType_WechatSession uid: myUID unionId: myOpenID nickname:nil iconUrl:nil gender:nil resultClass:nil] subscribeNext:^(BaseModel *model) {
                
                if (model.code==200) {
                    [[UserClient sharedUserClient] setLoginTypeName:UMSocialPlatformType_WechatSession];
                    
                    [[UserClient sharedUserClient] setUserInfo:model.data];
                    
                    
                }else {
                    
                    [[UserClient sharedUserClient]setValue:@0 forKey:@"rawLogin"];
                }
            } error:^(NSError *error) {
                
                
                
            } completed:^{
                
            }];
            
            /*
             //            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:[UMSocialSnsPlatformManager getSnsPlatformString:UMSocialSnsTypeWechatSession]];
             //            @weakify(self)
             //            [[[HttpManagerCenter sharedHttpManager] otherLoginByPlatform:snsAccount.platformName uid:snsAccount.usid unionId:snsAccount.unionId nickname:snsAccount.userName iconUrl:snsAccount.iconURL gender:@"1" resultClass:nil] subscribeNext:^(BaseModel *model) {
             //                @strongify(self)
             //                if (model.code==200) {
             //                    [[UserClient sharedUserClient] setLoginTypeName:snsAccount.platformName];
             //                    //                [[UserClient sharedUserClient] setLoginInfo:[input ]]
             //                    [[UserClient sharedUserClient] setUserInfo:model.data];
             //
             //
             //
             //                }else {
             //
             //
             //
             //                     [[UserClient sharedUserClient]setValue:@0 forKey:@"rawLogin"];
             //
             //
             //
             //                    NSLog(@"%d" ,[UserClient sharedUserClient].rawLogin );
             //
             //                }
             //            } error:^(NSError *error) {
             //
             //            } completed:^{
             //                //            [self.viewController hiddenHUD];
             //            }];
             */
        }
            break;
        default:
            sleep(1.0f);
            [SharedAppDelegate openAppMainVCT];
            break;
    }
}


- (UserClient*)userClient
{
    if (!_userClient) {
        _userClient = [UserClient sharedUserClient];
    }
    return _userClient;
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //    [UMSocialSnsService  applicationDidBecomeActive];
    
    //    [JSPatch sync];
}

- (void)newAppLocationVersion{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSString* appCode = [userDefault objectForKey:FristStartAppVersionKey];
    if (appCode==nil || ![App_Version isEqualToString:appCode])//新版本
    {
        self.appNewVersion = YES;
    }else{
        self.appNewVersion = NO;
    }
}


#pragma mark -- URL处理

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//    return  [self openApplicationWithURL:url];
//}
//
//
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
//    return  [self openApplicationWithURL:url];
//}

/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //    return  [self openApplicationWithURL:url];
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
        [self openApplicationWithURL:url ];
    }
    return result;
}

- (void)openApplicationWithURL:(NSURL *)url{
    
    if ([url.scheme isEqualToString:UnionpayScheme]) {//银联支付
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            NSLog(@"UPPaymentControl  result = %@",data);
            //结果code为成功时，先校验签名，校验成功后做后续处理
            if([code isEqualToString:@"success"]) {
                //判断签名数据是否存在
                if(data == nil){
                    
                }
                [self paySuccess:1];
            }else if ([code isEqualToString:@"fail"]){
                alertShowMessage(@"支付失败");
            }else if ([code isEqualToString:@"cancel"]){
                alertShowMessage(@"您已取消了支付");
            }
        }];
    }else if ([url.scheme isEqualToString:AlipayScheme]){//支付支付
        //TODO 支付宝支付处理
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@   %@",resultDic,resultDic[@"memo"]);
            NSString* resultStatus = resultDic[@"resultStatus"];
            if ([resultStatus isEqualToString:@"9000"]) {
                [self paySuccess:2];
            }else{
                alertShowMessage(@"支付失败");
            }
        }];
    }else if([url.scheme isEqualToString:WeixinScheme]){//微信支付
        [WXApi handleOpenURL:url delegate:self];
    }else if([url.scheme isEqualToString:@"master"] || [url.scheme hasPrefix:@"http"]){
        if(self.appRunning){
            if ([[MasterUrlManager shareMasterUrlManager] isPrivateUrl:url]) {
                if ([UserClient sharedUserClient].rawLogin) {
                    [[MasterUrlManager shareMasterUrlManager] openURL:url];
                }
            }else{
                [[MasterUrlManager shareMasterUrlManager] openURL:url];
            }
        }else{
            self.needOpenUrl = url;
        }
    }
    
}

- (void)paySuccess:(NSInteger)type{
    [[NSNotificationCenter defaultCenter] postNotificationName:MasterPayResultNotification object:nil];
}
#pragma mark -- 版本检查
- (void)checkVersionForAppstore{

    NSString *updateType = [NSUserDefaults stringForKey:MasterUpdateAppType];
    if (updateType && updateType.integerValue==1) {
        return ;
    }
    NSString* versionUrl = [ NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@",MasterAppId];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* versionData = [NSData dataWithContentsOfURL:[NSURL URLWithString:versionUrl]];
        if(versionData){
            id appData = [NSJSONSerialization JSONObjectWithData:versionData options:NSJSONReadingMutableContainers error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
                if ( ![versionsInAppStore count] ) { // No versions of app in AppStore


                } else {

                    NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
//                    NSArray *versionsReleaseNotes = [[appData valueForKey:@"results"] valueForKey:@"releaseNotes"];

//                    NSString *currentAppStoreReleaseNotes = [versionsReleaseNotes objectAtIndex:0];

                    NSArray *versionsTrackViewUrl = [[appData valueForKey:@"results"] valueForKey:@"trackViewUrl"];

                    if ([App_Version compare:currentAppStoreVersion options:NSNumericSearch] == NSOrderedDescending) {
                        weakSelf.trackViewUrl = [NSURL URLWithString:[versionsTrackViewUrl objectAtIndex:0]];
//                        [weakSelf showAlertWithAppStoreVersion:currentAppStoreReleaseNotes];
                    }

                }
                NSLog(@"==== version %@",appData);
            });
        }
    });
}

- (void)showAlertWithAppStoreVersion:currentAppStoreVersion{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"给我个好评呗~"
                                                        message:currentAppStoreVersion
                                                       delegate:self
                                              cancelButtonTitle:@"立即去"
                                              otherButtonTitles:@"残忍决绝",@"下次再说", nil];

    [alertView show];
    @weakify(self);
    [alertView.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
        @strongify(self);
        if (index.integerValue==2) {
        }else if (index.integerValue==1){
            [NSUserDefaults setObject:@"1" forKey:MasterUpdateAppType];
        }else if (index.integerValue==0){
            [[UIApplication sharedApplication] openURL:self.trackViewUrl];
        }
    }];
}

#pragma mark -- 推送通知



//注册通知
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
    
    NSLog(@"%@" , deviceToken);
    
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [NSUserDefaults setArcObject:token forKey:APP_DeviceToken_Key];
    //向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"====didFailToRegisterForRemoteNotificationsWithError===========%@",error);
}

/** 已登记用户通知 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // 注册远程通知（推送）
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch   SDK
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}
/**
 *  注册通知
 */
- (void)registerRemoteNotification
{
    //注册个推服务
    NSString *deviceTokenId = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    if (deviceTokenId) {
        [NSUserDefaults setArcObject:deviceTokenId forKey:APP_DeviceToken_Key];
    }
    
    [GeTuiSdk startSdkWithAppId:GetuiAppId appKey:GetuiAppKey appSecret:GetuiAppSecret delegate:self];
    // 判读系统版本是否是“iOS 8.0”以上
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ||
        [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        
        // 定义用户通知设置
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        // 注册用户通知 - 根据用户通知设置
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else { // iOS8.0 以前远程推送设置方式
        // 定义远程通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        
        // 注册远程通知 -根据远程通知类型
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)nowWindow {
    
    //    是非支持横竖屏
    
    if(self.isAllScreen==YES){
        return UIInterfaceOrientationMaskLandscapeRight;
        
    }
    else{
        return UIInterfaceOrientationMaskPortrait;
    }
    
}




//-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
//{

//}


//-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
//{

//NSLog(@"%@     --- %@" , center , respone);

　　//[self openNotification:userInfo addLocal:application.applicationState==UIApplicationStateActive];

//}



/**
 *  处理收到的通知
 *
 *  @param userInfo <#notification description#>
 */
- (void)openNotification:(NSDictionary*)userInfo addLocal:(BOOL)addLocal{
    NSLog(@"openNotification  %@",userInfo);
    if(addLocal){
        [self showMAddMessage:userInfo[@"aps"][@"alert"] userInfo:userInfo];
        //        NSDictionary *aps = userInfo[@"aps"];
        //        UILocalNotification *local = [[UILocalNotification alloc] init];
        //        local.userInfo = userInfo;
        //        //设置推送时间
        //        local.fireDate=[NSDate dateWithTimeIntervalSinceNow:0];//立即触发
        //        //设置本地通知的时区
        //        local.timeZone = [NSTimeZone defaultTimeZone];
        //        //推送声音
        //        local.soundName = aps[@"sound"];
        //        //内容
        //        local.alertBody = aps[@"alert"];
        //        //添加推送到uiapplication
        //        UIApplication *app = [UIApplication sharedApplication];
        //        local.applicationIconBadgeNumber = app.applicationIconBadgeNumber+1;
        ////        [app scheduleLocalNotification:local];
        //        [[UIApplication sharedApplication] presentLocalNotificationNow:local];
    }else{
        [self openNotification:userInfo];
    }
}

- (void)openNotification:(NSDictionary*)userInfo
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
    NSDictionary *payload = userInfo[@"payload"];
    if (payload && [payload isKindOfClass:[NSDictionary class]]) {
        NSString *actUrl = payload[@"url"];
        NSString *imageUrl = payload[@"img_url"];
        if(actUrl && ![actUrl isEmpty]){
            [self openApplicationWithURL:[NSURL URLWithString:actUrl]];
        }else if (imageUrl && ![imageUrl isEmpty]) {
            //            self.needOpenUrl = [NSURL URLWithString:actUrl];
            //            [self.advertView.AdImageView setImageWithURLString:imageUrl];
            //            [self.advertView showAnimated:YES inView:self.window];
        }
    }
}

- (void)showMAddMessage:(NSString *)message userInfo:(id)userInfo{
    MasterNotificationView* notificationView = [MasterNotificationView sharedInstance];
    notificationView.userInfo = userInfo;
    __weak AppDelegate* weakSelf = self;
    [notificationView showMessageWithTitle:@"收到通知" description:message type:TWMessageBarMessageTypeInfo callback:^{
        [weakSelf openNotification:userInfo];
    }];
}

- (void)showMAddMessage:(NSString*)message{
    [[MasterNotificationView sharedInstance] showMessageWithTitle:@"友情提醒"
                                                      description:message
                                                             type:TWMessageBarMessageTypeInfo
                                                   statusBarStyle:UIStatusBarStyleLightContent
                                                         callback:nil];
    
}



#pragma mark - APP运行中接收到通知(推送)处理

/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self openNotification:userInfo addLocal:application.applicationState==UIApplicationStateActive];
    
    //    if (application.applicationState == UIApplicationStateActive) {
    //        MasterNotificationView* notificationView = [MasterNotificationView sharedInstance];
    //        notificationView.userInfo = userInfo;
    //        __weak AppDelegate* weakSelf = self;
    //        [notificationView showMessageWithTitle:@"收到通知" description:message type:TWMessageBarMessageTypeInfo callback:^{
    //            [weakSelf openNotification:userInfo];
    //        }];
    //    }
    
    
    NSLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
}




/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    // 处理APN
    NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n", userInfo);
    
    //    completionHandler(UIBackgroundFetchResultNewData);
    [self openNotification:userInfo addLocal:application.applicationState==UIApplicationStateActive];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [self openNotification:notification.userInfo addLocal:NO];
}

#pragma mark - Spotlight &3DTouch

- (void)createSpotlight{
    if([[UIDevice systemVersion] floatValue]>=9.0){
        NSMutableArray <CSSearchableItem *> *searchableItems = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger i=0;i<10;i++) {
            NSString *title = [NSString stringWithFormat:@"Master title%d",i];
            NSString *desc = [NSString stringWithFormat:@"Master desc %d",i];
            NSString *time = [NSString stringWithFormat:@"2017 %d",i];;
            NSString *nid = [NSString stringWithFormat:@"nid%d",i];;
            CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc]initWithItemContentType:@"SearchAPIViews"];
            attributeSet.title = title;
            attributeSet.contentDescription = [NSString stringWithFormat:@"%@\n%@",desc,time];
            NSMutableArray *keywords = [NSMutableArray arrayWithArray:[title componentsSeparatedByString:@" "]];
            [keywords addObject:desc];
            attributeSet.keywords = keywords;
            NSString *identifiner = [NSString stringWithFormat:@"%@",nid];
            [searchableItems addObject:[[CSSearchableItem alloc]initWithUniqueIdentifier:identifiner domainIdentifier:@"com.shishiTec.MasterKA" attributeSet:attributeSet]];
        }
        
        [[CSSearchableIndex defaultSearchableIndex]indexSearchableItems:searchableItems completionHandler:^(NSError * __nullable error) {
            if(error != nil){
                NSLog(@"%@",error.localizedDescription);
            }else {
                NSLog(@"Items were indexed successfully");
            }
        }];
    }
}

-(void) createItem
{
    if([[UIDevice systemVersion] floatValue]<9.0){
        return;
    }
    //自定义icon 的初始化方法
    //    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"your_icon"];
    //    UIMutableApplicationShortcutItem *item0 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"com.your.helloWorld" localizedTitle:@"Title" localizedSubtitle:@"sub Title" icon:icon1 userInfo:nil];
    //这种是随意没有icon 的
    UIMutableApplicationShortcutItem *item1 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"test.com.A" localizedTitle:@"三条A"];
    UIMutableApplicationShortcutItem *item2 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"test.com.B" localizedTitle:@"三条B"];
    UIMutableApplicationShortcutItem *item3 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"test.com.C" localizedTitle:@"三条C"];
    
    NSArray *addArr = @[item2,item3,item1];
    [UIApplication sharedApplication].shortcutItems = addArr;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler{
    //判断先前我们设置的唯一标识
    NSArray *arr = @[@"hello 3D Touch"];
    UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:arr applicationActivities:nil];
    //设置当前的VC 为rootVC
    [self.window.rootViewController presentViewController:vc animated:YES completion:^{
    }];
}

#pragma mark -- 百度地图


- (void)registerBaiduMap{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BaiduMapKey generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
}

- (BMKLocationService*)locService{
    if (!_locService) {
        _locService = [[BMKLocationService alloc] init];
    }
    return _locService;
}

- (void)startLocationGPS{
    self.locService.delegate = self;
    [self.locService startUserLocationService];
}

- (void)stopLocaionGPS{
    [self.locService stopUserLocationService];
    self.locService.delegate = nil;
}

- (void)setLocationInfo:(BMKUserLocation *)locationInfo
{
    _locationInfo = locationInfo;
    if (locationInfo && locationInfo.location) {
        self.locationLat = [NSString stringWithFormat:@"%f",locationInfo.location.coordinate.latitude];
        self.locationLng = [NSString stringWithFormat:@"%f",locationInfo.location.coordinate.longitude];
        
        //        self.locationLat = [NSString stringWithFormat:@"%@" , @"23.132645"];
        //
        //        self.locationLng = [NSString stringWithFormat:@"%@" , @"113.321566"];
        ////
        
        
    }
    
    
    [UserClient sharedUserClient].locationLat = self.locationLat;
    
    [UserClient sharedUserClient].locationLng = self.locationLng;
    
}

#pragma mark --

- (void)initAppConfig{
    HttpManagerCenter* httpCenter = [HttpManagerCenter sharedHttpManager];
    DBHelper *dbHelper = [DBHelper sharedDBHelper];
    [[httpCenter appConfig:[AppConfigModel class]] subscribeNext:^(BaseModel *model) {
        if (model.code == 200) {
            AppConfigModel *configModel = model.data;
            [dbHelper deleteClass:[CityModel class]];
            [dbHelper insertModelArray:configModel.city_list];
            
            [[UserClient sharedUserClient] setAppConfigUrl:configModel];
            NSLog(@"*************%s*********",__func__);
            if (configModel.start_ads && [configModel.start_ads isKindOfClass:[NSDictionary class]] && configModel.start_ads.count>0) {
                NSString *imageUrl = configModel.start_ads[@"pic_url"];
                imageUrl = [imageUrl masterFullImageUrl];
                [[SDWebImageManager sharedManager]  loadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageLowPriority|SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    
                }];
                [NSUserDefaults setObject:configModel.start_ads forKey:StartAppAdKey];
            }else{
                [NSUserDefaults removeObjectWithKey:StartAppAdKey];
            }
              NSLog(@"*************%s*********",__func__);
            if (configModel.start_small_ads && [configModel.start_small_ads isKindOfClass:[NSDictionary class]] && configModel.start_small_ads.count>0) {
                
                NSString *cacheAdIds = [NSUserDefaults stringForKey:StartAppAlertAdIdsKey];
                NSString *curAdId = [NSString stringWithFormat:@"%@,",configModel.start_small_ads[@"ads_data_id"]];
                if (cacheAdIds==nil || [cacheAdIds rangeOfString:curAdId].location ==NSNotFound) {
                    NSString *imageUrl = configModel.start_ads[@"pic_url"];
                    imageUrl = [imageUrl masterFullImageUrl];
                    [[SDWebImageManager sharedManager]  loadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageLowPriority|SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    }];
                    [NSUserDefaults setObject:[NSString stringWithFormat:@"%@%@",cacheAdIds,curAdId] forKey:StartAppAlertAdIdsKey];
                    [NSUserDefaults setObject:configModel.start_small_ads forKey:StartAppAlertAdKey];
                }
            }
              NSLog(@"*************%s*********",__func__);
        }
    }];
}

- (void)showAppAdView{
    if (self.appNewVersion) {//新版本不投放广告。
        return;
    }
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    id adAlterData = [userDefaults objectForKey:StartAppAlertAdKey];
    if (adAlterData) {
        NSString *pfurl = adAlterData[@"pfurl"];
        if(pfurl && ![pfurl isEmpty]){
            self.needOpenUrl = [NSURL URLWithString:adAlterData[@"pfurl"]];
        }
        self.advertView.adData = adAlterData;
//        [self.advertView.AdImageView setImageWithURLString:adAlterData[@"pic_url"]];
        
         NSString* url = [adAlterData[@"pic_url"] masterFullImageUrl];
        
        [self.advertView.AdImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
        [self.advertView showAnimated:YES inView:self.window];
        [userDefaults removeObjectForKey:StartAppAlertAdKey];
        return ;
    }
    
    id adData = [userDefaults objectForKey:StartAppAdKey];
    if (adData && [adData isKindOfClass:[NSDictionary class]]) {
        AppAdView* addAdView = [AppAdView loadInstanceFromNib];
        addAdView.adData = adData;
        
        
       NSString* url = [adData[@"pic_url"] masterFullImageUrl];
        
        
        [addAdView.adImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
        
        addAdView.frame = self.window.bounds;
        [self.window addSubview:addAdView];
        addAdView.appAdFinishBlock = ^() {
            //检查新版本
            [self checkVersionForAppstore];
        };
        addAdView.appAdViewBlock = ^(id data){
            if (data) {
                NSString *pfurl = data[@"pfurl"];
                if(pfurl && ![pfurl isEmpty]){
                    [self performSelector:@selector(openApplicationWithURL:) withObject:[NSURL URLWithString:data[@"pfurl"]] afterDelay:1];
                }
            }else{
                
            }
        };
    }
}

#pragma mark -- BMKGeneralDelegate

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

#pragma mark -- BMKLocationServiceDelegate

/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser{
    
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser{
    
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    self.locationInfo = userLocation;
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    self.locationInfo = userLocation;
    [self stopLocaionGPS];
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    
}
#pragma mark -- 注册Url 路由

- (void)registerUrl{
    MasterUrlManager *urlManager = [MasterUrlManager shareMasterUrlManager];
    [urlManager addStoryboardName:@"UserShare"];
    [urlManager addStoryboardName:@"MasterShare"];
    [urlManager addStoryboardName:@"Mine"];
    [urlManager addStoryboardName:@"Goods"];
    [urlManager addStoryboardName:@"Login"];
    
    [urlManager setViewControllerName:@"MasterShareViewController" forURL:URL_MasterShareChild];
    [urlManager setViewControllerName:@"MasterShareListViewController" forURL:URL_MasterShareList];
    [urlManager setViewControllerName:@"MasterShareDetailViewController" forURL:URL_MasterShareDetail];
    
    [urlManager setViewControllerName:@"CommentListViewController" forURL:URL_ShareCommentList];
    [urlManager setViewControllerName:@"MasterOrUserHomepageViewController" forURL:URL_MasterCenter];
    [urlManager setViewControllerName:@"MasterTagViewController" forURL:URL_MasterTag];
    [urlManager setViewControllerName:@"MasterCourseViewController" forURL:URL_MasterCourse];
    
    [urlManager setViewControllerName:@"ChatingViewController" forURL:URL_IMChating];
    
    
    [urlManager setViewControllerName:@"UserShareDetailViewController" forURL:URL_UserShareDetail];
    
    
    
    [urlManager setViewControllerName:@"MasterWebViewController" forURL:@"web"];
    [urlManager setViewControllerName:@"LoginNavigationController" forURL:URL_MasterLoginRoot];
    [urlManager setViewControllerName:@"MainOrdersViewController" forURL:URL_MasterMineOrderTab];
    [urlManager setViewControllerName:@"MineOrdersViewController" forURL:URL_MasterMineOrderList];
    [urlManager setViewControllerName:@"MineRootViewController" forURL:URL_MasterMineRoot];
    
    
    [urlManager setViewControllerName:@"GoodDetailViewController" forURL:URL_GoodsDetail];
    //    [urlManager setViewControllerName:@"ShopBaseViewController" forURL:URL_Goods];
    [urlManager setViewControllerName:@"SelectOrderVC" forURL:URL_GoodsSelectOrder];
    [urlManager setViewControllerName:@"AddUserShareVC" forURL:URL_AddUserShare];
    
    [urlManager setViewControllerName:@"JiangyouCourceViewController" forURL:URL_JiangyouCourceView];
    [urlManager setViewControllerName:@"ARticleDetailViewController" forURL:URL_ArticleDetail];
    
    //个人中心
    [urlManager setViewControllerNameForPrivate:@"SystemMessageViewController" forURL:URL_MasterMineSystemMsg];
    [urlManager setViewControllerNameForPrivate:@"MineCommentVC" forURL:URL_MasterMineComment];
    [urlManager setViewControllerNameForPrivate:@"MinePrivateListVC" forURL:URL_MasterMinePrivateList];
    [urlManager setViewControllerNameForPrivate:@"MineCourseShare" forURL:URL_MasterMineCourseShare];
    [urlManager setViewControllerNameForPrivate:@"MineMasterOrderListVC" forURL:URL_MasterMineMasterOrderList];
    
    [urlManager setViewControllerNameForPrivate:@"MyOrderDetailController" forURL:URL_MasterMineOrderDetail];
    
    [urlManager setViewControllerNameForPrivate:@"MyCardViewController" forURL:URL_MasterMineCardList];
    [urlManager setViewControllerNameForPrivate:@"MyCouponViewController" forURL:URL_MasterMineCouponList];
    [urlManager setViewControllerNameForPrivate:@"MyScoreViewController" forURL:URL_MasterMineScoreList];
    [urlManager setViewControllerNameForPrivate:@"MineOrdersViewController" forURL:URL_MasterMineOrdersViewController];
    
    [urlManager setViewControllerNameForPrivate:@"ClickLikeController" forURL:URL_MasterClickLikeController];
    
    [urlManager setViewControllerNameForPrivate:@"CardListViewController" forURL:URL_JiangyouCard];
    
    
    [urlManager setViewControllerNameForPrivate:@"ExchangeViewController" forURL:URL_MasterExchangeViewController];
}

#pragma mark --
- (void)openAppMainVCT
{
    if([self.window.rootViewController isKindOfClass:[SlideMainViewController class]]){
        return;
    }
    self.appRunning = YES;
//    AppRootViewController *mainVct = (AppRootViewController *)[UIStoryboard viewController:@"Main" identifier:@"AppRootViewController"];
//    UIViewController *mainVct = [UIStoryboard viewController:@"Main" identifier:@"MainTabBarController"];
//    self.window.rootViewController = mainVct;

    
    UIViewController * vct = [[KAHomeViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vct];
    nav.leftMenu =[[UIStoryboard  storyboardWithName:@"Mine" bundle:nil]instantiateInitialViewController];
   
   
    
    self.window.rootViewController = nav;
    //      [self initAppConfig];
    if(self.needOpenUrl){
        [self performSelector:@selector(openApplicationWithURL:) withObject:self.needOpenUrl afterDelay:1];
        self.needOpenUrl = nil;
    }else if (self.needNotificationInfo){
        [self performSelector:@selector(openNotification:) withObject:self.needNotificationInfo afterDelay:1];
        self.needNotificationInfo = nil;
    }else{
        [self showAppAdView];
    }
 
}

#pragma mark -- 广告处理

- (AdvertisementView*)advertView{
    if (!_advertView) {
        _advertView = [AdvertisementView loadInstanceFromNib];
        _advertView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.8f];
        //        _advertView.cornerRadius = 6.0f;
        @weakify(self);
        [_advertView.AdImageView setTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            @strongify(self);
            [self.advertView hiddenAnimated:YES];
            [self openApplicationWithURL:self.needOpenUrl];
        } ];
    }
    return _advertView;
}

#pragma mark - WXApiDelegate

-(void) onReq:(BaseReq*)res
{
    
}
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
//        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                [self paySuccess:3];
                break;
            case WXErrCodeUserCancel:
                
                break;
            case WXErrCodeCommon:
                
                break;
            case WXErrCodeSentFail:
                
                break;
            case WXErrCodeAuthDeny:
                
                break;
            case WXErrCodeUnsupport:
                
                break;
            default:
//                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
}
#pragma mark -- GeTuiSdkDelegate

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    [NSUserDefaults setArcObject:clientId forKey:APP_GetuiToken_Key];
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}


/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    
    // [4]: 收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
        
        NSDictionary *payload = [self formatGetuiMsg:payloadMsg];
        NSMutableDictionary *spn = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *alert = [[NSMutableDictionary alloc] init];
        [alert setObject:payload[@"content"] forKey:@"alert"];
        
        [spn setObject:alert forKey:@"aps"];
        [spn setObject:payload forKey:@"payload"];
        
        
        
        if (offLine) {
            
            MasterNotificationView* notificationView = [MasterNotificationView sharedInstance];
            notificationView.userInfo = self.spnArray.lastObject;
            __weak AppDelegate* weakSelf = self;
            if (self.isShowNotification) {
                [notificationView hideAllAnimated:NO];
            }
            [self.spnArray addObject:spn];
            
            [notificationView showMessageWithTitle:@"收到通知" description:[NSString stringWithFormat:@"收到了%ld条通知",(unsigned long)self.spnArray.count] type:TWMessageBarMessageTypeInfo callback:^{
                [weakSelf openNotification:self.spnArray.lastObject];
            }];
            
            self.isShowNotification = YES;
        }else{
            
            [self openNotification:spn addLocal:YES];
        }
        
    }
    
    
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    NSLog(@"\n>>>[GexinSdk DidSendMessage]:%@\n\n", msg);
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // [EXT]:通知SDK运行状态
    NSLog(@"\n>>>[GexinSdk SdkState]:%u\n\n", aStatus);
}

/** SDK设置推送模式回调 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        NSLog(@"\n>>>[GexinSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }
    
    NSLog(@"\n>>>[GexinSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}


-(NSDictionary*)formatGetuiMsg:(NSString*)msg{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    msg =  [msg stringByReplacingOccurrencesOfString:@"{" withString:@""];
    msg =  [msg stringByReplacingOccurrencesOfString:@"}" withString:@""];
    NSArray *array = [msg componentsSeparatedByString:@","];
    for(NSString *str in array){
        NSRange range = [str rangeOfString:@"="];
        if(range.location != NSNotFound){
            NSString *key = [str substringToIndex:range.location];
            NSString *value = [str substringFromIndex:range.location+1];
            [dic setObject:value forKey:[key stringByReplacingOccurrencesOfString:@" " withString:@""] ];
        }
    }
    
    
    return dic;
}

@end
