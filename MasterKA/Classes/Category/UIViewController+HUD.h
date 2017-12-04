//
//  UIViewController+HUD.h
//  MasterKA
//
//  Created by jinghao on 16/4/15.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
@interface UIViewController (HUD)


- (void)showHUDWithString:(NSString*)message;

- (void)showHUDWithString:(NSString*)message animated:(BOOL)animated;

- (void)hiddenHUD;

- (void)hiddenHUDWithString:(NSString*)message error:(BOOL)error;

- (void)toastWithString:(NSString*)message error:(BOOL)error;
@end
