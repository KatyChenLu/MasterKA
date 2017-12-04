//
//  UIViewController+POP.m
//  MasterKA
//
//  Created by jinghao on 16/5/4.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "UIViewController+POP.h"

#define kMaskViewKey        @"MaskView"
#define kPOPToolsViewKey        @"POPToolsViewKey"
#define kPOPDelegateKey        @"POPDelegateKey"

@implementation UIViewController (POP)
@dynamic maskView;


- (void)setPopDelegate:(id<POPViewControllerDelegate>)popDelegate
{
    objc_setAssociatedObject(self, kPOPDelegateKey, popDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<POPViewControllerDelegate>)popDelegate
{
    return objc_getAssociatedObject(self, kPOPDelegateKey);
}

- (void)setMaskView:(UIView *)maskView
{
    objc_setAssociatedObject(self, kMaskViewKey, maskView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)maskView
{
    return objc_getAssociatedObject(self, kMaskViewKey);
}

- (void)setToolsView:(PopControllerToolsView *)toolsView
{
    objc_setAssociatedObject(self, kPOPToolsViewKey, toolsView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (PopControllerToolsView *)toolsView
{
    PopControllerToolsView* view  =  (PopControllerToolsView*)objc_getAssociatedObject(self, kPOPToolsViewKey);
    if (view==nil) {
        view = [PopControllerToolsView loadInstanceFromNib];
        objc_setAssociatedObject(self, kPOPToolsViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return view;
}


- (void)popViewControllerWithMask:(UIViewController *)poppedVC animated:(BOOL)animated
{
    [self popViewControllerWithMask:poppedVC animated:animated setEdgeInsets:UIEdgeInsetsZero];
}
- (void)popViewControllerWithMask:(UIViewController *)poppedVC animated:(BOOL)animated setEdgeInsets:(UIEdgeInsets)edgeInsets
{
    poppedVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    poppedVC.view.alpha = 0;
    poppedVC.view.backgroundColor = [UIColor clearColor];
    
    UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    maskView.alpha = 0.0;
    maskView.translatesAutoresizingMaskIntoConstraints = NO;
    
    poppedVC.maskView = maskView;
//    @weakify(self);
    [maskView setTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
//        @strongify(self);
        [poppedVC dismissPopControllerWithMaskAnimated:YES];
    }];
    [self.view addSubview:maskView];
    
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    poppedVC.toolsView.titleView.text = poppedVC.title;
//    poppedVC.toolsView = self.toolsView;
    self.toolsView = poppedVC.toolsView ;
    [self addChildViewController:poppedVC];
    [self.view addSubview:poppedVC.view];
    [poppedVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(edgeInsets);
    }];

//    NSLog(@"==UIControlEventTouchUpInside=== %@",[self.toolsView.closeButton actionsForTarget:poppedVC forControlEvent:UIControlEventTouchUpInside]);
//    if([self.toolsView.closeButton actionsForTarget:poppedVC forControlEvent:UIControlEventTouchUpInside].count==0){
//        [self.toolsView.closeButton addTarget:self action:@selector(closeButtonToosView:) forControlEvents:UIControlEventTouchUpInside];
//    }
    
    [self.toolsView.closeButton addTarget:self action:@selector(closeButtonToosView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.toolsView.cancleButton addTarget:self action:@selector(cancleButtonToosView:) forControlEvents:UIControlEventTouchUpInside];
    
    self.toolsView.alpha = 0.0;
    [self.view addSubview:poppedVC.toolsView];
    [self.toolsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(self.toolsView.hidden?@(0):@(44));
        make.bottom.mas_equalTo(poppedVC.view.mas_top);
    }];
    
    if (animated) {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             maskView.alpha = 1.0;
                             poppedVC.view.alpha = 1.0;
                             self.toolsView.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                             [poppedVC didMoveToParentViewController:self.navigationController];
                         }
         ];
    }
    else {
        maskView.alpha = 1.0;
        poppedVC.view.alpha = 1.0;
        self.toolsView.alpha = 1.0;
        [poppedVC didMoveToParentViewController:self.navigationController];
    }

}

- (void)closeButtonToosView:(id)sender{
    UIViewController *vct = self.childViewControllers.lastObject;
    if (vct.popDelegate && [vct.popDelegate respondsToSelector:@selector(popViewControllerDismissForColse)]) {
        [vct.popDelegate popViewControllerDismissForColse];
    }
    [vct dismissPopControllerWithMaskAnimated:YES];
}

- (void)cancleButtonToosView:(id)sender{
    UIViewController *vct = self.childViewControllers.lastObject;
    [vct dismissPopControllerWithMaskAnimated:YES];
}


- (void)dismissPopControllerWithMaskAnimated:(BOOL)animated
{
    if (self.maskView==nil) {
        return;
    }
    [self willMoveToParentViewController:nil];
    if (animated) {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             self.maskView.alpha = 0.0;
                             self.toolsView.alpha = 0.0;
                             self.view.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             [self.maskView removeFromSuperview];
                             [self.view removeFromSuperview];
                             [self removeFromParentViewController];
                             [self.toolsView removeFromSuperview];
                             self.toolsView = nil;
                             self.maskView =nil;
                         }
         ];
    }
    else {
        self.maskView.alpha = 0.0;
        self.view.alpha = 0.0;
        self.toolsView.alpha = 0.0;
        [self.maskView removeFromSuperview];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        [self.toolsView removeFromSuperview];
        self.maskView =nil;
        self.toolsView = nil;
    }
}

@end
