//
//  LoginView.m
//  MasterKA
//
//  Created by lijiachao on 16/12/16.
//  Copyright © 2016年 jinghao. All rights reserved.
//


#import "LoginView.h"
#import "Masonry.h"
#import "HttpManagerCenter.h"
#import "HttpManagerCenter+Login.h"
#import "UserClient.h"
#import "AppDelegate.h"
#import "BaseViewController.h"
#import "UIViewController+HUD.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "AppConfig.h"
#import "GCDQueue.h"
#import "UIViewController+Master.h"

#import "registerView.h"
#import "UITextField+Master.h"
#import "ForgetPwdView.h"

#import <UMSocialQQHandler.h>
#import <WXApi.h>
//#import <WeiboSDK.h>
#import <UMSocialSinaHandler.h>

@interface LoginView()<registerDelegate,UITextFieldDelegate,ForgetPwdViewDelegate>
{
    AppDelegate* appdelegate;
    
    UIButton* registerBtn;
    UIButton* forgetBtn;
    UIButton* qqBtn;
    UIButton* weixinBtn;
    UIButton* xinlangBtn;
    BaseViewController* vc;
    UIView* phoneView;
    UIView* passview;
    UIButton* fogetbttn;
    
}
@property (nonatomic,strong)registerView* registView;
@property (nonatomic, strong) RACCommand *loginSuccessCommand;
@property (nonatomic,strong) UITextField *phoneTextField;
@property (nonatomic,strong)UIButton* LoginBtn;
@property (nonatomic,strong)NSString* userName;
@property (nonatomic,strong)NSString* password;
@property (nonatomic,strong)UIButton* deleteView;
@property (nonatomic,strong)ForgetPwdView* forgetView;
//登陆密码
@property (nonatomic,strong) UITextField *pwdTextField;
@property (nonatomic,weak,readonly)HttpManagerCenter *httpService;


@end

@implementation LoginView
@synthesize forgetView = _forgetView;
@synthesize httpService = _httpService;
@synthesize registView = _registView;
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        vc = (BaseViewController*)appdelegate.baseVC;
        self.backgroundColor = RGBFromHexadecimal(0xfafafa);
        
        
        self.layer.masksToBounds =YES;
        self.layer.cornerRadius = 16;
        
        
        UILabel *label = [[UILabel alloc]init];
        label.text = @"登录后保存浏览偏好";
        label.textColor = RGBFromHexadecimal(0x6e6e6e);
        label.font = [UIFont systemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        [label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(65);
            make.height.width.mas_equalTo(25);
            make.left.equalTo(self).with.offset(30);
            make.right.equalTo(self).with.offset(-30);
        }];
        UILabel *label2 = [[UILabel alloc]init];
        label2.text = @"打造你的专属兴趣";
        label2.textColor = RGBFromHexadecimal(0x6e6e6e);
        label2.font = [UIFont systemFontOfSize:16];
        label2.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label2];
        
        [label2 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(95);
            make.height.width.mas_equalTo(25);
            make.left.equalTo(self).with.offset(30);
            make.right.equalTo(self).with.offset(-30);
        }];
        
        
        
        
        
        self.deleteView = [[UIButton alloc]init];
        self.deleteView.backgroundColor = [UIColor clearColor];
        [self.deleteView addTarget:self action:@selector(DeleteClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.deleteView setImage:[UIImage imageNamed:@"close-1"] forState:UIControlStateNormal];
        [self addSubview:self.deleteView];
        
        [self.deleteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(5);
            make.height.width.mas_equalTo(40);
            make.right.equalTo(self).with.offset(-5);
        }];
        
        phoneView = [[UIView alloc]init];
        phoneView.layer.masksToBounds = YES;
        phoneView.layer.cornerRadius = 20;
        phoneView.layer.borderWidth =1;
        phoneView.layer.borderColor = [RGBFromHexadecimal(0xcdcdcd)CGColor];
        phoneView.backgroundColor = [UIColor whiteColor];
        [self addSubview:phoneView];
        [phoneView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(158);
            make.height.mas_equalTo(40);
            make.left.equalTo(self).with.offset(40);
            make.right.equalTo(self).with.offset(-40);
        }];
        
        UIImageView* phoneimg = [[UIImageView alloc]initWithFrame:CGRectMake(16, 10, 12, 20)];
        [phoneimg setImage:[UIImage imageNamed:@"mobile_icon"]];
        [phoneView addSubview:phoneimg];
        
                UIView* bb = [[UIView alloc]initWithFrame:CGRectMake(38, 11, 1, 18)];
                bb.backgroundColor = RGBFromHexadecimal(0xc7c7cd);
        [phoneView addSubview:bb];
        
        
        self.phoneTextField = [[UITextField alloc]init];
