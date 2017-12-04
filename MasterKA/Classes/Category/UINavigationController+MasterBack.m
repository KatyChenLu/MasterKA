//
//  UINavigationController+MasterBack.m
//  MasterKA
//
//  Created by ChenLu on 2017/6/9.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "UINavigationController+MasterBack.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@implementation UINavigationController (MasterBack)
//+ (void)load {
//    Method m1 = class_getInstanceMethod([self class], @selector(viewDidLoad));
//    Method m2 = class_getInstanceMethod([self class], @selector(master_viewDidLoad));
//    
//    BOOL sel = class_addMethod(self, @selector(viewDidLoad), method_getImplementation(m2), method_getTypeEncoding(m2));
//    if (!sel) {
//        method_exchangeImplementations(m1, m2);
//    }else{
//        class_replaceMethod(self, @selector(master_viewDidLoad), method_getImplementation(m1), method_getTypeEncoding(m2));
//    }
//}
//
//- (void)master_viewDidLoad {
//    [self master_viewDidLoad];
//    
//    UIGestureRecognizer *tempGes = self.interactivePopGestureRecognizer;
//    tempGes.enabled = NO;
//    
//    NSMutableArray *mutableArray = [tempGes valueForKey:@"_targets"];
//    
//    id ter =  [[mutableArray firstObject] valueForKey:@"target"];
//    SEL sel = NSSelectorFromString(@"handleNavigationTransition:");
//    
//    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:ter action:sel];
//    [tempGes.view addGestureRecognizer:pan];
//}

@end
