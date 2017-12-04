//
//  ScrollPageViewController.h
//  MasterKA
//
//  Created by jinghao on 16/4/21.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseViewController.h"
#import "HMSegmentedControl.h"
#import "BaseViewController.h"

@class ScrollPageViewController;
@protocol ScrollPageViewControllerDelegate <NSObject>
@optional
/**
 控制器结束滑动时调用该方法，返回当前显示的视图控制器
 */
-(void)viewPagerViewController:(ScrollPageViewController *)viewPager didFinishScrollWithCurrentViewController:(UIViewController *)viewController;
/**
 控制器将要开始滑动时调用该方法，返回当前将要滑动的视图控制器
 */
-(void)viewPagerViewController:(ScrollPageViewController *)viewPager willScrollerWithCurrentViewController:(UIViewController *)ViewController;
@end

@protocol ScrollPageViewControllerDataSource <NSObject>

@required
- (NSInteger)numberOfViewControllersInViewPager:(ScrollPageViewController *)viewPager;
- (UIViewController *)viewPager:(ScrollPageViewController *)viewPager indexOfViewControllers:(NSInteger)index;

@optional
-(UIView *)headerViewForInViewPager:(ScrollPageViewController *)viewPager;
-(CGFloat)heightForTitleOfViewPager:(ScrollPageViewController *)viewPager;
-(CGFloat)heightForHeaderOfViewPager:(ScrollPageViewController *)viewPager;

@end

@interface ScrollPageViewController : BaseViewController

@property (nonatomic,readonly,strong)UIScrollView *contentScrollView;

@property (nonatomic,weak) id<ScrollPageViewControllerDataSource>dataSource;
@property (nonatomic,weak) id<ScrollPageViewControllerDelegate>delegate;
@property (nonatomic,readonly,strong)HMSegmentedControl *segmentedControl;
@property (nonatomic)NSInteger selectViewPageIndex;
- (void)reload;

-(void)updateNavTitle:(BOOL)status;

@end


