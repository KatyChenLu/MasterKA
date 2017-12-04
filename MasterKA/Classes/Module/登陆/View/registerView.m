//
//  registerView.m
//  MasterKA
//
//  Created by lijiachao on 16/12/22.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "registerView.h"
#import "UserMsgModel.h"
#import "HttpManagerCenter.h"
#import "UITextField+Master.h"
#import "Masonry.h"
#import "MBProgressHUD.h"
#import "AppConfig.h"
#import "HttpManagerCenter+Login.h"
#import "AppDelegate.h"
#import "BaseViewController.h"
#import "MainTabBarController.h"


@interface registerView(){
    UITextField*phoneField;
    UITextField*testField;
    UITextField*passwordField;
    UIButton* registerBtn;
    NSString* phonestr;
    NSString* yanzhengstr;
    NSString* passstr;
    UIButton* sendBtn;
    // UIButton* agreeBtn;
    UIButton* procolBtn;
    UIButton* gobackBtn;
    UIButton* deleteBtn;
    BOOL isagree;
    AppDelegate* appdelegate;
    BaseViewController* vc;
    
    UIView* phoneView;
    UIView* yanzhengmaView;
    UIView* passview;
}

@property (nonatomic,weak,readonly)HttpManagerCenter *httpService;
@property (nonatomic,strong)NSNumber *littleTime ;
@property (nonatomic,strong)NSTimer *codeTimer ;
@property (nonatomic,strong)UIButton* agreeBtn;


