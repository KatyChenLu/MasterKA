//
//  LoginRegisterViewModel.m
//  MasterKA
//
//  Created by jinghao on 16/4/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "LoginRegisterViewModel.h"

#import "MsgViewController.h"

#import "UserMsgModel.h"

@interface LoginRegisterViewModel ()
{

}
//从服务器获取的验证码
@property (nonatomic,copy)NSString *realPhoneCode;
@property (nonatomic,strong)NSNumber *littleTime ;
@property (nonatomic,strong)NSTimer *codeTimer ;
@property (nonatomic, strong, readwrite) RACSignal *validRegisterSignal;
@property (nonatomic, strong, readwrite) RACSignal *validCodeSignal;
@property (nonatomic, strong, readwrite) RACCommand *phoneCodeCommand;
@property (nonatomic, strong, readwrite) RACCommand *registerCommand;
@property (nonatomic, strong, readwrite) NSString *phoneCodeText;

@end

@implementation LoginRegisterViewModel


- (void)initialize{
    [super initialize];
    self.phoneCodeText = @"发送验证码";
    self.littleTime = [NSNumber numberWithInt:0];
    @weakify(self)
    //注册按钮是否可用
    self.validRegisterSignal = [[RACSignal
                                 combineLatest:@[ RACObserve(self, phone), RACObserve(self, password),RACObserve(self, acceptAgreement),RACObserve(self, phoneCode),RACObserve(self, realPhoneCode) ]
                                 reduce:^(NSString *phone, NSString *password,NSNumber *accept,NSString *phoneCode,NSString *realPhoneCode) {
                                     return @(phone.length == 11 && password.length >=6 && [accept boolValue] && phoneCode.length>0);
                                 }]
                                distinctUntilChanged];
//
    //验证码按钮是否可用
    self.validCodeSignal = [[RACSignal
                              combineLatest:@[RACObserve(self, phone), RACObserve(self, littleTime) ]
                              reduce:^(NSString *phone, NSNumber *littleTime) {
                                  return @(phone.length == 11 && littleTime.intValue <= 0);
                              }]
                             distinctUntilChanged];
    
    self.phoneCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        [[self.httpService sendPhoneCode:self.phone codeType:@"1" resultClass:nil] subscribeNext:^(BaseModel *model) {
            @strongify(self);
            
            if (model.code==200) {
                [self startTimer];
            }else{
                [self showRequestErrorMessage:model];
            }

        } error:^(NSError *error) {
            
        } completed:^{
            
        }];
        
        return [RACSignal empty];
    }];
    
    
    self.registerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [[self.httpService registerByPhone:self.phone phoneCode:self.phoneCode password:self.password resultClass:[UserMsgModel class]] subscribeNext:^(BaseModel *model) {
            @strongify(self);
            if (model.code==200) {
                [self.viewController hiddenHUDWithString:@"注册成功" error:NO];
       
                //完善用户信息界面
//                MsgViewController * msgVc = [[MsgViewController alloc]init];
//                
//                msgVc.data  = model.data;
//                
//              
//                msgVc.passWord = self.password;
//                
//                [self.viewController.navigationController pushViewController:msgVc animated:YES];
           
                
                [self.viewController gotoBack];
            }else{
                [self.viewController hiddenHUDWithString:model.message error:YES];
                [self showRequestErrorMessage:model];
            }
        } error:^(NSError *error) {
            
        } completed:^{
            
        }];
        
        return [RACSignal empty];
    }];
}

- (NSTimer*)startTimer{
    if (!_codeTimer) {
        self.littleTime = [NSNumber numberWithInt:60];
        _codeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTimeAtTimedisplay) userInfo:nil repeats:YES];
    }
    return _codeTimer;
}

- (void)changeTimeAtTimedisplay{
    self.littleTime = [NSNumber numberWithInt:self.littleTime.intValue-1];
    if (self.littleTime.intValue==0) {
        self.phoneCodeText = @"发送验证码";
        [self stopTimer];
    }else{
        self.phoneCodeText = [NSString stringWithFormat:@"发送验证码(%@)",self.littleTime];
    }
}

- (void)stopTimer{
    if (_codeTimer) {
        [_codeTimer invalidate];
    }
    _codeTimer = nil;
}

- (void)dealloc{
    [self stopTimer];
}



@end
