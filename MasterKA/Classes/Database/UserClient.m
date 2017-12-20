//
//  UserClient.m
//  MasterKA
//
//  Created by jinghao on 16/4/15.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "UserClient.h"
#import "MJExtension.h"

#define MASTER_SERVICE_NAME         @"com.shishiTec.MasterKA"
#define MASTER_RAW_LOGIN            @"RawLogin"
#define MASTER_LOGIN_Type           @"LoginType"
#define MASTER_LOGIN_Info           @"LoginInfo"
#define MASTER_PASSWORD             @"Password"
#define MASTER_USERNAME             @"UserName"
#define MASTER_ACCESS_TOKEN         @"AccessToken"
#define MASTER_LOGIN_USERINFO       @"UserInfo"
#define MASTER_CITY_CODE            @"city_code"
#define MASTER_CITY_NAME            @"city_name"

#define Master_Alias_Name           @"alias_name"
#define Master_Pingyin              @"pingyin"
#define Master_Pic_Url              @"pic_url"
#define MASTER_INFOPES              @"UserInfoResponse"


#define Order_Refund_Msg            @"order_refund_msg"
#define Enterprise_Course_Url       @"enterprise_course_url"
#define Master_Enter_Url            @"master_enter_url"
#define Financial_Data_Url          @"financial_data_url"
#define About_Us_Url                @"about_us_url"
#define About_Card_Url              @"about_card_url"
#define Agree_Url                   @"agree_url"
#define Activity_Url                   @"activity_url"

#define LocationLng                 @"LocationLng"
#define LocationLat                  @"LocationLat"

#define KA_PRICE_MIN                @"course_price_min"
#define KA_PRICE_MAX                @"course_price_max"
#define KA_PEOPLE_NUMMIN            @"people_num_min"
#define KA_PEOPLE_NUMMAX            @"people_num_max"
#define KA_COURSE_TIME              @"course_time"
#define KA_SENCE                    @"sence"
#define KA_REQUIREMENT              @"requirement"



@interface UserClient ()
@property (nonatomic,assign,readwrite)BOOL rawLogin;
@property (nonatomic,assign,readwrite)BOOL isMaster;
@end

@implementation UserClient

+ (instancetype)sharedUserClient{
    static UserClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[UserClient alloc] init];
    });
    
    return _sharedClient;
}

- (id)init{
    if (self=[super init]) {

    }
    return self;
}

//- (BOOL)rawLogin
//{
//    return [[NSUserDefaults standardUserDefaults] boolForKey:MASTER_RAW_LOGIN];
//}

- (NSString*)userName
{
    return [SAMKeychain passwordForService:MASTER_SERVICE_NAME account:MASTER_USERNAME];
}

- (NSString*)password
{
    return [SAMKeychain passwordForService:MASTER_SERVICE_NAME account:MASTER_PASSWORD];
}

- (MasterLoginType)loginType{
    return [[NSUserDefaults standardUserDefaults] integerForKey:MASTER_LOGIN_Type];
}


- (void)setLoginType:(MasterLoginType)type
{
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:MASTER_LOGIN_Type];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)setLoginTypeName:(UMSocialPlatformType)typeName{
    if(typeName == UMSocialPlatformType_QQ){
        [self setLoginType:MasterLoginType_QQ];
    }else if(typeName == UMSocialPlatformType_Sina){
        [self setLoginType:MasterLoginType_Sina];
    }else if(typeName == UMSocialPlatformType_WechatSession){
        [self setLoginType:MasterLoginType_Weixin];
    }
}
- (NSDictionary *)UserInfoResponse {
    return [[NSUserDefaults standardUserDefaults] objectForKey:MASTER_INFOPES];
}