//        self.phoneTextField.layer.masksToBounds = YES;
//        self.phoneTextField.layer.cornerRadius = 20;
        self.phoneTextField.delegate = self;
        self.phoneTextField.backgroundColor = [UIColor whiteColor];
        self.phoneTextField.borderStyle = UITextBorderStyleNone;
        self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
//        self.phoneTextField.layer.borderWidth =1;
//        self.phoneTextField.layer.borderColor = [RGBFromHexadecimal(0xC1C1C1)CGColor];
        self.phoneTextField.placeholder = @"手机号";
        [self.phoneTextField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
        [self.phoneTextField setValue:RGBFromHexadecimal(0xc7c7cd) forKeyPath:@"_placeholderLabel.textColor"];
        
        [phoneView addSubview:self.phoneTextField];
        
        
        [self.phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        [self.phoneTextField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(phoneView.mas_top).with.offset(5);
            make.left.equalTo(phoneView.mas_left).with.offset(50);
            make.bottom.equalTo(phoneView);
            make.right.equalTo(phoneView).with.offset(-20);
        }];
        
        
        passview = [[UIView alloc]init];
        passview.layer.masksToBounds = YES;
        passview.layer.cornerRadius = 20;
        passview.layer.borderWidth =1;
        passview.layer.borderColor = [RGBFromHexadecimal(0xcdcdcd)CGColor];
        passview.backgroundColor = [UIColor whiteColor];
        [self addSubview:passview];
        
        
        UIImageView* passimg = [[UIImageView alloc]initWithFrame:CGRectMake(16, 10, 12, 16)];
        [passimg setImage:[UIImage imageNamed:@"password_icon"]];
        [passview addSubview:passimg];
        
        [passview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneTextField.mas_bottom).with.offset(30);
            make.height.mas_equalTo(40);
            make.left.equalTo(self).with.offset(40);
            make.right.equalTo(self).with.offset(-40);
        }];
        
        
        UIView* ee = [[UIView alloc]initWithFrame:CGRectMake(38, 11, 1, 18)];
        ee.backgroundColor = RGBFromHexadecimal(0xc7c7cd);
        [passview addSubview:ee];
        
        
        
        self.pwdTextField = [[UITextField alloc]init];
        self.pwdTextField.backgroundColor = [UIColor whiteColor];
        self.pwdTextField.placeholder = @"密码";
        self.pwdTextField.borderStyle = UITextBorderStyleNone;
        [self.pwdTextField addTarget:self action:@selector(passWordDidChange:) forControlEvents:UIControlEventEditingChanged];

        self.pwdTextField.secureTextEntry = YES;
       
        [self.pwdTextField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
        [self.pwdTextField setValue:RGBFromHexadecimal(0xc7c7cd) forKeyPath:@"_placeholderLabel.textColor"];
        [self addSubview:self.pwdTextField];
        
        [self.pwdTextField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(passview.mas_top).with.offset(5);
            make.left.equalTo(passview.mas_left).with.offset(50);
            make.bottom.equalTo(passview.mas_bottom).with.offset(-2);
            make.right.equalTo(passview).with.offset(-20);
        }];
   

        self.phoneTextField.maxLenght = 11;
        self.pwdTextField.maxLenght = 20;
        
        
        self.LoginBtn = [[UIButton alloc]init];
        self.LoginBtn.backgroundColor = RGBFromHexadecimal(0xC1C1C1);
        self.LoginBtn.layer.masksToBounds = YES;
        self.LoginBtn.layer.cornerRadius = 20;
        [self.LoginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [self.LoginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.LoginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        self.LoginBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.LoginBtn addTarget:self action:@selector(loginClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.LoginBtn];
        
        [self.LoginBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pwdTextField.mas_bottom).with.offset(56);
            make.height.mas_equalTo(40);
            make.left.equalTo(self).with.offset(40);
            make.right.equalTo(self).with.offset(-40);
        }];
        
        registerBtn = [[UIButton alloc]init];
        registerBtn.backgroundColor = [UIColor clearColor];
        [registerBtn setTitle:@"注册账号" forState:UIControlStateNormal];
        registerBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [registerBtn setTitleColor:RGBFromHexadecimal(0x6d6d6d) forState:UIControlStateNormal];
        registerBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [registerBtn addTarget:self action:@selector(registerClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:registerBtn];
        
        fogetbttn = [[UIButton alloc]init];
        fogetbttn.backgroundColor = [UIColor clearColor];
        [fogetbttn setTitle:@"忘记密码" forState:UIControlStateNormal];
        fogetbttn.titleLabel.font = [UIFont systemFontOfSize:12];
        [fogetbttn setTitleColor:RGBFromHexadecimal(0x6d6d6d) forState:UIControlStateNormal];
        fogetbttn.titleLabel.textAlignment = NSTextAlignmentRight;
        [fogetbttn addTarget:self action:@selector(forgetClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:fogetbttn];
        
        [fogetbttn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.LoginBtn.mas_bottom).with.offset(20);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(70);
            make.left.equalTo(self.LoginBtn.mas_left).with.offset(1);
        }];
        
        
        [registerBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.LoginBtn.mas_bottom).with.offset(20);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(70);
            make.right.equalTo(self.LoginBtn.mas_right).with.offset(-1);
        }];
        
