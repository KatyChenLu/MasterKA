//
//  LoginForgetViewModel.h
//  MasterKA
//
//  Created by jinghao on 16/4/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseViewModel.h"

@interface LoginForgetViewModel : BaseViewModel



//验证码倒计时提醒文字
@property (nonatomic,strong,readonly) NSString *phoneCodeText;

//注册手机号
@property (nonatomic,copy) NSString *phone;
//手机验证码
@property (nonatomic,copy) NSString *phoneCode;
//注册密码
@property (nonatomic,copy) NSString *password;

@property (nonatomic, strong, readonly) RACSignal *validForgetSignal;

@property (nonatomic, strong, readonly) RACSignal *validCodeSignal;

//获取手机号验证码
@property (nonatomic, strong, readonly) RACCommand *phoneCodeCommand;

//注册
@property (nonatomic, strong, readonly) RACCommand *forgetCommand;


@end
