//
//  LoginResetPwdViewController.m
//  MasterKA
//
//  Created by jinghao on 16/4/11.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "LoginResetPwdViewController.h"
#import "LoginResetPwdViewModel.h"
@interface LoginResetPwdViewController ()
@property (nonatomic,weak)IBOutlet UITextField *passwordField;
@property (nonatomic,weak)IBOutlet UITextField *rePasswordField;

@property (nonatomic,strong)LoginResetPwdViewModel *viewModel;

@end

@implementation LoginResetPwdViewController
@synthesize viewModel = _viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem addRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction:)] animated:TRUE];
    self.viewModel.title = @"重置密码";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- private

- (LoginResetPwdViewModel*)viewModel{
    if (!_viewModel) {
        _viewModel = [[LoginResetPwdViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}

- (void)nextAction:(id)sender{
    [self gotoBack:self viewControllerName:@"LoginViewController"];
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
