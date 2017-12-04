//
//  LoginViewModel.m
//  MasterKA
//
//  Created by jinghao on 16/4/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "LoginViewModel.h"
//#import "UMSocial.h"
#import "MsgViewController.h"

@interface LoginViewModel ()

@property (nonatomic, strong, readwrite) RACSignal *validLoginSignal;
@property (nonatomic, strong, readwrite) RACCommand *loginCommand;
@property (nonatomic, strong, readwrite) RACCommand *otherLoginCommand;

@end

@implementation LoginViewModel

- (void)initialize {
    [super initialize];
    @weakify(self)
    //账号密码的长度必须都大于0
    self.validLoginSignal = [[RACSignal
                              combineLatest:@[ RACObserve(self, username), RACObserve(self, password) ]
                              reduce:^(NSString *username, NSString *password) {
                                  return @(username.length == 11 && password.length >= 6);
                              }]
                             distinctUntilChanged];
    
    self.loginSuccessCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self.viewController.navigationController dismissViewControllerAnimated:YES completion:^{
            [[GCDQueue mainQueue] queueBlock:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:MasterUserLoginNotification object:nil];

            } afterDelay:0.5f];
        }];
        return [RACSignal empty];
    }];
    
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self.viewController.view endEditing:NO];
//        [self.viewController showHUDWithString:@"登录中..."];
        [[self.httpService loginByPhone:self.username password:self.password resultClass:nil] subscribeNext:^(BaseModel *model) {
            @strongify(self)
            if (model.code==200) {
                [[UserClient sharedUserClient] setUserName:self.username password:self.password];
                [[UserClient sharedUserClient] setLoginType:MasterLoginType_Phone];
                [[UserClient sharedUserClient] setUserInfo:model.data];
                [self.viewController hiddenHUDWithString:@"登录成功" error:NO];
                [self.loginSuccessCommand execute:nil];
            }else {
//                [self.viewController hiddenHUDWithString:model.message error:YES];
                [self showRequestErrorMessage:model];
                if (self.loginErrorCommand) {
                    [self.loginErrorCommand execute:nil];
                }
            }
            NSLog(@"====1 %@",model.message);
            
        } error:^(NSError *error) {
            NSLog(@"====1 %@",error);
        } completed:^{
            @strongify(self)
            [self.viewController hiddenHUD];
        }] ;
        return [RACSignal empty];
    }];
    
    self.otherLoginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UMSocialUserInfoResponse *input) {
        @strongify(self)
        [self.viewController.view endEditing:NO];
//        [self.viewController showHUDWithString:@"登录中..."];
        [[self.httpService otherLoginByPlatform:input.platformType uid:input.uid unionId:input.openid nickname:input.name iconUrl:input.iconurl gender:input.unionGender resultClass:nil] subscribeNext:^(BaseModel *model) {
            @strongify(self)
            if (model.code==200) {
                [[UserClient sharedUserClient] setLoginTypeName:input.platformType];
                
                [[UserClient sharedUserClient] setUserInfo:model.data];
                [self.viewController hiddenHUDWithString:@"登陆成功" error:NO];
                
                [self.loginSuccessCommand execute:nil];
    
            
            }else {
//                [self.viewController hiddenHUDWithString:model.message error:NO];
                [self showRequestErrorMessage:model];
                if (self.loginErrorCommand) {
                    [self.loginErrorCommand execute:nil];
                }
            }
        } error:^(NSError *error) {

        } completed:^{
//            [self.viewController hiddenHUD];
        }];
        
        return [RACSignal empty];
    }];
}
@end
