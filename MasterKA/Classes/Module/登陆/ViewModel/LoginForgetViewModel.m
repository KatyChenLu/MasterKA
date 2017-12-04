//
//  LoginForgetViewModel.m
//  MasterKA
//
//  Created by jinghao on 16/4/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "LoginForgetViewModel.h"

@interface LoginForgetViewModel ()
{
    
}
//从服务器获取的验证码，手机端不做验证码的验证就用不到了
@property (nonatomic,copy)NSString *realPhoneCode;
@property (nonatomic,strong)NSNumber *littleTime ;
@property (nonatomic,strong)NSTimer *codeTimer ;
@property (nonatomic, strong, readwrite) RACSignal *validForgetSignal;
@property (nonatomic, strong, readwrite) RACSignal *validCodeSignal;
@property (nonatomic, strong, readwrite) RACCommand *phoneCodeCommand;
@property (nonatomic, strong, readwrite) RACCommand *forgetCommand;
@property (nonatomic, strong, readwrite) NSString *phoneCodeText;

@end

@implementation LoginForgetViewModel

- (void)initialize{
    [super initialize];
    self.phoneCodeText = @"发送验证码";
    self.littleTime = [NSNumber numberWithInt:0];
    @weakify(self)
    //注册按钮是否可用
    self.validForgetSignal = [[RACSignal
                                 combineLatest:@[ RACObserve(self, phone), RACObserve(self, password), RACObserve(self, phoneCode) ]
                                 reduce:^(NSString *phone, NSString *password, NSString *phoneCode) {
                                     return @(phone.length == 11 && password.length >= 6 && phoneCode.length > 0);
                                 }]
                                distinctUntilChanged];
    
    //验证码按钮是否可用
    self.validCodeSignal = [[RACSignal
                             combineLatest:@[RACObserve(self, phone), RACObserve(self, littleTime) ]
                             reduce:^(NSString *phone, NSNumber *littleTime) {
                                 return @(phone.length == 11 && littleTime.intValue <= 0);
                             }]
                            distinctUntilChanged];
    
    self.phoneCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        [[self.httpService sendPhoneCode:self.phone codeType:@"2" resultClass:nil] subscribeNext:^(BaseModel *model) {
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
    
    
    self.forgetCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.viewController.view endEditing:NO];
        [self.viewController showHUDWithString:@"提交中..."];

        [[self.httpService forgetPasswordByPhone:self.phone phoneCode:self.phoneCode password:self.password resultClass:nil] subscribeNext:^(BaseModel *model) {
            @strongify(self);
            if (model.code==200) {
                //            找回密码后将返回的用户信息保存到本地，关闭页面
                NSMutableDictionary* loginInfo = [NSMutableDictionary dictionary];
                [loginInfo setObject:@"1" forKey:@"type"];
                [loginInfo setObject:self.phone forKey:@"mobile"];
                [loginInfo setObject:self.password forKey:@"password"];
                //            [self.masterGlobal saveLoginUserInfo:loginInfo];
                //            [self dismissLoadingView];
                //            self.masterGlobal.userInfo = data;
                //            [self.yqNavigationController show:FALSE animated:TRUE];
                [self.viewController toastWithString:@"找回成功，请使用新密码登录" error:YES];
                [self.viewController.navigationController popViewControllerAnimated:YES];
            }else{
                [self showRequestErrorMessage:model];
            }
            
        } error:^(NSError *error) {
            
            
            
        } completed:^{
            //            [self.viewController hiddenHUDWithString:nil];
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
