//
//  BindPhoneModel.h
//  MasterKA
//
//  Created by 余伟 on 16/7/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseViewModel.h"

@interface BindPhoneModel :BaseViewModel


//验证码倒计时提醒文字
@property (nonatomic,strong,readonly) NSString *phoneCodeText;

//注册手机号
@property (nonatomic,copy) NSString *phone;

//手机验证码
@property (nonatomic,copy) NSString *phoneCode;

//是否同意协议
@property (nonatomic) BOOL acceptAgreement;

//获取手机号验证码
@property (nonatomic, strong, readonly) RACCommand *phoneCodeCommand;


//确定
@property (nonatomic, strong, readonly) RACCommand *determineCommand;


@property (nonatomic, strong, readonly) RACSignal *validDetermineSignal;

@property (nonatomic, strong, readonly) RACSignal *validCodeSignal;



@end
