//
//  HJHPageViewController.h
//  MasterKA
//
//  Created by jinghao on 15/12/15.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "BaseViewController.h"

@class HJHPageViewController;
@protocol HJHPageViewControllerDelegate <NSObject>
@optional
/**
 控制器结束滑动时调用该方法，返回当前显示的视图控制器
 */
-(void)viewPagerViewController:(HJHPageViewController *)viewPager didFinishScrollWithCurrentViewController:(UIViewController *)viewController;
/**
 控制器将要开始滑动时调用该方法，返回当前将要滑动的视图控制器
 */
-(void)viewPagerViewController:(HJHPageViewController *)viewPager willScrollerWithCurrentViewController:(UIViewController *)ViewController;
@end

@protocol HJHPageViewControllerDataSource <NSObject>

@required
- (NSInteger)numberOfViewControllersInViewPager:(HJHPageViewController *)viewPager;
- (UIViewController *)viewPager:(HJHPageViewController *)viewPager indexOfViewControllers:(NSInteger)index;

@optional
-(UIView *)headerViewForInViewPager:(HJHPageViewController *)viewPager;
-(CGFloat)heightForTitleOfViewPager:(HJHPageViewController *)viewPager;
-(CGFloat)heightForHeaderOfViewPager:(HJHPageViewController *)viewPager;

@end

@interface HJHPageViewController : BaseViewController

@property (nonatomic,weak) id<HJHPageViewControllerDataSource>dataSource;
@property (nonatomic,weak) id<HJHPageViewControllerDelegate>delegate;
@property (nonatomic,readonly,strong)HMSegmentedControl *segmentedControl;
@property (nonatomic)NSInteger selectViewPageIndex;
- (void)reload;
@end
