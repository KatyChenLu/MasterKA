    //
//  MasterUrlManager.m
//  MasterKA
//
//  Created by jinghao on 16/1/8.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MasterUrlManager.h"
#import <objc/objc.h>
#import <objc/runtime.h>
#import "MasterWebViewController.h"
#import "UIWindow+ViewController.h"

@interface MasterUrlManager ()
@property (nonatomic,strong)NSMutableDictionary         *urlConfig;
@property (nonatomic,strong)NSMutableDictionary         *urlConfigPrivate;

@property (nonatomic,strong)NSMutableArray * storyboardArray;
- (void)pushToViewController:(UIViewController *)hostVC;
@end

@implementation MasterUrlManager

+(MasterUrlManager*)shareMasterUrlManager
{
    static MasterUrlManager      *_masterUrlManager = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        _masterUrlManager = [[MasterUrlManager alloc] init];
    });
    return _masterUrlManager;
}

+ (UIViewController*)getViewControllerWithUrl:(NSString*)url
{
    return [[MasterUrlManager shareMasterUrlManager] viewControllerForURL:[NSURL URLWithString:url] withQuery:nil];
}

- (id)init{
    if (self=[super init]) {
        
    }
    return self;
}

- (NSMutableDictionary*)urlConfig{
    if (!_urlConfig) {
        _urlConfig = [[NSMutableDictionary alloc] init];
    }
    return _urlConfig;
}

- (NSMutableDictionary*)urlConfigPrivate
{
    if (!_urlConfigPrivate) {
        _urlConfigPrivate = [[NSMutableDictionary alloc] init];
    }
    return _urlConfigPrivate;
}

- (NSMutableArray*)storyboardArray
{
    if (!_storyboardArray) {
        _storyboardArray = [[NSMutableArray alloc] init];
    }
    return _storyboardArray;
}

#pragma mark -- pirvate

- (void)pushToViewController:(UIViewController*)vct{
    UINavigationController *navCT = nil;
    if (self.currentNav) {
        navCT = self.currentNav;
    }else if (self.currentVC.navigationController){
        navCT = self.currentVC.navigationController;
    }
    if (navCT) {
        [navCT pushViewController:vct animated:TRUE];
    }else{
        //TODO 弹出
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIWindow topViewControllerForWindow] presentViewController:vct animated:TRUE completion:nil];
        });
    }
}

