//
//  NavigationControllerStack.m
//  MasterKA
//
//  Created by jinghao on 16/3/3.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "NavigationControllerStack.h"
#import "BaseViewController.h"
#import "BaseNavigationController.h"

@interface NavigationControllerStack ()<UINavigationControllerDelegate>
@property (nonatomic, strong) id<ViewModelServices> services;
@property (nonatomic, strong) NSMutableArray *navigationControllers;

@end

@implementation NavigationControllerStack
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    NavigationControllerStack *navigationControllerStack = [super allocWithZone:zone];
    @weakify(navigationControllerStack)
    [[navigationControllerStack
      rac_signalForSelector:@selector(initWithServices:)]
    	subscribeNext:^(id x) {
            @strongify(navigationControllerStack)
            [navigationControllerStack registerNavigationHooks];
        }];
    return navigationControllerStack;
}

- (instancetype)initWithServices:(id<ViewModelServices>)services {
    self = [super init];
    if (self) {
        _services = services;
        _navigationControllers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)pushNavigationController:(UINavigationController *)navigationController {
    if ([self.navigationControllers containsObject:navigationController]) return;
    [self.navigationControllers addObject:navigationController];
}

- (UINavigationController *)popNavigationController {
    UINavigationController *navigationController = self.navigationControllers.lastObject;
    [self.navigationControllers removeLastObject];
    return navigationController;
}

- (UINavigationController *)topNavigationController {
    return self.navigationControllers.lastObject;
}

- (void)registerNavigationHooks {
    @weakify(self)
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(pushViewModel:animated:)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         
         UIViewController *viewController = (UIViewController *)[[MasterUrlManager shareMasterUrlManager] viewControllerForViewModel:tuple.first];
         viewController.hidesBottomBarWhenPushed = YES;
         [self.navigationControllers.lastObject pushViewController:viewController animated:[tuple.second boolValue]];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(popViewModelAnimated:)]
     subscribeNext:^(RACTuple *tuple) {
        	@strongify(self)
         [self.navigationControllers.lastObject popViewControllerAnimated:[tuple.first boolValue]];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(popToRootViewModelAnimated:)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         [self.navigationControllers.lastObject popToRootViewControllerAnimated:[tuple.first boolValue]];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(presentViewModel:animated:completion:)]
     subscribeNext:^(RACTuple *tuple) {
        	@strongify(self)
         UIViewController *viewController = (UIViewController *)[[MasterUrlManager shareMasterUrlManager] viewControllerForViewModel:tuple.first];
         
         UINavigationController *presentingViewController = self.navigationControllers.lastObject;
         if (![viewController isKindOfClass:UINavigationController.class]) {
             viewController = [[BaseNavigationController alloc] initWithRootViewController:viewController];
         }
         [self pushNavigationController:(UINavigationController *)viewController];
         
         [presentingViewController presentViewController:viewController animated:[tuple.second boolValue] completion:tuple.third];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(dismissViewModelAnimated:completion:)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         [self popNavigationController];
         [self.navigationControllers.lastObject dismissViewControllerAnimated:[tuple.first boolValue] completion:tuple.second];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(resetRootViewModel:)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         [self.navigationControllers removeAllObjects];
         
         UIViewController *viewController = (UIViewController *)[[MasterUrlManager shareMasterUrlManager] viewControllerForViewModel:tuple.first];
         
         if (![viewController isKindOfClass:[UINavigationController class]]/* && ![viewController isKindOfClass:[MRCTabBarController class]]*/) {
             viewController = [[BaseNavigationController alloc] initWithRootViewController:viewController];
             ((UINavigationController *)viewController).delegate = self;
             [self pushNavigationController:(UINavigationController *)viewController];
         }
         
         SharedAppDelegate.window.rootViewController = viewController;
     }];
}

#pragma mark - UINavigationControllerDelegate

//- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
//                         interactionControllerForAnimationController:(MRCViewControllerAnimatedTransition *)animationController {
//    return animationController.fromViewController.interactivePopTransition;
//}
//
//- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
//                                  animationControllerForOperation:(UINavigationControllerOperation)operation
//                                               fromViewController:(MRCViewController *)fromVC
//                                                 toViewController:(MRCViewController *)toVC {
//    if (fromVC.interactivePopTransition != nil) {
//        return [[MRCViewControllerAnimatedTransition alloc] initWithNavigationControllerOperation:operation
//                                                                               fromViewController:fromVC
//                                                                                 toViewController:toVC];
//    }
//    return nil;
//}

@end
