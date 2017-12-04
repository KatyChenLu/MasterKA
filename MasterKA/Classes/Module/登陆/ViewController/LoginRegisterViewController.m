//
//  LoginRegisterViewController.m
//  MasterKA
//
//  Created by jinghao on 16/1/25.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "LoginRegisterViewController.h"
#import "LoginRegisterViewModel.h"
@interface LoginRegisterViewController (){
    
}
//电话号码
@property (nonatomic,weak)IBOutlet UITextField *phoneField;
//验证码
@property (nonatomic,weak)IBOutlet UITextField *phoneCodeField;
//密码
@property (nonatomic,weak)IBOutlet UITextField *passwordField;
//获取验证码按钮
@property (nonatomic,weak)IBOutlet UIButton *codeButton;

//提交注册按钮
@property (nonatomic,weak)IBOutlet UIButton *registerButton;
//同意协议按钮
@property (nonatomic,weak)IBOutlet UIButton *acceptButton;
//打开协议按钮
@property (nonatomic,weak)IBOutlet UIButton *protocolButton;

@property (nonatomic,strong)LoginRegisterViewModel *viewModel;

@end

@implementation LoginRegisterViewController
@synthesize viewModel = _viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel.title = @"注册";
    self.passwordField.maxLenght = 20;
    self.phoneField.maxLenght = 11;
    self.acceptButton.selected = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark -- 

- (LoginRegisterViewModel*)viewModel
{
    if (!_viewModel) {
        _viewModel = [[LoginRegisterViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}

- (void)bindViewModel
{
    [super bindViewModel];
    //绑定数据
    @weakify(self);
    RAC(self.viewModel,phone) = self.phoneField.rac_textSignal;
    RAC(self.viewModel,phoneCode) = self.phoneCodeField.rac_textSignal;
    RAC(self.viewModel,password) = self.passwordField.rac_textSignal;
    
    RAC(self.viewModel,acceptAgreement) = RACObserve(self.acceptButton,selected);
    [RACObserve(self.viewModel,phoneCodeText) subscribeNext:^(NSString *phoneCodeText) {
        @strongify(self);
        [self.codeButton setTitle:phoneCodeText forState:UIControlStateNormal];
    }];
    //判断获取验证码按钮是否可以用
    RAC(self.codeButton, enabled) = self.viewModel.validCodeSignal;
    RAC(self.codeButton, backgroundColor) = [self.viewModel.validCodeSignal
                                              map:^id(NSNumber *usernameIsValid) {
                                                  return usernameIsValid.boolValue ? MasterDefaultColor : [UIColor colorWithHex:0xcccccc];
                                              }];
    
    //判断注册按钮是否可以用
    RAC(self.registerButton, enabled) = self.viewModel.validRegisterSignal;
    RAC(self.registerButton, backgroundColor) = [self.viewModel.validRegisterSignal
                                             map:^id(NSNumber *usernameIsValid) {
                                                 return usernameIsValid.boolValue ? MasterDefaultColor : [UIColor colorWithHex:0xCCCCCC];
                                             }];
    
    //点击获取验证码动作
    [[self.codeButton
      rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self)
         [self.viewModel.phoneCodeCommand execute:nil];
     }];
    
    //注册用户
    [[self.registerButton
      rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self)
         [self.viewModel.registerCommand execute:nil];
     }];
    
    //按发送键
    [[self.passwordField.rac_keyboardReturnSignal filter:^BOOL(id value) {
        @strongify(self)
        return self.registerButton.enabled;
    }] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.registerCommand execute:nil];
    }];
    
    //同意协议
    [[self.acceptButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button) {
        button.selected = !button.selected;
    }];
    
    //查看协议
    [[self.protocolButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button) {
        //TODO  查看协议
        @strongify(self);
        [self pushViewControllerWithUrl:self.userClient.agree_url];
    }];
}

- (void)gotoBack{
    [self.searchTitleView resignFirstResponder];
    
    if ([self canGotoBack]) {
        [self doLogin];
        [self.navigationController popViewControllerAnimated:YES];
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