@end
@implementation registerView
@synthesize httpService = _httpService;
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        vc = (BaseViewController*)appdelegate.baseVC;
        self.layer.masksToBounds =YES;
        self.layer.cornerRadius = 16;
        
        self.backgroundColor = RGBFromHexadecimal(0xfafafa);
        
        self.agreeBtn = [[UIButton alloc]init];
        [self.agreeBtn setImage:[UIImage imageNamed:@"xuanzhong-"] forState:UIControlStateNormal];
        
        [self.agreeBtn addTarget:self action:@selector(agreeClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.agreeBtn];
        
        procolBtn =[[UIButton alloc]init];
        [procolBtn setTitle:@"用户协议" forState:UIControlStateNormal];
        procolBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [procolBtn setTitleColor:RGBFromHexadecimal(0x279ADE) forState:UIControlStateNormal];
        [procolBtn addTarget:self action:@selector(procolClicked) forControlEvents:UIControlEventTouchUpInside];
        procolBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:procolBtn];
        
        UILabel* speakLabel = [[UILabel alloc]init];
        speakLabel.backgroundColor = [UIColor clearColor];
        speakLabel.text = @"同意并接受Master达人";
        speakLabel.font = [UIFont systemFontOfSize:10];
        speakLabel.textColor = [UIColor blackColor];
        [self addSubview:speakLabel];
        
        [speakLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).with.offset(-10);
            make.height.mas_equalTo(12);
            make.width.mas_equalTo(105);
            make.centerX.equalTo(self).with.offset(-10);
        }];
        [self.agreeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(speakLabel.mas_left).with.offset(8);
            make.height.width.mas_equalTo(30);
            make.top.equalTo(speakLabel.mas_top).with.offset(-8);
        }];
        [procolBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(speakLabel.mas_right);
            make.height.mas_equalTo(12);
            make.top.equalTo(speakLabel.mas_top);
            make.width.mas_equalTo(43);
            
        }];
        
        
        gobackBtn = [[UIButton alloc]init];
        gobackBtn.backgroundColor = [UIColor clearColor];
        [gobackBtn addTarget:self action:@selector(gobackClicked) forControlEvents:UIControlEventTouchUpInside];
        [gobackBtn setImage:[UIImage imageNamed:@"backdl"] forState:UIControlStateNormal];
        [self addSubview:gobackBtn];
        
        deleteBtn = [[UIButton alloc]init];
        deleteBtn.backgroundColor = [UIColor clearColor];
        [deleteBtn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setImage:[UIImage imageNamed:@"close-1"] forState:UIControlStateNormal];
        [self addSubview:deleteBtn];
        [deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(5);
            make.height.width.mas_equalTo(30);
            make.right.equalTo(self).with.offset(-5);
        }];
        
        
        
        [gobackBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(3);
            make.height.mas_equalTo(40);
            make.left.equalTo(self).with.offset(5);
            make.width.mas_equalTo(@30);
            
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
            make.left.equalTo(self).with.offset(50);
            make.right.equalTo(self).with.offset(-50);
        }];
        
        
        UIImageView* phoneimg = [[UIImageView alloc]initWithFrame:CGRectMake(16, 10, 12, 20)];
        [phoneimg setImage:[UIImage imageNamed:@"mobile_icon"]];
        [phoneView addSubview:phoneimg];
        
        UIView* bb = [[UIView alloc]initWithFrame:CGRectMake(38, 11, 1, 18)];
        bb.backgroundColor = RGBFromHexadecimal(0xc7c7cd);
        [phoneView addSubview:bb];
        
        
        
        phoneField = [[UITextField alloc]init];
        phoneField.backgroundColor = [UIColor whiteColor];
        
        phoneField.maxLenght = 11;
        phoneField.placeholder = @"手机号码";
        //        [phoneField setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
        [phoneField addTarget:self action:@selector(phoneFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        phoneField.keyboardType = UIKeyboardTypeNumberPad;
        [phoneView addSubview:phoneField];
        
        [phoneField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
        [phoneField setValue:RGBFromHexadecimal(0xc7c7cd) forKeyPath:@"_placeholderLabel.textColor"];
        
        
        
        
        
        sendBtn = [[UIButton alloc]init];
        sendBtn.layer.masksToBounds = YES;
        sendBtn.layer.cornerRadius = 20;
        sendBtn.backgroundColor = RGBFromHexadecimal(0xC1C1C1);
        [sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        sendBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        sendBtn.enabled = NO;
        
        [sendBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
        [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(sendClicked) forControlEvents:UIControlEventTouchUpInside];
        [phoneView addSubview:sendBtn];
        
        UIView* darkview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 40)];
        darkview.backgroundColor = [UIColor whiteColor];
        [sendBtn addSubview:darkview];
        
        [sendBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(phoneView);
            make.height.mas_equalTo(40);
            
            make.width.mas_equalTo(110);
        }];
        
        
        yanzhengmaView = [[UIView alloc]init];
        yanzhengmaView.layer.masksToBounds = YES;
        yanzhengmaView.layer.cornerRadius = 20;
        yanzhengmaView.layer.borderWidth =1;
        yanzhengmaView.layer.borderColor = [RGBFromHexadecimal(0xcdcdcd)CGColor];
        yanzhengmaView.backgroundColor = [UIColor whiteColor];
        [self addSubview:yanzhengmaView];
        
        [yanzhengmaView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(phoneView.mas_bottom).with.offset(30);
            make.height.mas_equalTo(40);
            make.left.equalTo(self).with.offset(50);
            make.right.equalTo(self).with.offset(-50);
        }];
        
        UIImageView* yanzhengma = [[UIImageView alloc]initWithFrame:CGRectMake(14, 12, 16, 16)];
        [yanzhengma setImage:[UIImage imageNamed:@"yanzhengma"]];
        [yanzhengmaView addSubview:yanzhengma];
        
        UIView* xian = [[UIView alloc]initWithFrame:CGRectMake(38, 11, 1, 18)];
        xian.backgroundColor = RGBFromHexadecimal(0xc7c7cd);
        [yanzhengmaView addSubview:xian];
        
        
        testField = [[UITextField alloc]init];
        testField.backgroundColor = [UIColor whiteColor];
        
        testField.placeholder = @"验证码";
        
        
        
        [testField addTarget:self action:@selector(testFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:testField];
        
        [testField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
        [testField setValue:RGBFromHexadecimal(0xc7c7cd) forKeyPath:@"_placeholderLabel.textColor"];
        
        
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
            make.top.equalTo(yanzhengmaView.mas_bottom).with.offset(30);
            make.height.mas_equalTo(40);
            make.left.equalTo(self).with.offset(50);
            make.right.equalTo(self).with.offset(-50);
        }];
        
        
        UIView* ee = [[UIView alloc]initWithFrame:CGRectMake(38, 11, 1, 18)];
        ee.backgroundColor = RGBFromHexadecimal(0xc7c7cd);
        [passview addSubview:ee];
        
        
        
        
        
        passwordField = [[UITextField alloc]init];
        passwordField.backgroundColor = [UIColor whiteColor];
        
        passwordField.maxLenght = 20;
        passwordField.secureTextEntry = YES;
        
        passwordField.placeholder = @"设置6-20位密码";
        [passwordField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
        [passwordField setValue:RGBFromHexadecimal(0xc7c7cd) forKeyPath:@"_placeholderLabel.textColor"];
        
        [passwordField addTarget:self action:@selector(passwordFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:passwordField];
        
        
        
        
        
        registerBtn = [[UIButton alloc]init];
        registerBtn.backgroundColor = RGBFromHexadecimal(0xC1C1C1);
        registerBtn.layer.masksToBounds =YES;
        registerBtn.layer.cornerRadius = 20;
        [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        registerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [registerBtn addTarget:self action:@selector(registerClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:registerBtn];
        
        
        
        
        [phoneField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(phoneView.mas_top).with.offset(5);
            make.left.equalTo(phoneView.mas_left).with.offset(50);
            make.bottom.equalTo(phoneView);
            make.right.equalTo(phoneView).with.offset(-115);
        }];
        [testField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(yanzhengmaView.mas_top).with.offset(5);
            make.left.equalTo(yanzhengmaView.mas_left).with.offset(50);
            make.bottom.equalTo(yanzhengmaView).with.offset(-1.5);
            make.right.equalTo(yanzhengmaView).with.offset(-20);
        }];
        [passwordField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(passview.mas_top).with.offset(5);
            make.left.equalTo(passview.mas_left).with.offset(50);
            make.bottom.equalTo(passview.mas_bottom).with.offset(-2);
            make.right.equalTo(passview).with.offset(-20);
        }];
        
        [registerBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(passwordField.mas_bottom).with.offset(58);
            make.height.mas_equalTo(40);
            make.left.equalTo(self).with.offset(50);
            make.right.equalTo(self).with.offset(-50);
        }];
        
    }
    return self;
}


