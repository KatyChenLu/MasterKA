//
//  KAOrderShareViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/20.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAOrderShareViewController.h"

@interface KAOrderShareViewController ()
@property (nonatomic, strong)NSDictionary *info;
@end

@implementation KAOrderShareViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//     self.navigationController.navigationBar.hidden = YES;
//}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shareTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:28];
    RACSignal *fetchSignal = [[HttpManagerCenter sharedHttpManager] getActivityInviteWithOid:self.oid orderStatus:self.orderStatus resultClass:nil];
    
    [fetchSignal subscribeNext:^(BaseModel *baseModel) {
        if (baseModel.code == 200) {
            self.info = baseModel.data;
            [self.shareImgView setImageWithURLString:baseModel.data[@"course_cover"] placeholderImage:nil];
            self.shareTitleLabel.text = baseModel.data[@"activity_start_time"];
            [self.erweimaImgView setImageWithURLString:baseModel.data[@"qr_url"] placeholderImage:nil];
            NSString *conStr = [NSString stringWithFormat:@"%@\n%@人参加\n%@",baseModel.data[@"title"],baseModel.data[@"people_num"],baseModel.data[@"activity_address"]];
            self.conLabel.text = conStr;
        }
        
    }completed:^{
        
        
    }];
    
}
- (IBAction)shareBtnAction:(id)sender {
    [self shareContentOfApp:self.info[@"share_data"]];
}
- (void)showShareOrder:(NSDictionary *)dic {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
