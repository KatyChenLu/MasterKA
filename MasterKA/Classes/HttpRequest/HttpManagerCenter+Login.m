//
//  HttpManagerCenter+Login.m
//  MasterKA
//
//  Created by jinghao on 16/4/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "HttpManagerCenter+Login.h"

@implementation HttpManagerCenter (Login)
- (RACSignal*)loginByPhone:(NSString*)phone password:(NSString*)password resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:[NSUserDefaults arcObjectForKey:APP_DeviceToken_Key] forKey:@"deviceToken"];
    [params setObjectNotNull:[NSUserDefaults arcObjectForKey:APP_GetuiToken_Key] forKey:@"clientId"];
    [params setObjectNotNull:phone forKey:@"mobile"];
    [params setObjectNotNull:[password md5HexDigest] forKey:@"password"];
    return [self doRacPost:@"c=iuser&a=login" parameters:params resultClass:resultClass];
}
//发送验证码
- (RACSignal*)sendPhoneCode:(NSString*)phone codeType:(NSString *)codeType resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:phone forKey:@"mobile"];
    [params setObjectNotNull:codeType forKey:@"type"];
    return [self doRacPost:@"c=iuser&a=verify_sms" parameters:params resultClass:resultClass];
}


- (RACSignal*)registerByPhone:(NSString*)phone phoneCode:(NSString*)phoneCode password:(NSString*)password resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:phone forKey:@"mobile"];
    [params setObjectNotNull:phoneCode forKey:@"code"];
    [params setObjectNotNull:[password md5HexDigest] forKey:@"password"];
    return [self doRacPost:@"c=iuser&a=regist" parameters:params resultClass:resultClass];
}


- (RACSignal*)otherLoginByPlatform:(UMSocialPlatformType)platform uid:(NSString*)uid unionId:(NSString*)unionId  nickname:(NSString*)nickname iconUrl:(NSString*)iconUrl gender:(NSString*)gender resultClass:(Class)resultClass{
    
 
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:[NSUserDefaults arcObjectForKey:APP_DeviceToken_Key] forKey:@"deviceToken"];
    [params setObjectNotNull:[NSUserDefaults arcObjectForKey:APP_GetuiToken_Key] forKey:@"clientId"];
    NSString *platformStr = nil;
    if (platform ==UMSocialPlatformType_WechatSession) {
        
        [params setObjectNotNull:unionId forKey:@"weixin_id"];
        platformStr=@"wechat";
    }else if (platform ==UMSocialPlatformType_Sina) {
        platformStr=@"weibo";
    }else if (platform == UMSocialPlatformType_QQ){
        platformStr=@"qq";
    }
    [params setObjectNotNull:platformStr forKey:@"login_type"];

    [params setObjectNotNull:uid forKey:@"third_party_id"];
    
    [params setObjectNotNull:nickname forKey:@"nikename"];
    [params setObjectNotNull:iconUrl forKey:@"img_top"];
    
    NSString *sex = @"0";
    if ([gender isEqualToString:@"男"]) {
        sex = @"1";
    }else if ([gender isEqualToString:@"女"]) {
        sex = @"2";
    }else if ([gender isEqualToString:@"f"]) {
        sex = @"2";
    }else{
        sex = @"2";
    }
    
    
    [params setObjectNotNull:sex forKey:@"sex"];

    return [self doRacPost:@"c=iuser&a=login_third_party" parameters:params resultClass:resultClass];
}


- (RACSignal*)resetPasswordByPhone:(NSString*)phone phoneCode:(NSString*)phoneCode password:(NSString*)password resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:phone forKey:@"mobile"];
    [params setObjectNotNull:phoneCode forKey:@"code"];
    [params setObjectNotNull:[password md5HexDigest] forKey:@"password"];
    return [self doRacPost:@"c=iuser&a=find_password" parameters:params resultClass:resultClass];
}

- (RACSignal*)forgetPasswordByPhone:(NSString*)phone phoneCode:(NSString*)phoneCode password:(NSString*)password resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:phone forKey:@"mobile"];
    [params setObjectNotNull:phoneCode forKey:@"code"];
    [params setObjectNotNull:[password md5HexDigest] forKey:@"password"];
    return [self doRacPost:@"c=iuser&a=find_password" parameters:params resultClass:resultClass];
}

- (RACSignal*)logout:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:[NSUserDefaults arcObjectForKey:APP_DeviceToken_Key] forKey:@"deviceToken"];
    [params setObjectNotNull:[NSUserDefaults arcObjectForKey:APP_GetuiToken_Key] forKey:@"clientId"];
    return [self doRacPost:@"c=iuser&a=logout" parameters:params resultClass:resultClass];
}

- (RACSignal*)resetPassword:(NSString*)password password_new:(NSString*)password_new resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:[password md5HexDigest] forKey:@"password"];
    [params setObjectNotNull:[password_new md5HexDigest] forKey:@"password_new"];
    return [self doRacPost:@"c=iuser&a=reset_pwd" parameters:params resultClass:resultClass];
}


@end
