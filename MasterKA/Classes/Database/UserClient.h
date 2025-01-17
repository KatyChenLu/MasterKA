//
//  UserClient.h
//  MasterKA
//
//  Created by jinghao on 16/4/15.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "SSKeychain.h"
#import "AppConfigModel.h"
#import <SAMKeychain.h>

typedef NS_ENUM(NSInteger, MasterLoginType) {
    MasterLoginType_none = 0,
    MasterLoginType_Phone ,
    MasterLoginType_QQ,
    MasterLoginType_Weixin,
    MasterLoginType_Sina
};

@interface UserClient : NSObject
@property (nonatomic,readonly)BOOL rawLogin;                //是否已经登陆
@property (nonatomic,readonly)BOOL isMaster;                //是否是达人

@property (nonatomic,readonly)NSString* userName;           //已登录的手机号
@property (nonatomic,readonly)NSString* password;           //已登录的密码
@property (nonatomic,readonly)NSString* accessToken;        //访问的token
@property (nonatomic,readonly)MasterLoginType loginType;    //登陆类型
@property (nonatomic,strong)NSDictionary *loginInfo;        //第三方登陆信息
@property (nonatomic,strong)NSDictionary *userInfo;         //用户信息
@property (nonatomic,strong)NSString *userId;               //用户信息
@property (nonatomic,strong)NSString *city_code;            //城市代码
@property (nonatomic,strong)NSString *alias_name;           //城市别名
@property (nonatomic,strong)NSString *pingyin;              //拼音
@property (nonatomic,strong)NSString *pic_url;              //图片


@property (nonatomic, strong)UMSocialUserInfoResponse *UserInfoResponse;


//当前经度
@property (nonatomic,strong)NSString *locationLng;
//当前维度
@property (nonatomic,strong)NSString *locationLat;



@property(nonatomic ,strong)NSString * city_name;

@property (nonatomic,strong)NSArray *order_refund_msg;
@property (nonatomic,strong)NSString *enterprise_course_url;//企业课链接
@property (nonatomic,strong)NSString *master_enter_url;//达人入驻链接
@property (nonatomic,strong)NSString *financial_data_url;//财务统计链接

@property (nonatomic,strong)NSString *about_card_url;//酱油卡说明链接

@property (nonatomic,strong)NSString *activity_url;//活动链接





////////////////////FOR KA

@property (nonatomic, assign)NSInteger voteNum;
//最小团建价格
@property (nonatomic, strong)NSString *course_price_min;
//最大团建价格
@property (nonatomic, strong)NSString *course_price_max;
//最小团建人数
@property (nonatomic, strong)NSString *people_num_min;
//最大团建人数
@property (nonatomic, strong)NSString *people_num_max;
//团建上课时间
@property (nonatomic, strong)NSArray *course_time;
//关于我们链接
@property (nonatomic,strong)NSString *about_us_url;
//使用协议链接
@property (nonatomic,strong)NSString *agree_url;
//
@property (nonatomic, strong)NSArray *sence;
//定制需求信息
@property (nonatomic,strong)NSDictionary *requirement;
//400电话
@property (nonatomic,strong)NSString *server_number;



+ (instancetype)sharedUserClient;

- (void)setUserName:(NSString*)userName password:(NSString*)password;

- (void)setLoginType:(MasterLoginType)type;
- (void)setLoginTypeName:(UMSocialPlatformType)typeName;

- (void)outLogin;
-(void)outChanegeUid;

- (void)setAppConfigUrl:(AppConfigModel*)conf;

- (void)setAppConfigUrlFormDic:(NSDictionary*)conf;
@end