-(void)gobackClicked{
    phoneField.text = @"";
    testField.text = @"";
    passwordField.text = @"";
    phonestr = nil;
    yanzhengstr = nil;
    passstr = nil;
    sendBtn.enabled = NO;
    sendBtn.backgroundColor = RGBFromHexadecimal(0xC1C1C1);
    registerBtn.enabled = NO;
    registerBtn.backgroundColor = RGBFromHexadecimal(0xC1C1C1);
    [phoneField resignFirstResponder];
    [testField resignFirstResponder];
    [passwordField resignFirstResponder];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-60);
    } completion:^(BOOL finished) {
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"HideLoginView" object:nil];
        //                self.backView.hidden = YES;
        //                UIViewController *vct = [UIViewController viewControllerWithStoryboard:@"Login" identifier:@"LoginRegisterViewController"];
        //                [appdelegate.baseVC pushViewController:vct animated:YES];
        [self stopTimer];
    }];
    
}

-(void)agreeClicked{
    
    if(isagree ==NO){
        isagree =YES;
        [self.agreeBtn setImage:[UIImage imageNamed:@"weitongyi"] forState:UIControlStateNormal];
    }
    else{
        isagree =NO;
        [self.agreeBtn setImage:[UIImage imageNamed:@"xuanzhong-"] forState:UIControlStateNormal];
    }
    
    if(yanzhengstr.length>0&&passstr.length>=6&&isagree ==NO&&phonestr.length==11){
        registerBtn.enabled = YES;
        
        registerBtn.backgroundColor  =RGBFromHexadecimal(0xFEDF1F);
    }
    else{
        registerBtn.enabled = NO;
        registerBtn.backgroundColor  =RGBFromHexadecimal(0xC1C1C1);
        
    }
    
}

-(void)procolClicked{
    //    self.hidden=YES;
    //    [vc pushViewControllerWithUrl:vc.userClient.agree_url];
    [self.delegate DoProtolFrame];
}


-(void)deleteBtnClicked{
    phoneField.text = @"";
    phonestr = nil;
    yanzhengstr = nil;
    passstr = nil;
    testField.text = @"";
    passwordField.text = @"";
    sendBtn.enabled = NO;
    sendBtn.backgroundColor = RGBFromHexadecimal(0xC1C1C1);
    registerBtn.enabled = NO;
    registerBtn.backgroundColor = RGBFromHexadecimal(0xC1C1C1);
    [phoneField resignFirstResponder];
    [testField resignFirstResponder];
    [passwordField resignFirstResponder];
    [self.delegate DoreGisterFrame];
    [self stopTimer];
}

