//
//  ChangePasswordViewController.m
//  MasterKA
//
//  Created by xmy on 16/4/15.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPassword;


@property (weak, nonatomic) IBOutlet UITextField *passwordNew;


@property (weak, nonatomic) IBOutlet UITextField *passwordNew2;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"修改密码";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)submit:(id)sender {
    
    if(self.oldPassword.text && self.passwordNew.text && self.passwordNew2.text &&
       ![self.oldPassword.text isEqualToString:@""] && ![self.passwordNew.text isEqualToString:@""] && ![self.passwordNew.text isEqualToString:@""]){
        
        if(![self.passwordNew.text isEqualToString:self.passwordNew2.text]){
            [self toastWithString:@"两次输入的新密码不一致！" error:NO];
            return;
        }
        
    }else{
        [self toastWithString:@"请填写完整后再提交！" error:NO];
        return;
    }
    
    
        [self showHUDWithString:@"提交中..."];
        HttpManagerCenter *httpService = [HttpManagerCenter sharedHttpManager];
        [[httpService resetPassword:self.oldPassword.text password_new:self.passwordNew.text resultClass:nil] subscribeNext:^(BaseModel *model) {
    
            [self toastWithString:model.message error:NO];
            if(model.code == 200){
                [self toastWithString:@"修改成功请重新登录" error:NO];
                HttpManagerCenter *httpService = [HttpManagerCenter sharedHttpManager];
                [[httpService logout:nil] subscribeNext:^(BaseModel *model) {
                } error:^(NSError *error) {
                } completed:^{
                    //         [self hiddenHUDWithString:nil error:NO];
                }];
                [[UserClient sharedUserClient] outLogin];
                [self doLogin];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }
    
        } error:^(NSError *error) {
    
    
    
        } completed:^{
             [self hiddenHUD];
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
