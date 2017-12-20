//
//  AppConfig.h
//  MasterKA
//
//  Created by jinghao on 15/12/18.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h

//#define DEBUG_VIEW YES

#ifdef DEBUG
#   define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define NSLog(...)
#endif


#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define CustomTabBarHeight 49

#define LoginViewShowHideAniTime 0.4


#define APP_DeviceToken_Key @"app_deviceToken_key"
#define APP_GetuiToken_Key @"app_getuiToken_Key"

//友盟AppKey
//#define UMENG_APPKEY @"55482f9b67e58e8f9400c1bf"
#define UMENG_APPKEY @"5a17b300a40fa32895000260"
//支付宝
#define AlipayScheme @"MasterAlipay"
//银联 Scheme
#define UnionpayScheme @"MasterUnionpay"

//#define JSPATCH_APPKEY @"699c155a9fc54ac5"
//#define JSPATCH_APPKEY_YW @"84f44cd34b9c6b79"

//新浪微博
#define WeiboScheme @"wb3789703762"
#define Weibo_APPKEY @"3789703762"
#define WeiboAPPSECRET @"48d969703d542b0ae162659aa69a2718"
#define Weibo_Callback @"3789703762"

//微信以
//#define WeixinScheme @"wx00d2ac16fd629e08"
#define WeixinScheme @"wxa094413f8976fb27"
//#define Weixin_APPSECRET @"f7ac824dce38e6936ef4579beb0eb81e"
#define Weixin_APPSECRET @"ef9ffdbd2921a456ec1e67953ca3c331"
//QQ分享
#define QQShareScheme @"QQ41C44DB0"
#define QQLoginScheme @"tencent1103383984"
//#define QQ_APPKEY @"1103383984"
#define QQ_APPKEY @"1105614865"

//#define QQ_APPSECRET @"F95UcuIsDizEHkCv"
#define QQ_APPSECRET @"0BF0kzfwpC7WNllz"
//百度key
#define BaiduMapKey         @"29CGn5ukIySODezqiwabEHSlsdyIEPGE"
//个推公司账号
#define GetuiAppId           @"1nXCAuCpvh5hgjoBKQBXQ8"
#define GetuiAppKey          @"pfuoLMMjir8MAOe1GzL5S9"
#define GetuiAppSecret       @"yFqpygFpiJ74UE5RNjrMA1"

//客服电话
#define CustomerServicePhone @"4008852446"


#define SharedAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)


//颜色

#define MasterDefaultColor [UIColor colorWithHex:0xFFE326]

#define MasterBackgroundColer [UIColor colorWithHex:0xEFEFF4]
//自定义Url
#define URL_MasterLoginRoot @"master://nmpublic_login"
#define URL_MasterShareChild @"master://masterShareChild"
#define URL_MasterShareList @"master://masterShareList"
#define URL_MasterShareDetail @"master://nmshare_master_detail"
#define URL_ShareCommentList @"master://shareCommentList"
#define URL_MasterCenter @"master://nmuser_master"
#define URL_MasterTag @"master://masterTagList"
#define URL_MasterCourse @"master://masterCourseList"
#define URL_IMChating @"master://masterIMChating"

#define URL_GoodsSelectOrder @"master://goodsSelectOrder"
#define URL_AddUserShare @"master://addUserShare"
#define URL_GoodsDetail @"master://nmcourse_detail"

#define URL_Goods @"master://nmcourse_index"

#define URL_UserShareDetail @"master://nmshare_user_detail"
#define URL_JiangyouCourceView @"master://nmcourse_card_course_lists"
#define URL_ArticleDetail @"master://nmarticle_detail"
#define URL_JiangyouCard @"master://nmcard_index"


//自定义Url------个人中心
#define URL_MasterMineOrderTab @"master://mine/orderTab"
#define URL_MasterMineOrderList @"master://mineOrderList"
#define URL_MasterMineMasterOrderList @"master://mineMasterOrderList"
#define URL_MasterMineRoot @"master://mine/root"
#define URL_MasterMineSystemMsg @"master://mineSystemMsg"
#define URL_MasterMineComment @"master://nmcomment_list"
#define URL_MasterMinePrivateList @"master://nmnews_list"
#define URL_MasterMineCourseShare @"master://mineCourseShare"