//        qqBtn = [[UIButton alloc]init];
//        [qqBtn setImage:[UIImage imageNamed:@"icon_qq_logo"] forState:UIControlStateNormal];
//        qqBtn.tag = 1;
//        [qqBtn addTarget:self action:@selector(qqClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:qqBtn];
        
        weixinBtn = [[UIButton alloc]init];
//        weixinBtn.frame = CGRectMake(0, 0, 50, 50);
//        weixinBtn.centerX = self.centerX;
//        weixinBtn.centerY = ScreenHeight - 60;
        [weixinBtn setImage:[UIImage imageNamed:@"icon_wx_logo"] forState:UIControlStateNormal];
        weixinBtn.tag =2;
        [weixinBtn addTarget:self action:@selector(qqClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:weixinBtn];
        
//        xinlangBtn = [[UIButton alloc]init];
//        [xinlangBtn setImage:[UIImage imageNamed:@"icon_weibo_logo"] forState:UIControlStateNormal];
//        xinlangBtn.tag =3;
//        [xinlangBtn addTarget:self action:@selector(qqClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:xinlangBtn];
        
      
        
        
        CGFloat x = ([UIScreen mainScreen].bounds.size.width)/2.0 -25;
        
        [weixinBtn mas_updateConstraints:^(MASConstraintMaker *make) {

            make.left.equalTo(self).with.offset(x);
            make.height.width.mas_equalTo(50);
            make.bottom.equalTo(self).with.offset(-35);
        }];
        
//        [xinlangBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.equalTo(weixinBtn.mas_right).with.offset(x);
//            make.height.width.mas_equalTo(50);
//            make.bottom.equalTo(self).with.offset(-35);
//        }];
//        [qqBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//
//            make.left.equalTo(xinlangBtn.mas_right).with.offset(x);
//            make.height.width.mas_equalTo(50);
//            make.bottom.equalTo(self).with.offset(-35);
//        }];
        
        if (![WXApi isWXAppInstalled]) {
            NSLog(@"没安装微信");
            weixinBtn.hidden = YES;
//            [xinlangBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//
//                make.left.top.right.bottom.equalTo(weixinBtn);
//            }];
//            [qqBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//
//                make.left.equalTo(xinlangBtn.mas_right).with.offset(2*x +50);
//                make.height.width.mas_equalTo(50);
//                make.bottom.equalTo(self).with.offset(-35);
//            }];
            
        }
        
        
        UILabel *orlabel = [[UILabel alloc]init];
        orlabel.text = @"其他登录方式";
        orlabel.textColor = RGBFromHexadecimal(0x6e6e6e);
        orlabel.font = [UIFont systemFontOfSize:15];
        orlabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:orlabel];
        
        [orlabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weixinBtn.mas_top).with.offset(-20);
            make.width.mas_equalTo(100);
            make.centerX.mas_equalTo(self);
        }];
        
        UIView* line1 = [[UIView alloc]init];
        line1.backgroundColor = RGBFromHexadecimal(0xcdcdcd);
        [self addSubview:line1];
        [line1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(60);
            make.height.mas_equalTo(1);
            make.right.equalTo(orlabel.mas_left).with.offset(-8);
            make.bottom.equalTo(weixinBtn.mas_top).with.offset(-27);
        }];
        
        UIView* line2 = [[UIView alloc]init];
        line2.backgroundColor = RGBFromHexadecimal(0xcdcdcd);
        [self addSubview:line2];
        [line2 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-60);
            make.height.mas_equalTo(1);
            make.left.equalTo(orlabel.mas_right).with.offset(8);
            make.bottom.equalTo(weixinBtn.mas_top).with.offset(-27);
        }];
    }
    return self;
}