-(void)phoneFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    phonestr =theTextField.text;
    if(phonestr.length==11){
        sendBtn.enabled = YES;
        sendBtn.backgroundColor = RGBFromHexadecimal(0xFEDF1F);
    }
    else{
        sendBtn.enabled = NO;
        sendBtn.backgroundColor = RGBFromHexadecimal(0xC1C1C1);
    }
    if(yanzhengstr.length>0&&passstr.length>=6&&isagree ==NO&&phonestr.length==11){
        registerBtn.enabled = YES;
        registerBtn.backgroundColor  =RGBFromHexadecimal(0xFEDF1F);
        
    }
    else{
        registerBtn.enabled = NO;
        registerBtn.backgroundColor  =RGBFromHexadecimal(0xC1C1C1);
        
    }
    
    
    
}
-(void)testFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    yanzhengstr =theTextField.text;
    if(yanzhengstr.length>0&&passstr.length>=6&&isagree ==NO&&phonestr.length==11){
        registerBtn.enabled = YES;
        registerBtn.backgroundColor  =RGBFromHexadecimal(0xFEDF1F);
        
    }
    else{
        registerBtn.enabled = NO;
        registerBtn.backgroundColor  =RGBFromHexadecimal(0xC1C1C1);
        
    }
    
}
-(void)passwordFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    passstr =theTextField.text;
    if(yanzhengstr.length>0&&passstr.length>=6&&isagree ==NO&&phonestr.length==11){
        registerBtn.enabled = YES;
        registerBtn.backgroundColor  =RGBFromHexadecimal(0xFEDF1F);
        
    }
    else{
        registerBtn.enabled = NO;
        registerBtn.backgroundColor  =RGBFromHexadecimal(0xC1C1C1);
        
    }
}

-(void)registerClicked{
    
    [[self.httpService registerByPhone:phonestr phoneCode:yanzhengstr password:passstr resultClass:[UserMsgModel class]] subscribeNext:^(BaseModel *model) {
        
        if (model.code==200) {
            [self hiddenHUDWithString:@"注册成功" error:NO];
            
            //完善用户信息界面
            //                MsgViewController * msgVc = [[MsgViewController alloc]init];
            //
            //                msgVc.data  = model.data;
            //
            //
            //                msgVc.passWord = self.password;
            //
            //                [self.viewController.navigationController pushViewController:msgVc animated:YES];
            
            
            [[_httpService loginByPhone:phonestr password:passstr resultClass:nil] subscribeNext:^(BaseModel *model) {
                
                
                if (model.code==200) {
                    [[UserClient sharedUserClient] setUserName:phonestr password:passstr];
                    [[UserClient sharedUserClient] setLoginType:MasterLoginType_Phone];
                    [[UserClient sharedUserClient] setUserInfo:model.data];
                    //            [self hiddenHUDWithString:@"登录成功" error:NO];
                    
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefurbishMyInfo" object:nil];
                }
                
            }];
            
            [self deleteBtnClicked];
            sendBtn.enabled = NO;
            sendBtn.backgroundColor = RGBFromHexadecimal(0xC1C1C1);
            registerBtn.enabled = NO;
            registerBtn.backgroundColor = RGBFromHexadecimal(0xC1C1C1);
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"JumpToSetting" object:nil];
//            
//            MainTabBarController * tabBar = (MainTabBarController *)self.superViewController.tabBarController;
//            
//            tabBar.selectedIndex = 0;
//            
//            UIButton * btn =   tabBar.tabBarBtn[4];
//            
//            btn.selected = NO;
//            
//            btn = tabBar.tabBarBtn[0];
//            
//            btn.selected = YES;
//            
//            [self.superViewController.navigationController popViewControllerAnimated:NO];

           [vc hiddenHUDWithString:@"登录成功" error:NO];
            
        }else{
            [self hiddenHUDWithString:model.message error:YES];
            //[self showRequestErrorMessage:model];
        }
    } error:^(NSError *error) {
        
    } completed:^{
        
    }];
    
    
}


-(void)gotoBack{
    
    
    
}
-(void)sendClicked{
    
    [[self.httpService sendPhoneCode:phonestr codeType:@"1" resultClass:nil] subscribeNext:^(BaseModel *model) {
        
        if (model.code==200) {
            [self startTimer];
        }else{
            [self hiddenHUDWithString:model.message error:YES];
        }
        
    } error:^(NSError *error) {
        
    } completed:^{
        
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
        [sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        
        [self stopTimer];
        
        sendBtn.enabled = YES;
        sendBtn.backgroundColor = RGBFromHexadecimal(0xFEDF1F);
    }else{
        [sendBtn setTitle:[NSString stringWithFormat:@"发送验证码(%@)",self.littleTime] forState:UIControlStateNormal];
        
        sendBtn.enabled = NO;
        sendBtn.backgroundColor = RGBFromHexadecimal(0xC1C1C1);
        
    }
}


- (void)stopTimer{
    if (_codeTimer) {
        [sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_codeTimer invalidate];
    }
    _codeTimer = nil;
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
    //    if (hud.delayTime==0) {
    [hud hideAnimated:YES];
    //    }
    //    [MBProgressHUD hideHUDForView:[self getHUDView] animated:TRUE];
}

-(void)forgetClicked{
    NSLog(@"1");
    
    
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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