#define URL_MasterMineOrderDetail @"master://nmorder_detail"

#define URL_MasterMineCardList @"master://nmmy_my_card"
#define URL_MasterMineCouponList @"master://nmmy_my_coupon"
#define URL_MasterMineScoreList @"master://nmmy_mym_score"
#define URL_MasterMineOrdersViewController @"master://nmmy_my_MineOrders"
#define URL_MasterClickLikeController @"master://nmmy_my_like_list"
#define URL_MasterExchangeViewController @"master://nmmy_gift?"



#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define IS_IOS_11 @available(iOS 11.0, *)
#define IsPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? [[UIScreen mainScreen] currentMode].size.height == 2436.0 : NO)
#define MasterNavberHeight (([[[UIDevice currentDevice] localizedModel] isEqualToString:@"iPhone10,5"])?(88):(64))
#define MasterTabberHeight (([[[UIDevice currentDevice] localizedModel] isEqualToString:@"iPhone10,5"])?(80):(49))
// app名称
#define App_Name [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
// app版本
#define App_Version   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// app build版本
#define App_build  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#define SystemVerison [[[UIDevice currentDevice] systemVersion] floatValue]

#define RatioBase5(x) 1.0f*ScreenWidth*x/320
#define RatioBase6(x) 1.0f*ScreenWidth*x/375
#define RatioBase6s(x) 1.0f*ScreenWidth*x/414


////com.shishiTec.MasterKA
//#define API_DOMAIN @"https://rest3.gomaster.cn/index.php"
//#define WEB_DOMAIN @"https://www.gomaster.cn"
//#define IMAGE_DOMAIN @"https://resx.gomaster.cn/attms"


////com.shishiTec.lulDev
#define API_DOMAIN @"https://kaifa.gomaster.cn/rest/index.php"
#define WEB_DOMAIN @"https://kaifa.gomaster.cn"
#define IMAGE_DOMAIN @"https://kaifa.gomaster.cn/attms"

//百度key_lul_debug
//#define BaiduMapKey         @"EA9P2ggohqd2Xe0DeGVD5gyY45fQ36S7"

#define SpecialFont ([[UIDevice currentDevice] systemVersion].floatValue >=9.0)?@"PingFangSC-Light":@".PingFang-SC-Light"

#define Rest_Version @"3.0"

#define MasterAppId @"925646944"
#define MasterUpdateAppType  [NSString stringWithFormat:@"updateAppKey_%@",App_Version]


#define MasterPayResultNotification @"MasterPayResultNotification"
#define MasterUserLoginNotification @"MasterUserLoginNotification"
#define MasterRealseShareNotification @"MasterRealseShareNotification"

//缓存key
#define FristStartAppVersionKey @"fristStartApp"

#define StartAppAdKey @"StartAdData"
#define StartAppAlertAdKey @"StartAppAlertAdData"
#define StartAppAlertAdIdsKey @"StartAppAlertAdIdsData"

//设定色值
#define RGBFromHexadecimal(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]

/*!
 @enum
 @brief 聊天类型
 @constant eMessageBodyType_Text 文本类型
 @constant eMessageBodyType_Image 图片类型
 @constant eMessageBodyType_Video 视频类型
 @constant eMessageBodyType_Location 位置类型
 @constant eMessageBodyType_Voice 语音类型
 @constant eMessageBodyType_File 文件类型
 @constant eMessageBodyType_Command 命令类型
 */
typedef enum {
    eMessageBodyType_Text = 1,
    eMessageBodyType_Image,
    eMessageBodyType_Video,
    eMessageBodyType_Location,
    eMessageBodyType_Voice,
    eMessageBodyType_File,
    eMessageBodyType_Command
}MessageBodyType;

/*!
 @enum
 @brief 聊天消息发送状态
 @constant eMessageDeliveryState_Pending 待发送
 @constant eMessageDeliveryState_Delivering 正在发送
 @constant eMessageDeliveryState_Delivered 已发送, 成功
 @constant eMessageDeliveryState_Failure 已发送, 失败
 */
typedef enum {
    eMessageDeliveryState_Pending = 0,
    eMessageDeliveryState_Delivering,
    eMessageDeliveryState_Delivered,
    eMessageDeliveryState_Failure
}MessageDeliveryState;

#endif /* AppConfig_h */