-(void)qqClicked:(UIButton*)sender{
    [self DeleteClicked];
    UMSocialPlatformType platformName = UMSocialPlatformType_UnKnown;
    if(sender.tag ==1){
        
        platformName = UMSocialPlatformType_QQ;
    }
    else if(sender.tag ==2)
    {
        platformName= UMSocialPlatformType_WechatSession;
    }
    else if(sender.tag ==3){
        
        platformName= UMSocialPlatformType_Sina;
        
    }
     [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = YES;
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformName currentViewController:nil completion:^(id result, NSError *error) {
          //           获取微博用户名、uid、token、第三方的原始用户信息thirdPlatformUserProfile等
        
       
        
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            [vc.view endEditing:NO];
            [vc showHUDWithString:@"登录中..."];
            
            [[UserClient sharedUserClient] setUserInfoResponse:resp];
            
            
            @weakify(self)
            [[self.httpService otherLoginByPlatform:resp.platformType uid:resp.uid unionId:resp.openid nickname:resp.name iconUrl:resp.iconurl gender:resp.unionGender resultClass:nil] subscribeNext:^(BaseModel *model) {
                @strongify(self)
                if (model.code==200) {
                    [[UserClient sharedUserClient] setLoginTypeName:resp.platformType];
                    
                    [[UserClient sharedUserClient] setUserInfo:model.data];
                    [vc hiddenHUDWithString:@"登录成功" error:NO];
                    
                    [self.loginSuccessCommand execute:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefurbishMyInfo" object:nil];
               
                    
                    
                }else {
                    
                    [vc showRequestErrorMessage:model];
                    
                }
            } error:^(NSError *error) {
                
            } completed:^{
                
            }];
        }
        
    }];
    
//    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
//    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//        //           获取微博用户名、uid、token、第三方的原始用户信息thirdPlatformUserProfile等
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
//            
//            [vc.view endEditing:NO];
//            [vc showHUDWithString:@"登录中..."];
//            @weakify(self)
//            [[self.httpService otherLoginByPlatform:snsAccount.platformName uid:snsAccount.usid unionId:snsAccount.unionId nickname:snsAccount.userName iconUrl:snsAccount.iconURL gender:@"1" resultClass:nil] subscribeNext:^(BaseModel *model) {
//                @strongify(self)
//                if (model.code==200) {
//                    [[UserClient sharedUserClient] setLoginTypeName:snsAccount.platformName];
//                    //                [[UserClient sharedUserClient] setLoginInfo:[input ]]
//                    [[UserClient sharedUserClient] setUserInfo:model.data];
//                    [vc hiddenHUDWithString:@"登录成功" error:NO];
//                    
//                    [self.loginSuccessCommand execute:nil];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefurbishMyInfo" object:nil];
//                    
//                    //                NSDictionary * dic = model.data;
//                    //
//                    //
//                    //                if ([dic[@"is_first"] isEqualToString:@"1"]) {
//                    //
//                    //
//                    //                    MsgViewController * msgVC = [[MsgViewController alloc]init];
//                    //
//                    //                    msgVC.thirdLogin = @"1";
//                    //
//                    //                    msgVC.thirdName = input.userName;
//                    //
//                    //                    msgVC.thirdMethod = input.platformName;
//                    //
//                    //                    [self.viewController.navigationController pushViewController: msgVC animated:NO];
//                    //                }else{
//                    ////
//                    //                    [self.loginSuccessCommand execute:nil];
//                    ////
//                    //                }
//                    
//                }else {
//                    //                [self.viewController hiddenHUDWithString:model.message error:NO];
//                    [vc showRequestErrorMessage:model];
//                    //                    if (self.loginErrorCommand) {
//                    //                        [self.loginErrorCommand execute:nil];
//                    //                    }
//                }
//            } error:^(NSError *error) {
//                
//            } completed:^{
//                //            [self.viewController hiddenHUD];
//            }];
//        }
//    });
}


