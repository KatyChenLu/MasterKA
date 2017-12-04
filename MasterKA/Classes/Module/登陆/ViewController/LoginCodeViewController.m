//
//  LoginCodeViewController.m
//  MasterKA
//
//  Created by jinghao on 16/4/11.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "LoginCodeViewController.h"
#import "LoginCodeViewModel.h"

@interface LoginCodeViewController ()
@property (nonatomic,weak)IBOutlet UITextField *phoneCodeField;
@property (nonatomic,weak)IBOutlet UIButton *phoneCodeButton;
@property (nonatomic,weak)IBOutlet UILabel *codeTipsLabel;

@property (nonatomic,strong)LoginCodeViewModel *viewModel;

@end

@implementation LoginCodeViewController
@synthesize viewModel = _viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem addRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction:)] animated:TRUE];
    self.viewModel.title = @"重置密码";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- private

- (LoginCodeViewModel*)viewModel{
    if (!_viewModel) {
        _viewModel = [[LoginCodeViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}

- (void)nextAction:(id)sender{
    [self performSegueWithIdentifier:@"gotoLoginResetPwd" sender:self];
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
