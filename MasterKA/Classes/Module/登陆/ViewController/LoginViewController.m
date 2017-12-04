//
//  LoginViewController.m
//  MasterKA
//
//  Created by jinghao on 16/1/25.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"
//#import "UMSocial.h"
#import "UserClient.h"
#import <UMSocialCore/UMSocialCore.h>

@interface LoginViewController ()

//登陆按钮
@property (nonatomic,weak)IBOutlet UIButton *loginButton;
//忘记密码按钮
@property (nonatomic,weak)IBOutlet UIButton *forgetButton;

//微信登陆按钮
@property (nonatomic,weak)IBOutlet UIButton *weixinButton;
//qq登陆按钮
@property (nonatomic,weak)IBOutlet UIButton *qqButton;
//新浪微博登陆按钮
@property (nonatomic,weak)IBOutlet UIButton *sinaButton;

//电话号码
@property (nonatomic,weak)IBOutlet UITextField *phoneTextField;
//登陆密码
@property (nonatomic,weak)IBOutlet UITextField *pwdTextField;

@property (nonatomic,strong)LoginViewModel *viewModel;

@end

@implementation LoginViewController
@synthesize viewModel = _viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel.title = @"登录";
    self.view.backgroundColor = [UIColor colorWithHex:0xF7F7F7];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackNormal"] style:UIBarButtonItemStylePlain target:self action:@selector(cancleLogin:)] animated:TRUE];
    [self.navigationItem addRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(gotoRegisterVCT:)] animated:TRUE];
    self.phoneTextField.maxLenght = 11;
    self.pwdTextField.maxLenght = 20;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bindViewModel
{
    [super bindViewModel];
    
    //绑定数据
    RAC(self.viewModel, username) = self.phoneTextField.rac_textSignal;
    RAC(self.viewModel, password) = self.pwdTextField.rac_textSignal;

    
    @weakify(self);
        
    //判断登录按钮是否可以用
    RAC(self.loginButton, enabled) = self.viewModel.validLoginSignal;
    RAC(self.loginButton, backgroundColor) = [self.viewModel.validLoginSignal
                                 map:^id(NSNumber *usernameIsValid) {
                                     return usernameIsValid.boolValue ? MasterDefaultColor : [UIColor colorWithHex:0xcccccc];
                                 }];
    [[self.pwdTextField.rac_keyboardReturnSignal filter:^BOOL(id value) {
        @strongify(self)
        return self.loginButton.enabled;
    }] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.loginCommand execute:nil];
    }];
    //点击登录动作
    [[self.loginButton
      rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self)
         [self.viewModel.loginCommand execute:nil];
     }];
    
    [[self.weixinButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self)
         [self otherLogin:1];
     }];
    
    [[self.qqButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self)
         [self otherLogin:2];
     }];
    
    [[self.sinaButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self)
         [self otherLogin:3];
     }];
}

#pragma mark --

- (LoginViewModel*)viewModel{
    if (!_viewModel) {
        _viewModel = [[LoginViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}

- (void)cancleLogin:(id)sender{
    [self.navigationController dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)gotoRegisterVCT:(id)sender{
    [self performSegueWithIdentifier:@"gotoLoginRegister" sender:self];
}

/**
 *  第三方登录
 *
 *  @param otherTppe 1：微信，2：QQ,3:新浪微博
 */
- (void)otherLogin:(int)otherTppe{
    
    UMSocialPlatformType platformName = UMSocialPlatformType_UnKnown;
    
    
    
    
    if (otherTppe==1) {
        platformName = UMSocialPlatformType_WechatSession;
    }else if(otherTppe==2){
        platformName = UMSocialPlatformType_QQ;
    }else if(otherTppe==3){
        platformName = UMSocialPlatformType_Sina;
    }
    if (platformName) {
//        [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
//        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
//        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//            //           获取微博用户名、uid、token、第三方的原始用户信息thirdPlatformUserProfile等
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
//                [[self.viewModel otherLoginCommand] execute:snsAccount];
//            }
//        });

        [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformName currentViewController:nil completion:^(id result, NSError *error) {
            if (error) {
                
            } else {
                UMSocialUserInfoResponse *resp = result;
                [[self.viewModel otherLoginCommand] execute:resp];
                  [[UserClient sharedUserClient] setUserInfoResponse:resp];
                // 授权信息
                NSLog(@"Wechat uid: %@", resp.uid);
                NSLog(@"Wechat openid: %@", resp.openid);
                NSLog(@"Wechat accessToken: %@", resp.accessToken);
                NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
                NSLog(@"Wechat expiration: %@", resp.expiration);
                
                // 用户信息
                NSLog(@"Wechat name: %@", resp.name);
                NSLog(@"Wechat iconurl: %@", resp.iconurl);
                NSLog(@"Wechat gender: %@", resp.gender);
                
                // 第三方平台SDK源数据
                NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
            }
        }];
    
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
