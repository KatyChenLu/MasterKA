//
//  BaseNavigationController.m
//  MasterKA
//
//  Created by jinghao on 15/12/11.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
//    self.navigationBar.shadowImageColor = MasterDefaultColor;
//    self.navigationBar.backgroundImageColor = MasterDefaultColor;
    self.navigationBar.translucent = NO;
    self.navigationBar.tintColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


// New Autorotation support.
- (BOOL)shouldAutorotate{
    return TRUE;
}


#pragma mask -- UINavigationControllerDelegate
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (self.vctAnimation && self.vctAnimation.animationType != ViewControllerAnimationNone) {
        if (operation == UINavigationControllerOperationPop) {
            return self.vctAnimation;
        }else if (operation == UINavigationControllerOperationPush) {
            return self.vctAnimation;
        }
    }
    return nil;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    if (navigationController.viewControllers[0]==viewController) {
//        viewController.hidesBottomBarWhenPushed = NO;
////        [self.tabBarController.tabBar setHidden:NO];
//    }else{
////        [self.tabBarController.tabBar setHidden:YES];
//        viewController.hidesBottomBarWhenPushed = YES;
//    }
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
