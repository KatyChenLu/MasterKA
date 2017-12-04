//
//  SlideMainViewController.m
//  MasterKA
//
//  Created by jinghao on 16/3/2.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "SlideMainViewController.h"
#import "MineRootViewController.h"

@interface SlideMainViewController ()

@end

@implementation SlideMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MineRootViewController *leftMenu = (MineRootViewController*)[UIStoryboard viewController:@"Mine" identifier:@"MineRootViewController"];
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = .18;
    leftMenu.tableViewRightValue = [SlideNavigationController sharedInstance].portraitSlideOffset;
    [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
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