-(void)registerClicked{
    
    //    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    //        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-40);
    //    } completion:^(BOOL finished) {
    ////        [[NSNotificationCenter defaultCenter] postNotificationName:@"HideLoginView" object:nil];
    //        self.backView.hidden = YES;
    //        UIViewController *vct = [UIViewController viewControllerWithStoryboard:@"Login" identifier:@"LoginRegisterViewController"];
    //        [appdelegate.baseVC pushViewController:vct animated:YES];
    //
    //    }];
    
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.registView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-60);
    } completion:^(BOOL finished) {
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"HideLoginView" object:nil];
        //                self.backView.hidden = YES;
        //                UIViewController *vct = [UIViewController viewControllerWithStoryboard:@"Login" identifier:@"LoginRegisterViewController"];
        //                [appdelegate.baseVC pushViewController:vct animated:YES];
        
    }];
    
    
    
    
}
-(void)loginClicked{
    //    UIViewController *vct = [UIViewController viewControllerWithStoryboard:@"Login" identifier:@"LoginRegisterViewController"];
    //    [appdelegate.baseVC pushViewController:vct animated:YES];
    //    self.hidden =YES;
    [self endEditing:NO];
    [self showHUDWithString:@"登录中..."];
    @weakify(self)
    [[self.httpService loginByPhone:self.userName password:self.password resultClass:nil] subscribeNext:^(BaseModel *model) {
        @strongify(self)
        if (model.code==200) {
            [[UserClient sharedUserClient] setUserName:self.userName password:self.password];
            [[UserClient sharedUserClient] setLoginType:MasterLoginType_Phone];
            [[UserClient sharedUserClient] setUserInfo:model.data];
            [self hiddenHUDWithString:@"登录成功" error:NO];
            [[GCDQueue mainQueue] queueBlock:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:MasterUserLoginNotification object:nil];
                
            } afterDelay:0.5f];
            [self DeleteClicked];
            self.phoneTextField.text = nil;
            self.pwdTextField.text = @"";
            self.LoginBtn.enabled = NO;
            self.LoginBtn.backgroundColor = RGBFromHexadecimal(0xC1C1C1);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefurbishMyInfo" object:nil];
            
        }else {
            [self hiddenHUDWithString:model.message error:YES];
            //[self showRequestErrorMessage:model];
            // if (self.loginErrorCommand) {
            // [self.loginErrorCommand execute:nil];
            // }
            
        }
        NSLog(@"====1 %@",model.message);
        
    } error:^(NSError *error) {
        NSLog(@"====1 %@",error);
    } completed:^{
        
        //        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //            self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-60);
        //        } completion:^(BOOL finished) {
        //            [[NSNotificationCenter defaultCenter] postNotificationName:MasterUserLoginNotification object:nil];
        //
        //        }];
    }] ;
}

-(void)DeleteClicked{
    [self.phoneTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
    self.phoneTextField.text = nil;
    self.pwdTextField.text = nil;
    self.userName = nil;
    self.password = nil;
    
    [UIView animateWithDuration:LoginViewShowHideAniTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-60);
           self.backView.backgroundColor =  [[UIColor blackColor]colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
        self.backView.hidden =YES;
     
        self.pwdTextField.text = @"";
        self.phoneTextField.text = @"";
        
    }];
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    self.userName =theTextField.text;
    if(self.password.length>=6&&self.userName.length ==11){
        self.LoginBtn.enabled = YES;
        self.LoginBtn.backgroundColor = RGBFromHexadecimal(0xFEDF1F);
    }
    else{
        self.LoginBtn.enabled = NO;
        self.LoginBtn.backgroundColor = RGBFromHexadecimal(0xC1C1C1);
        
    }
}

