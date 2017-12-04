//
//  ViewControllerAnimation.m
//  MasterKA
//
//  Created by jinghao on 15/12/18.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "ViewControllerAnimation.h"

@implementation ViewControllerAnimation

- (id)init{
    if (self==[super init]) {
        self.animationType = ViewControllerAnimationNone;
        self.animationTime = 1.0f;
    }
    return self;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
//    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    
//    [[transitionContext containerView] addSubview:toViewController.view];
//    toViewController.view.alpha = 0;
//
//    [UIView animateWithDuration:0.3*[self transitionDuration:transitionContext]  animations:^{
//        fromViewController.view.transform = CGAffineTransformMakeScale(0.6, 0.6);
//        toViewController.view.alpha = 0.3;
//    } completion:^(BOOL finished) {
//        
//        [UIView animateWithDuration:0.3*[self transitionDuration:transitionContext]  animations:^{
//            
//            fromViewController.view.transform = CGAffineTransformMakeScale(1.1, 1.1);
//            toViewController.view.alpha = 0.6;
//            
//        } completion:^(BOOL finished){
//            
//            [UIView animateWithDuration:0.4*[self transitionDuration:transitionContext] animations:^{
//                
//                fromViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
//                toViewController.view.alpha = 1.0;
//            } completion:^(BOOL finished){
//                
//                fromViewController.view.transform = CGAffineTransformIdentity;
//                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//            }];
//        }];
//    }];
    switch (self.animationType) {
        case ViewControllerAnimationDefault:
            
            break;
        case ViewControllerAnimationFadeIn:
            [self fadeInAnimateTransition:transitionContext];
        default:
            break;
    }
}


- (void)toLeftAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect finalFrameForVc = [transitionContext finalFrameForViewController:toViewController];
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    toViewController.view.frame = CGRectInset(finalFrameForVc, 0, bounds.size.height);
    
    [[transitionContext containerView] addSubview:toViewController.view];
    
    [UIView animateWithDuration:0.3*[self transitionDuration:transitionContext]  animations:^{
        fromViewController.view.alpha = 0.8;
        toViewController.view.frame = finalFrameForVc;
    } completion:^(BOOL finished) {
        // 声明过渡结束-->记住，一定别忘了在过渡结束时调用 completeTransition: 这个方法
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}


- (void)fadeInAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    [UIView animateWithDuration:0.3*[self transitionDuration:transitionContext]  animations:^{
//        fromViewController.view.transform = CGAffineTransformMakeScale(0.6, 0.6);
        fromViewController.view.alpha = 0.3;
        
//        fromViewController.view.transform = CGAffineTransformMakeTranslation(-320, 0);
        toViewController.view.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        // 声明过渡结束-->记住，一定别忘了在过渡结束时调用 completeTransition: 这个方法
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.animationTime;
}

@end