- (UIViewController*)getViewController:(NSString*)value{
    UIViewController *cvt = nil;
    NSLog(@"strat find vc %@",value);
    NSURL *url = [[NSBundle mainBundle] URLForResource:value withExtension:@"xib"];
    if (url) {
        cvt = [[UIViewController alloc] initWithNibName:value bundle:nil];
    }else{
        for (NSString* name in self.storyboardArray) {
            @try {
                cvt = [[UIStoryboard storyboardWithName:name bundle:nil] instantiateViewControllerWithIdentifier:value];
                break;
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }
        if (cvt==nil) {
            cvt = [UIViewController viewControllerWithName:value];
//            if ([UINib nibWithNibName:value bundle:nil]) {
//                Class class = NSClassFromString(value);
//                cvt = (UIViewController *)[[class alloc] initWithNibName:value bundle:nil];
//            }else{
//                Class class = NSClassFromString(value);
//                cvt = (UIViewController *)[[class alloc] init];
//            }
        }
    }
    NSLog(@"end find vc %@",[cvt class]);
    return cvt;
}

#pragma mark -- public


- (UIViewController*)viewControllerWithUrl:(NSString*)url{
    return [self viewControllerForURL:[NSURL URLWithString:url] withQuery:nil];
}

- (UIViewController*)viewControllerForViewModel:(BaseViewModel*)viewModel;
{
    return [self viewControllerForURL:[NSURL URLWithString:viewModel.url] withQuery:nil];
}

- (void)setViewControllerName:(NSString *)className forURL:(NSString *)url
{
    [self.urlConfig setValue:className forKey:url];
}

- (void)setViewControllerNameForPrivate:(NSString *)className forURL:(NSString *)url
{
    [self.urlConfigPrivate setValue:className forKey:url];
    [self setViewControllerName:className forURL:url];
}


- (void)openURL:(NSURL *)url
{
    [self openURL:url withQuery:nil];
}

- (void)openURL:(NSURL *)url withQuery:(NSDictionary *)query
{
    UIViewController *hostVC = [self viewControllerForURL:url withQuery:query];
    [self pushToViewController:hostVC];
//    // Path数组
//    NSArray *pp = [[NSArray alloc] initWithArray:
//                   [url.path componentsSeparatedByString:@"/"]];
//    NSMutableArray *paths = [[NSMutableArray alloc] init];
//    for (NSString *p in pp) {
//        if (p && 0 < p.length) {
//            [paths addObject:p];
//        }
//    }
//    pp = nil;
//    
//    
//    if ([hostVC isKindOfClass:[UITabBarController class]]) {
//        NSInteger index = (0 < paths.count) ? [[paths objectAtIndex:0] integerValue] : 0;
//        UITabBarController *tabBarVC = (UITabBarController *)hostVC;
//        if (index < tabBarVC.viewControllers.count) {
//            tabBarVC.selectedIndex = index;
//        }
//    }else if([hostVC isKindOfClass:[UINavigationController class]]){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            UIBarButtonItem *colseItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:nil action:nil];
//            [((UINavigationController*)hostVC).topViewController.navigationItem setLeftBarButtonItem:colseItem];
//            [[UIWindow topViewControllerForWindow] presentViewController:hostVC animated:TRUE completion:nil];
//        });
//    }else if ([hostVC isKindOfClass:[UIViewController class]]) {
//        // Path第一段被识别为上一级VC
//        if (paths && 0 < paths.count) {
//            UIViewController *vc = [self viewControllerForURL:[NSURL URLWithString:
//                                                               [NSString
//                                                                stringWithFormat:@"%@://%@",
//                                                                url.scheme,
//                                                                [paths objectAtIndex:0]]]
//                                                    withQuery:nil];
//            // 上一级如果是tab，切换，再nav push
//            if ([vc isKindOfClass:[UITabBarController class]]) {
//                NSInteger index = (1 < paths.count) ? [[paths objectAtIndex:1] integerValue] : 0;
//                UITabBarController *tabBarVC = (UITabBarController *)vc;
//                if (index < tabBarVC.viewControllers.count) {
//                    tabBarVC.selectedIndex = index;
//                }
//                [self performSelector:@selector(pushToViewController:)
//                           withObject:hostVC
//                           afterDelay:.3f];
//            }
//        }
//        else {
//            [self pushToViewController:hostVC];
//        }
//    }
}

- (UIViewController *)viewControllerForURL:(NSURL *)url withQuery:(NSDictionary *)query
{
    NSLog(@"viewControllerForURL start");

    UIViewController* viewController = nil;
    NSString *host = url.host;
    NSString *home = [NSString stringWithFormat:@"%@://%@", url.scheme, url.host];
    
    if ([self URLAvailable:url]) {
        if ([[self.urlConfig objectForKey:home] isKindOfClass:[UIViewController class]]) {
            viewController = (UIViewController *)[self.urlConfig objectForKey:home];
        }
        else if ([[self.urlConfig objectForKey:host] isKindOfClass:[UIViewController class]]) {
            viewController = (UIViewController *)[self.urlConfig objectForKey:host];
        }
        else if (nil == query) {
            
            if ([self.urlConfig.allKeys containsObject:home]) {
                viewController = [self getViewController:[self.urlConfig objectForKey:home]];
              
                
            }
            else if ([self.urlConfig.allKeys containsObject:host]) {
                viewController = [self getViewController:[self.urlConfig objectForKey:host]];
               
                
            }
            
            viewController.url = url;
        }
        else {
            
            if ([self.urlConfig.allKeys containsObject:home]) {
                viewController = [self getViewController:[self.urlConfig objectForKey:home]];
               
                
            }
            else if ([self.urlConfig.allKeys containsObject:host]) {
                viewController = [self getViewController:[self.urlConfig objectForKey:host]];
               
                
            }
            viewController.url = url;
            viewController.query = query;

            
        }
    }
    else if ([@"http" isEqualToString:[url scheme]]||[@"https"isEqualToString:[url scheme]]) {
        viewController = (UIViewController *)[[MasterWebViewController alloc] initWithURL:url
                                                                                query:query];
    }
    NSLog(@"viewControllerForURL end");

    return viewController;
}

- (BOOL)URLAvailable:(NSURL *)url
{
    BOOL restult = [self.urlConfig.allKeys containsObject:url.host]
    || [self.urlConfig.allKeys containsObject:[NSString stringWithFormat:@"%@://%@",
                                            url.scheme, url.host]];
    return restult;
}

- (BOOL)isPrivateUrl:(NSURL *)url
{
    return [self.urlConfigPrivate.allKeys containsObject:url.host]
    || [self.urlConfigPrivate.allKeys containsObject:[NSString stringWithFormat:@"%@://%@",
                                               url.scheme, url.host]];
}
- (BOOL)isPrivateUrlString:(NSString*)urlString
{
    if (urlString) {
        return [self isPrivateUrl:[NSURL URLWithString:urlString]];
    }else{
        return FALSE;
    }
}

- (void)addStoryboardName:(NSString*)name{
    if (name && [name isKindOfClass:[NSString class]]) {
        if (![self.storyboardArray containsObject:name]) {
            [self.storyboardArray addObject:name];
        }
    }
}

@end