-(void)passWordDidChange :(UITextField *)theTextField{
    self.password =theTextField.text;
    if(theTextField.text.length>=6&&self.userName.length ==11){
        self.LoginBtn.backgroundColor = RGBFromHexadecimal(0xFEDF1F);
        self.LoginBtn.enabled = YES;
    }
    else{
        self.LoginBtn.backgroundColor = RGBFromHexadecimal(0xC1C1C1);
        self.LoginBtn.enabled = NO;
        
    }
    NSLog( @"text changed: %@", theTextField.text);
}

-(void)DoProtolFrame{
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-60);
    } completion:^(BOOL finished) {
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"HideLoginView" object:nil];
        //                self.backView.hidden = YES;
        //                UIViewController *vct = [UIViewController viewControllerWithStoryboard:@"Login" identifier:@"LoginRegisterViewController"];
        self.backView.hidden = YES;
        appdelegate.isfromprotocol = YES;
        vc = (BaseViewController*)appdelegate.baseVC;
        [vc pushViewControllerWithUrl:vc.userClient.agree_url];
        
    }];



}




- (HttpManagerCenter *)httpService
{
    if (!_httpService) {
        _httpService = [HttpManagerCenter sharedHttpManager];
    }
    return _httpService;
}

- (void)showHUDWithString:(NSString*)message{
    [self showHUDWithString:message animated:TRUE];
}
- (void)showHUDWithString:(NSString*)message animated:(BOOL)animated{
    MBProgressHUD *hud = [self getProgressHUDView];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = message;
    [hud showAnimated:animated];
    
    //    [MBProgressHUD showHUDAddedTo:[self getHUDView] animated:animated].labelText = message;
}

- (void)hiddenHUD{
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:[self getHUDView]];
    if (hud.graceTime==0) {
        [hud hideAnimated:YES];
    }
    //    [MBProgressHUD hideHUDForView:[self getHUDView] animated:TRUE];
}

-(void)forgetClicked{
    NSLog(@"1");
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.forgetView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-60);
    } completion:^(BOOL finished) {
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"HideLoginView" object:nil];
        //                self.backView.hidden = YES;
        //                UIViewController *vct = [UIViewController viewControllerWithStoryboard:@"Login" identifier:@"LoginRegisterViewController"];
        //                [appdelegate.baseVC pushViewController:vct animated:YES];
        
    }];
    
    
    
    
}
- (void)hiddenHUDWithString:(NSString*)message error:(BOOL)error{
    MBProgressHUD *hud = [self getProgressHUDView];
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    hud.customView = imageView;
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = message;
    [hud hideAnimated:TRUE afterDelay:1.0f];
}

- (void)toastWithString:(NSString*)message error:(BOOL)error{
    
    [SharedAppDelegate.window makeToast:message duration:1.f position:@"center" image:nil];
}

- (UIView*)getHUDView{
    UIView *HUDSupperView = self;
    
    return HUDSupperView;
}

- (MBProgressHUD*)getProgressHUDView{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:[self getHUDView]];
    if (hud==nil) {
        [MBProgressHUD showHUDAddedTo:[self getHUDView] animated:YES];
        hud = [MBProgressHUD HUDForView:[self getHUDView]];
        //        hud = [[MBProgressHUD alloc] initWithView:[self getHUDView]];
        //        hud.removeFromSuperViewOnHide = YES;
        //        [[self getHUDView] addSubview:hud];
    }
    return hud;
}


-(UIView *)registView
{
    if (!_registView) {
        
        _registView = [[registerView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-60)];
        _registView.delegate = self;
        
        
        [self addSubview:_registView];
    }
    return _registView;
}

-(UIView *)forgetView
{
    if (!_forgetView) {
        
        _forgetView = [[ForgetPwdView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-60)];
        _forgetView.delegate = self;
        
        
        [self addSubview:_forgetView];
    }
    return _forgetView;
}

-(void)DoreForgetPwdFrame{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-60);
    } completion:^(BOOL finished) {
        self.backView.hidden =YES;
        self.forgetView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-60);
    }];
    
    
}

-(void)DoreGisterFrame{
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-60);
    } completion:^(BOOL finished) {
        self.backView.hidden =YES;
        self.registView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-60);
    }];
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
