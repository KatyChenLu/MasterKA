//
//  UIWindow+ViewController.h
//  MasterKA
//
//  Created by jinghao on 16/1/22.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (ViewController)
+ (UIViewController*)topViewControllerForWindow;
+ (UIViewController*)currentViewControllerForWindow;

@end
