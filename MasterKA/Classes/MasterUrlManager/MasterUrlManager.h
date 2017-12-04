//
//  MasterUrlManager.h
//  MasterKA
//
//  Created by jinghao on 16/1/8.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+URL.h"
#import "NSString+URL.h"
#import "NSURL+URL.h"
#import "BaseViewModel.h"
@interface MasterUrlManager : NSObject
@property (nonatomic, unsafe_unretained)UINavigationController  *currentNav;
@property (nonatomic, unsafe_unretained)UITabBarController      *currentTab;
@property (nonatomic, unsafe_unretained)UIViewController        *currentVC;

+ (MasterUrlManager*)shareMasterUrlManager;
+ (UIViewController*)getViewControllerWithUrl:(NSString*)url;

- (UIViewController*)viewControllerWithUrl:(NSString*)url;


- (UIViewController*)viewControllerForViewModel:(BaseViewModel*)viewModel;

- (void)setViewControllerName:(NSString *)className forURL:(NSString *)url;
- (void)setViewControllerNameForPrivate:(NSString *)className forURL:(NSString *)url;

//- (void)setViewController:(UIViewController *)vc forURL:(NSString *)url;

- (void)openURL:(NSURL *)url withQuery:(NSDictionary *)query;
- (void)openURL:(NSURL *)url;
- (void)addStoryboardName:(NSString*)name;


- (BOOL)isPrivateUrl:(NSURL *)url;

- (BOOL)isPrivateUrlString:(NSString*)urlString;
@end
