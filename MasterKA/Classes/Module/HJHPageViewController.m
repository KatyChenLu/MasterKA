//
//  HJHPageViewController.m
//  MasterKA
//
//  Created by jinghao on 15/12/15.
//  Copyright © 2015年 jinghao. All rights reserved.
//


#import "HJHPageViewController.h"

@interface HJHPageViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIGestureRecognizerDelegate>
{
    NSInteger countOfViews;
}
@property (nonatomic,strong)UIPageViewController* mPageViewController;
@property (nonatomic,strong)HMSegmentedControl *segmentedControl;
@property (nonatomic,strong)NSMutableArray* viewControllerArray;
@property (nonatomic,strong)NSMutableArray* viewControllerTitleArray;
@property (nonatomic,strong)UIView *headerView;     //头部视图
@property (nonatomic,strong)UIView *headerContentView;     //头部视图

@end

@implementation HJHPageViewController
@synthesize selectViewPageIndex = _selectViewPageIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildMainScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildMainScrollView{
    [self.view addSubview:self.headerContentView];
    [self.view addSubview:self.segmentedControl];
    [self addChildViewController:self.mPageViewController];
    [self.view addSubview:self.mPageViewController.view];
    [self.mPageViewController didMoveToParentViewController:self];
}

- (void)resetViewConstraints{
    float titleViewHeight = [self.dataSource respondsToSelector:@selector(heightForTitleOfViewPager:)]?[self.dataSource heightForTitleOfViewPager:self]:0;
    float headViewHeight = [self.dataSource respondsToSelector:@selector(heightForHeaderOfViewPager:)]?[self.dataSource heightForHeaderOfViewPager:self]:0;
    @weakify(self);
    [self.headerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@(headViewHeight));
    }];
    
    
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.equalTo(self.view);
        make.top.mas_equalTo(self.headerContentView.mas_bottom);
        make.height.mas_equalTo(@(titleViewHeight));
    }];
    
    
    [self.mPageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.equalTo(self.view);
        make.top.mas_equalTo(self.segmentedControl.mas_bottom);
//        if (self.tabBarController.tabBar.hidden == YES) {
//            make.bottom.equalTo(self.view);
//        }else{
//            make.bottom.equalTo(self.view).with.offset(-self.tabBarController.tabBar.height);
//        }
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
}

- (UIView*)headerContentView{
    if (!_headerContentView) {
        _headerContentView = [[UIView alloc] init];
    }
    return _headerContentView;
}

#pragma mark -- public


- (void)setDataSource:(id<HJHPageViewControllerDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reload];
}

- (void)setSelectViewPageIndex:(NSInteger)selectViewPageIndex
{
    if (_selectViewPageIndex != selectViewPageIndex) {
        [self showViewControllerByIndex:selectViewPageIndex];
        _selectViewPageIndex = selectViewPageIndex;
        [self.segmentedControl setSelectedSegmentIndex:selectViewPageIndex animated:YES];
    }
    
}

- (NSInteger)selectViewPageIndex
{
    return _selectViewPageIndex;
}

- (void)reload{
    if (self.dataSource) {
        if (![self.dataSource respondsToSelector:@selector(numberOfViewControllersInViewPager:)]) {
            return;
        }
        
        [self.viewControllerArray removeAllObjects];
        [self.viewControllerTitleArray removeAllObjects];
        
        countOfViews = [self.dataSource numberOfViewControllersInViewPager:self];
        for (int i=0; i<countOfViews; i++) {
            UIViewController* vct = [self.dataSource viewPager:self indexOfViewControllers:i];
            if (vct && [vct isKindOfClass:[UIViewController class]]) {
                [self.viewControllerArray addObject:vct];
            }else{
                vct = [UIViewController new];
                vct.title = @"空viewController";
                [self.viewControllerArray addObject:vct];
            }
            NSString *title = vct.title;
            if (!title) {
                title = vct.params[@"title"];
            }
            if (!title) {
                title = @"";
            }
            [self.viewControllerTitleArray addObject:title];
        }
        [self.segmentedControl reloadData];
        if ([self.dataSource respondsToSelector:@selector(headerViewForInViewPager:)]) {
            [self.headerView removeFromSuperview];
            self.headerView = [self.dataSource headerViewForInViewPager:self];
            [self.headerContentView addSubview:self.headerView];
            [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.headerContentView);
            }];
        }
        if (self.viewControllerArray.count) {
            [self.mPageViewController setViewControllers:@[self.viewControllerArray.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self resetViewConstraints];
}

#pragma mark -- set get

- (UIPageViewController*)mPageViewController{
    if (!_mPageViewController) {
        _mPageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
//        _mPageViewController.dataSource=self;
//        _mPageViewController.delegate = self;
    }
    return _mPageViewController;
}

- (HMSegmentedControl*)segmentedControl{
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:self.viewControllerTitleArray];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionIndicatorColor = MasterDefaultColor;
        UIColor *color = MasterDefaultColor;
        _segmentedControl.selectedTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName,[UIFont systemFontOfSize:17.0f],NSFontAttributeName,nil];
        _segmentedControl.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:17.0f],NSFontAttributeName,nil];
        @weakify(self);
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
//            [weakSelf showViewControllerByIndex:index];
            @strongify(self);
            self.selectViewPageIndex = index;
        }];
    }
    return _segmentedControl;
}

- (NSMutableArray*)viewControllerArray{
    if (!_viewControllerArray) {
        _viewControllerArray = [NSMutableArray array];
    }
    return _viewControllerArray;
}

- (NSMutableArray*)viewControllerTitleArray{
    if (!_viewControllerTitleArray) {
        _viewControllerTitleArray = [NSMutableArray array];
    }
    return _viewControllerTitleArray;
}

- (void)showViewControllerByIndex:(NSInteger)index{
    [self.mPageViewController setViewControllers:@[self.viewControllerArray[index]] direction:index>self.selectViewPageIndex?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

#pragma mark --  UIPageViewControllerDataSource

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self.viewControllerArray indexOfObject:viewController];
    if (index==0 || index == NSNotFound) {
        return nil;
    }else{
        return self.viewControllerArray[--index];
    }
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self.viewControllerArray indexOfObject:viewController];
    if (index == self.viewControllerArray.count-1) {
        return nil;
    }
    else{
        return self.viewControllerArray[++index];
    }
}

#pragma mark -UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        if (self.selectViewPageIndex != [self.viewControllerArray indexOfObject:previousViewControllers[0]]) {
            [self.segmentedControl setSelectedSegmentIndex:self.selectViewPageIndex animated:YES];
            if ([self.delegate respondsToSelector:@selector(viewPagerViewController:didFinishScrollWithCurrentViewController:)]) {
                [self.delegate viewPagerViewController:self didFinishScrollWithCurrentViewController:[self.viewControllerArray objectAtIndex:self.selectViewPageIndex]];
            }
        }
        
    }
}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    _selectViewPageIndex = [self.viewControllerArray indexOfObject:pendingViewControllers[0]];
    if ([self.delegate respondsToSelector:@selector(viewPagerViewController:willScrollerWithCurrentViewController:)]) {
        [self.delegate viewPagerViewController:self willScrollerWithCurrentViewController:pageViewController.viewControllers[0]];
    }
}

- (void)dealloc
{
    NSLog(@"==========HJHPageViewController===========%@",self);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
