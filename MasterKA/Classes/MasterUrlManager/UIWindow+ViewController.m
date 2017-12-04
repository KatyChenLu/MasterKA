//
//  UIWindow+ViewController.m
//  MasterKA
//
//  Created by jinghao on 16/1/22.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "UIWindow+ViewController.h"

@implementation UIWindow (ViewController)
+ (UIViewController*)topViewControllerForWindow{
    UIViewController *topController = [[UIApplication sharedApplication].windows.lastObject rootViewController];
    //  Getting topMost ViewController
    while ([topController presentedViewController])	topController = [topController presentedViewController];
    
    //  Returning topMost ViewController
    return topController;
}
+ (UIViewController*)currentViewControllerForWindow{
    UIViewController *currentViewController = [self topViewControllerForWindow];
    
    while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)currentViewController topViewController])
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    
    return currentViewController;
}
@end
