//
//  UIViewController+POP.h
//  MasterKA
//
//  Created by jinghao on 16/5/4.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopControllerToolsView.h"

@protocol POPViewControllerDelegate <NSObject>

- (void)popViewControllerDismissForColse;

@end

@interface UIViewController (POP)
@property (nonatomic, strong) id<POPViewControllerDelegate> popDelegate;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) PopControllerToolsView *toolsView;

- (void)popViewControllerWithMask:(UIViewController *)poppedVC animated:(BOOL)animated;

- (void)popViewControllerWithMask:(UIViewController *)poppedVC animated:(BOOL)animated setEdgeInsets:(UIEdgeInsets)edgeInsets;

- (void)dismissPopControllerWithMaskAnimated:(BOOL)animated;

@end
