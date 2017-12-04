//
//  ExchangeViewController.m
//  MasterKA
//
//  Created by hyu on 16/5/10.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "ExchangeViewController.h"

@interface ExchangeViewController ()

@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"兑换码领福利"];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackNormal"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    [self.navigationItem setLeftBarButtonItem:backItem];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)exChange:(id)sender {
    if(_codeText.text.length >0){
        if(_telephone.text.length ==11){
            [[[HttpManagerCenter sharedHttpManager] exChangeCode:_codeText.text Bymobile:_telephone.text resultClass:nil] subscribeNext:^(BaseModel *model){
                if(model.code==200){
                     [self toastWithString:model.message error:NO];
                    
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8/*延迟执行时间*/ * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        if([model.data[@"tag"] isEqual:@"Mpoint"]){
                            [self pushToViewController:@"MyScoreAccountControllor"];
                        }else if ([model.data[@"tag"] isEqual:@"Card"]){
                            [self pushToViewController:@"MyCardViewController"];
                        }else{
                            [self pushToViewController:@"MyCouponViewController"];
                        }
                    });

            }else{
                    [self toastWithString:model.message error:NO];
                }
            }];

        }else{
         [self toastWithString:@"填写正确手机号" error:NO];
        }
    }else{
        [self toastWithString:@"填写验证码" error:NO];
    }
}
- (void)toastWithString:(NSString*)message error:(BOOL)error{
    
    [[self getHUDView] makeToast:message duration:1.5f position:@"center" image:nil];
}
-(void)pushToViewController:(NSString *)viewController{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
    UIViewController* vct= [story instantiateViewControllerWithIdentifier:viewController];
    [self pushViewController:vct animated:YES];

}
- (UIView*)getHUDView{
    UIView *HUDSupperView = self.view;
    if (self.navigationController) {
        HUDSupperView = self.navigationController.view;
    }
    return HUDSupperView;
}
- (void)gotoBack{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
