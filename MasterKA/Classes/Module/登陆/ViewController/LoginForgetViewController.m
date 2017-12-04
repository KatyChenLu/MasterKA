//
//  LoginForgetViewController.m
//  MasterKA
//
//  Created by jinghao on 16/1/25.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "LoginForgetViewController.h"
#import "LoginForgetViewModel.h"

@interface LoginForgetViewController ()
//电话号码
@property (nonatomic,weak)IBOutlet UITextField *phoneField;
//发送短信验证码
@property (weak, nonatomic) IBOutlet UIButton *sendMsgBtn;
//验证码输入
@property (weak, nonatomic) IBOutlet UITextField *codeField;
//设置密码
@property (weak, nonatomic) IBOutlet UITextField *setPasswordField;
//提交
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;




@property (nonatomic,strong)LoginForgetViewModel *viewModel;
@end

@implementation LoginForgetViewController
@synthesize viewModel = _viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel.title = @"忘记密码";
    
    self.setPasswordField.maxLenght = 20;
    self.phoneField.maxLenght = 11;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- private

- (LoginForgetViewModel*)viewModel
{
    if (!_viewModel) {
        _viewModel = [[LoginForgetViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}

- (void)bindViewModel
{
    [super bindViewModel];
    //绑定数据
    RAC(self.viewModel,phone) = self.phoneField.rac_textSignal;
    RAC(self.viewModel,phoneCode) = self.codeField.rac_textSignal;
    RAC(self.viewModel,password) = self.setPasswordField.rac_textSignal;
    RAC(self.sendMsgBtn.titleLabel,text) = RACObserve(self.viewModel,phoneCodeText);
    //判断获取验证码按钮是否可以用
    RAC(self.sendMsgBtn, enabled) = self.viewModel.validCodeSignal;
    RAC(self.sendMsgBtn, backgroundColor) = [self.viewModel.validCodeSignal
                                             map:^id(NSNumber *usernameIsValid) {
                                                 return usernameIsValid.boolValue ? MasterDefaultColor : [UIColor colorWithHex:0xcccccc];
                                             }];
    
    //判断按钮是否可以用
    RAC(self.submitBtn, enabled) = self.viewModel.validForgetSignal;
    RAC(self.submitBtn, backgroundColor) = [self.viewModel.validForgetSignal
                                                 map:^id(NSNumber *usernameIsValid) {
                                                     return usernameIsValid.boolValue ? MasterDefaultColor : [UIColor colorWithHex:0xcccccc];
                                                 }];
    
    @weakify(self)
    
    //点击获取验证码动作
    [[self.sendMsgBtn
      rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self)
         [self.viewModel.phoneCodeCommand execute:nil];
     }];
    
    //用户
    [[self.submitBtn
      rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self)
         [self.viewModel.forgetCommand execute:nil];
     }];
    
    //按发送键
    [[self.setPasswordField.rac_keyboardReturnSignal filter:^BOOL(id value) {
        @strongify(self)
        return self.submitBtn.enabled;
    }] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.forgetCommand execute:nil];
    }];
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