- (void)setUserInfoResponse:(UMSocialUserInfoResponse *)UserInfoResponse {
    NSDictionary *userInfoResponseDic = [UserInfoResponse mj_keyValuesWithIgnoredKeys:@[@"originalResponse"]];
    
    [[NSUserDefaults standardUserDefaults] setObject:userInfoResponseDic forKey:MASTER_INFOPES];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setLoginInfo:(id)loginInfo
{
    [[NSUserDefaults standardUserDefaults] setObject:loginInfo forKey:MASTER_LOGIN_Info];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
 
- (NSDictionary*)loginInfo{
    return [[NSUserDefaults standardUserDefaults] objectForKey:MASTER_LOGIN_Info];
}

- (void)setUserName:(NSString *)userName password:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:MASTER_RAW_LOGIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [SAMKeychain setPassword:password forService:MASTER_SERVICE_NAME account:MASTER_PASSWORD];
    [SAMKeychain setPassword:userName forService:MASTER_SERVICE_NAME account:MASTER_USERNAME];

}

- (void)setUserInfo:(id)userInfo{
    _rawLogin = YES;
//    _isMaster = [userInfo[@"identity"] boolValue];
    if([userInfo[@"identity"] isEqual:@"1"]){
        _isMaster=NO;
    }else{
        _isMaster=YES;
    }
    _userId = userInfo[@"uid"];
    _accessToken = userInfo[@"token"];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:MASTER_LOGIN_USERINFO];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (NSDictionary*)userInfo{
    return [[NSUserDefaults standardUserDefaults] objectForKey:MASTER_LOGIN_USERINFO];
}


- (void)outLogin{
    _rawLogin = NO;
    [self setLoginType:MasterLoginType_none];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MASTER_RAW_LOGIN];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

-(void)outChanegeUid{
_userId = @"0";
}

- (NSString*)city_code{
    NSString *cityCode = [[NSUserDefaults standardUserDefaults] objectForKey:MASTER_CITY_CODE];
    if (cityCode==nil) {
        cityCode = @"sh";
    }
    return cityCode;
}


- (NSString*)city_name{
    NSString *cityname = [[NSUserDefaults standardUserDefaults] objectForKey:MASTER_CITY_NAME];
    if (cityname==nil) {
        cityname = @"上海";
    }
    return cityname;
}



- (void)setCity_code:(NSString*)type{
    [[NSUserDefaults standardUserDefaults] setValue:type forKey:MASTER_CITY_CODE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)setCity_name:(NSString*)type{
    [[NSUserDefaults standardUserDefaults] setValue:type forKey:MASTER_CITY_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (NSArray*)order_refund_msg{
    return [[NSUserDefaults standardUserDefaults] objectForKey:Order_Refund_Msg];
}


- (void)setOrder_refund_msg:(NSArray*)type{
    [[NSUserDefaults standardUserDefaults] setObject:type forKey:Order_Refund_Msg];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSString*)enterprise_course_url{
    return [[NSUserDefaults standardUserDefaults] objectForKey:Enterprise_Course_Url];
}


- (void)setEnterprise_course_url:(NSString*)type{
    [[NSUserDefaults standardUserDefaults] setValue:type forKey:Enterprise_Course_Url];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSString*)master_enter_url{
    return [[NSUserDefaults standardUserDefaults] objectForKey:Master_Enter_Url];
}


- (void)setMaster_enter_url:(NSString*)type{
    [[NSUserDefaults standardUserDefaults] setValue:type forKey:Master_Enter_Url];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSString*)financial_data_url{
    return [[NSUserDefaults standardUserDefaults] objectForKey:Financial_Data_Url];
}


- (void)setFinancial_data_url:(NSString*)type{
    [[NSUserDefaults standardUserDefaults] setValue:type forKey:Financial_Data_Url];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSString*)about_us_url{
    return [[NSUserDefaults standardUserDefaults] objectForKey:About_Us_Url];
}


- (void)setAbout_us_url:(NSString*)type{
    [[NSUserDefaults standardUserDefaults] setValue:type forKey:About_Us_Url];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSString*)about_card_url{
    return [[NSUserDefaults standardUserDefaults] objectForKey:About_Card_Url];
}


- (void)setAbout_card_url:(NSString*)type{
    [[NSUserDefaults standardUserDefaults] setValue:type forKey:About_Card_Url];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSString*)agree_url{
    return [[NSUserDefaults standardUserDefaults] objectForKey:Agree_Url];
}


- (void)setAgree_url:(NSString*)type{
    [[NSUserDefaults standardUserDefaults] setValue:type forKey:Agree_Url];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSString*)activity_url{
    return [[NSUserDefaults standardUserDefaults] objectForKey:Activity_Url];
}


- (void)setActivity_url:(NSString*)type{
    [[NSUserDefaults standardUserDefaults] setValue:type forKey:Activity_Url];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (NSString*)locationLng{
    return [[NSUserDefaults standardUserDefaults] objectForKey:LocationLng];
}


- (void)setLocationLng:(NSString*)type{
    [[NSUserDefaults standardUserDefaults] setValue:type forKey:LocationLng];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSString*)locationLat{
    return [[NSUserDefaults standardUserDefaults] objectForKey:LocationLat];
}


- (void)setLocationLat:(NSString*)type{
    [[NSUserDefaults standardUserDefaults] setValue:type forKey:LocationLat];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}



-(void)setAlias_name:(NSString *)alias_name
{
    [[NSUserDefaults standardUserDefaults] setValue:alias_name forKey:Master_Alias_Name];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)alias_name
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:Master_Alias_Name];
}


-(void)setPingyin:(NSString *)pingyin
{
    [[NSUserDefaults standardUserDefaults] setValue:pingyin forKey:Master_Pingyin];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)pingyin
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:Master_Pingyin];
}

-(void)setPic_url:(NSString *)pic_url
{
    [[NSUserDefaults standardUserDefaults] setValue:pic_url forKey:Master_Pic_Url];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(NSString *)pic_url
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:Master_Pic_Url];
}

