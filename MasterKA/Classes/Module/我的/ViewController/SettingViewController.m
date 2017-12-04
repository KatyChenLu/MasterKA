//
//  SettingViewController.m
//  MasterKA
//
//  Created by xmy on 16/4/15.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "SettingViewController.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "MainTabBarController.h"

@interface SettingViewController ()<UIAlertViewDelegate>

@end

@implementation SettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"设置"];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

- (IBAction)feedBack:(id)sender {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
    UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
    [self pushViewController:myView animated:YES];
}

- (IBAction)commentMaster:(id)sender {
    //去评分
    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",@"925646944"];
    NSURL * url = [NSURL URLWithString:str];
    
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"打开AppStore失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (IBAction)aboutMaster:(id)sender {
    
    NSString *path = [UserClient sharedUserClient].about_us_url;
    [self pushViewControllerWithUrl:path];
    
}

- (IBAction)clearCache:(id)sender {
    
    NSString *cacheSize = [self getCacheImageSize];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
    }];

    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"已成功清除%@缓存数据",cacheSize] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    [alertView show];
    
}



- (IBAction)exitAction:(id)sender {
    
//    [self showHUDWithString:@"提交中..."];
    HttpManagerCenter *httpService = [HttpManagerCenter sharedHttpManager];
    [[httpService logout:nil] subscribeNext:^(BaseModel *model) {
        
        
        NSMutableDictionary* loginInfo = [NSMutableDictionary dictionary];
        [loginInfo setObject:@"1" forKey:@"type"];
        
        
    } error:^(NSError *error) {
        
        
        
    } completed:^{
//         [self hiddenHUDWithString:nil error:NO];
    }];
    

    [[UserClient sharedUserClient] outLogin];
    [[UserClient sharedUserClient] outChanegeUid];
 
    
    MainTabBarController * tabBar = (MainTabBarController *)self.tabBarController;
    
    
    
    tabBar.selectedIndex = 0;
    
    UIButton * btn =   tabBar.tabBarBtn[4];
    
    btn.selected = NO;
    
    
    btn = tabBar.tabBarBtn[0];
    
    btn.selected = YES;
    
    
    [self.navigationController popViewControllerAnimated:NO];
}


- (NSString*)getCacheImageSize{
    //    float diskSize = 1.0f*(long)[NSURLCache sharedURLCache].currentDiskUsage;
    float diskSize = 1.0f*[SDImageCache sharedImageCache].getSize;
    diskSize = diskSize/1024.0f;
    if (diskSize>1024) {
        diskSize = diskSize/1024.0f;
        return [NSString stringWithFormat:@"%.2fMb",diskSize];
    }else{
        //        diskSize = 0.0f;
        return [NSString stringWithFormat:@"%.2fKb",diskSize];
    }
}

@end
