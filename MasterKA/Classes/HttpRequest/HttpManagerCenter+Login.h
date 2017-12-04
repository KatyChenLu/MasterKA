//
//  HttpManagerCenter+Login.h
//  MasterKA
//
//  Created by jinghao on 16/4/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "HttpManagerCenter.h"

@interface HttpManagerCenter (Login)
/**
 *  手机号登陆系统
 *
 *  @param phone       手机号
 *  @param password    密码
 *  @param resultClass 返回解析对象
 *
 *  @return
 */
- (RACSignal*)loginByPhone:(NSString*)phone password:(NSString*)password resultClass:(Class)resultClass;

/**
 *  发送手机验证码
 *
 *  @param phone       接收手机号
 *  @param codeType    验证码类型 1：注册，2：找回密码
 *  @param resultClass 返回解析对象
 *
 *  @return
 */
- (RACSignal*)sendPhoneCode:(NSString*)phone codeType:(NSString *)codeType resultClass:(Class)resultClass;

/**
 *  注册手机用户
 *
 *  @param phone       手机号
 *  @param phoneCode   验证码
 *  @param password    密码
 *  @param resultClass 返回解析对象
 *
 *  @return
 */
- (RACSignal*)registerByPhone:(NSString*)phone phoneCode:(NSString*)phoneCode password:(NSString*)password resultClass:(Class)resultClass;

/**
 *  第三方登陆
 *
 *  @param platform    第三方平台类型 1：微信，2：qq ，3：新浪微博
 *  @param uid         第三方平台用户id
 *  @param unionId     第三方平台关联id
 *  @param nickname    昵称
 *  @param iconUrl     头像地址
 *  @param gender      性别
 *  @param resultClass 返回解析对象
 *
 *  @return
 */
- (RACSignal*)otherLoginByPlatform:(UMSocialPlatformType)platform uid:(NSString*)uid unionId:(NSString*)unionId  nickname:(NSString*)nickname iconUrl:(NSString*)iconUrl gender:(NSString*)gender resultClass:(Class)resultClass;

/**
 *  重置密码
 *
 *  @param phone       手机号
 *  @param phoneCode   验证码
 *  @param password    新密码
 *  @param resultClass 返回解析对象
 *
 *  @return
 */
- (RACSignal*)resetPasswordByPhone:(NSString*)phone phoneCode:(NSString*)phoneCode password:(NSString*)password resultClass:(Class)resultClass;

/**
 *  找回密码
 *
 *  @param phone       手机号
 *  @param phoneCode   验证码
 *  @param password    密码
 *  @param resultClass 返回解析对象
 *
 *  @return
 */
- (RACSignal*)forgetPasswordByPhone:(NSString*)phone phoneCode:(NSString*)phoneCode password:(NSString*)password resultClass:(Class)resultClass;

/**
 *  找回密码
 *
 *  @param resultClass 返回解析对象
 *
 *  @return
 */
- (RACSignal*)logout:(Class)resultClass;

/**
 *  找回密码
 *
 *  @param原密码
 *  @param新密码
 *  @param resultClass 返回解析对象
 *
 *  @return
 */
- (RACSignal*)resetPassword:(NSString*)password password_new:(NSString*)password_new resultClass:(Class)resultClass;

@end