////////KA
- (NSString *)course_price_min {
    return [[NSUserDefaults standardUserDefaults] objectForKey:KA_PRICE_MIN];
}
- (void)setCourse_price_min:(NSString *)course_price_min {
    [[NSUserDefaults standardUserDefaults] setValue:course_price_min forKey:KA_PRICE_MIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)course_price_max {
    return [[NSUserDefaults standardUserDefaults] objectForKey:KA_PRICE_MAX];
}
- (void)setCourse_price_max:(NSString *)course_price_max {
    [[NSUserDefaults standardUserDefaults] setValue:course_price_max forKey:KA_PRICE_MAX];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)people_num_min {
    return [[NSUserDefaults standardUserDefaults] objectForKey:KA_PEOPLE_NUMMIN];
}
- (void)setPeople_num_min:(NSString *)people_num_min {
    [[NSUserDefaults standardUserDefaults] setValue:people_num_min forKey:KA_PEOPLE_NUMMIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)people_num_max {
     return [[NSUserDefaults standardUserDefaults] objectForKey:KA_PEOPLE_NUMMAX];
}
- (void)setPeople_num_max:(NSString *)people_num_max {
    [[NSUserDefaults standardUserDefaults] setValue:people_num_max forKey:KA_PEOPLE_NUMMAX];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSArray *)course_time {
    return [[NSUserDefaults standardUserDefaults] objectForKey:KA_COURSE_TIME];
}
-(void)setCourse_time:(NSArray *)course_time {
    [[NSUserDefaults standardUserDefaults] setValue:course_time forKey:KA_COURSE_TIME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSDictionary *)requirement {
    return [[NSUserDefaults standardUserDefaults] objectForKey:KA_REQUIREMENT];
}
- (void)setRequirement:(NSDictionary *)requirement {
    [[NSUserDefaults standardUserDefaults] setValue:requirement forKey:KA_REQUIREMENT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSArray *)sence {
     return [[NSUserDefaults standardUserDefaults] objectForKey:KA_SENCE];
}
-(void)setSence:(NSArray *)sence {
    [[NSUserDefaults standardUserDefaults] setValue:sence forKey:KA_SENCE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setAppConfigUrl:(AppConfigModel*)conf{
    if(conf){
        self.about_us_url = conf.about_us_url;
        self.agree_url = conf.agree_url;
        
        self.course_price_min = conf.course_price_min;
        self.course_price_max = conf.course_price_max;
        self.people_num_min = conf.people_num_min;
        self.people_num_max = conf.people_num_max;
        self.course_time = conf.course_time;
        self.requirement = conf.requirement;
        self.sence = conf.sence;
        
        
//        self.order_refund_msg = conf.order_refund_msg;
//        self.enterprise_course_url = conf.enterprise_course_url;
//        self.master_enter_url = conf.master_enter_url;
//        self.financial_data_url = conf.financial_data_url;
//
//        self.about_card_url = conf.about_card_url;
//
//        self.activity_url = conf.activity_url;
        
    }
}



@end
