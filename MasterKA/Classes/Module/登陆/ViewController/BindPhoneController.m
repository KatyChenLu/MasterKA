//
//  BindPhoneController.m
//  MasterKA
//
//  Created by 余伟 on 16/7/7.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BindPhoneController.h"

#import "Masonry.h"

#import "BindPhoneModel.h"

@interface BindPhoneController ()




//电话号码
@property (nonatomic,weak)IBOutlet UITextField *phoneField;
//验证码
@property (nonatomic,weak)IBOutlet UITextField *phoneCodeField;
//密码
//@property (nonatomic,weak)IBOutlet UITextField *passwordField;
//获取验证码按钮
@property (nonatomic,weak)IBOutlet UIButton *codeButton;

//提交注册按钮
@property (nonatomic,weak)IBOutlet UIButton *determineButton;
//同意协议按钮
//@property (nonatomic,weak)IBOutlet UIButton *acceptButton;
////打开协议按钮
//@property (nonatomic,weak)IBOutlet UIButton *protocolButton;

@property (nonatomic,strong)BindPhoneModel *viewModel;



@end

@implementation BindPhoneController

{
    
    
    
}


@synthesize viewModel = _viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    self.phoneField.maxLenght = 11;
    
    
    
    
    
//    [self.phoneNumFiled addTarget:self action:@selector(phoneNumFiledInput:) forControlEvents:UIControlEventValueChanged];
//    
//    
//    [self.authorNumField addTarget: self action:@selector(authorNumFieldiInput:) forControlEvents:UIControlEventValueChanged];
//    
//    

}


- (BindPhoneModel*)viewModel
{
    if (!_viewModel) {
        _viewModel = [[BindPhoneModel alloc] initWithViewController:self];
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
//    RAC(self.viewModel,password) = self.passwordField.rac_textSignal;
    
//    RAC(self.viewModel,acceptAgreement) = RACObserve(self.acceptButton,selected);
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
    RAC(self.determineButton, enabled) = self.viewModel.validDetermineSignal;
    RAC(self.determineButton, backgroundColor) = [self.viewModel.validDetermineSignal
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
    
    //确定
    [[self.determineButton
      rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self)
         [self.viewModel.determineCommand execute:nil];
         
         
         
         
        
     }];
    
    //按发送键
    [[self.phoneCodeField.rac_keyboardReturnSignal filter:^BOOL(id value) {
        @strongify(self)
        return self.determineButton.enabled;
    }] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.determineCommand execute:nil];
    }];
    
//    //同意协议
//    [[self.acceptButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button) {
//        button.selected = !button.selected;
//    }];
//    
//    //查看协议
//    [[self.protocolButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button) {
//        //TODO  查看协议
//        @strongify(self);
//        [self pushViewControllerWithUrl:self.userClient.agree_url];
//    }];
}












@end
