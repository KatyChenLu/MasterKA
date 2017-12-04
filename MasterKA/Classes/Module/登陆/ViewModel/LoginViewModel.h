//
//  LoginViewModel.h
//  MasterKA
//
//  Created by jinghao on 16/4/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseViewModel.h"

@interface LoginViewModel : BaseViewModel

//用户登录账号
@property (nonatomic,copy) NSString *username;

//用户登录密码
@property (nonatomic,copy) NSString *password;


@property (nonatomic, strong, readonly) RACSignal *validLoginSignal;

/// The command of login button.
@property (nonatomic, strong, readonly) RACCommand *loginCommand;

@property (nonatomic, strong, readonly) RACCommand *otherLoginCommand;

@property (nonatomic, strong) RACCommand *loginSuccessCommand;
@property (nonatomic, strong) RACCommand *loginErrorCommand;

@end
