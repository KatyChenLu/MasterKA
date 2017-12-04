//
//  UIViewController+HUD.m
//  MasterKA
//
//  Created by jinghao on 16/4/15.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "UIViewController+HUD.h"

@implementation UIViewController (HUD)

- (void)showHUDWithString:(NSString*)message{
    [self showHUDWithString:message animated:TRUE];
}
- (void)showHUDWithString:(NSString*)message animated:(BOOL)animated{
    MBProgressHUD *hud = [self getProgressHUDView];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = message;
    [hud showAnimated:animated];
    
    
}

- (void)hiddenHUD{
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:[self getHUDView]];
//    if (hud.delayTime==0) {
        [hud hideAnimated:YES];
//    }
//    [MBProgressHUD hideHUDForView:[self getHUDView] animated:TRUE];
}

- (void)hiddenHUDWithString:(NSString*)message error:(BOOL)error{
    MBProgressHUD *hud = [self getProgressHUDView];
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    hud.customView = imageView;
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = message;
    [hud hideAnimated:YES afterDelay:1.0f];
}

- (void)toastWithString:(NSString*)message error:(BOOL)error{
    
    [SharedAppDelegate.window makeToast:message duration:1.f position:@"center" image:nil];
}

- (UIView*)getHUDView{
    UIView *HUDSupperView = self.view;
    if (self.navigationController) {
//        HUDSupperView = self.navigationController.view;
    }
    return HUDSupperView;
}

- (MBProgressHUD*)getProgressHUDView{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:[self getHUDView]];
    if (hud==nil) {
        [MBProgressHUD showHUDAddedTo:[self getHUDView] animated:YES];
        hud = [MBProgressHUD HUDForView:[self getHUDView]];
//        hud = [[MBProgressHUD alloc] initWithView:[self getHUDView]];
//        hud.removeFromSuperViewOnHide = YES;
//        [[self getHUDView] addSubview:hud];
    }
    return hud;
}

@end
