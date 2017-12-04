//
//  ScrollPageViewController.m
//  MasterKA
//
//  Created by jinghao on 16/4/21.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "ScrollPageViewController.h"
#import "GuessLikeCollectionCell.h"


@interface PageScrollView : UIScrollView

@end

@implementation PageScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}



@end

typedef enum :NSInteger {
    
    kCameraMoveDirectionNone,
    
    kCameraMoveDirectionUp,
    
    kCameraMoveDirectionDown,
    
    kCameraMoveDirectionRight,
    
    kCameraMoveDirectionLeft
    
} CameraMoveDirection;
CameraMoveDirection direction;

@interface ScrollPageViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIScrollViewDelegate>
{
    NSInteger countOfViews;
    
    CGFloat NavigationBarHeight;
    CGFloat TabbarBottomHeight ;
    /** 滚动标题的高度  */
    CGFloat kTitleVewHeight;
    /** 滚动标题每个item的宽度  */
    CGFloat kTitleViewItemWidth ;
    /** 焦点按钮与下面的距离  */
    CGFloat kHotViewMargin ;

}
@property (nonatomic,strong)UIPageViewController* mPageViewController;
@property (nonatomic,strong)HMSegmentedControl *segmentedControl;
@property (nonatomic,strong)NSMutableArray* viewControllerArray;
@property (nonatomic,strong)NSMutableArray* viewControllerTitleArray;
@property (nonatomic,strong)UIView *headerView;     //头部视图
@property (nonatomic,strong)UIView *headerContentView;     //头部视图
@property (nonatomic,strong,readwrite)PageScrollView *contentScrollView;
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UIView *mainView;

@property (nonatomic, assign) BOOL canScrollViewScroll;

@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;

@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;

@property (nonatomic, assign) BOOL canTableViewScroll;
/** navigationBar的alpha值 */
@property (nonatomic, assign) CGFloat navigationBarAlpha;

@property (nonatomic, assign) CGFloat headViewHeight;



@end

@implementation ScrollPageViewController
@synthesize selectViewPageIndex = _selectViewPageIndex;


CGFloat const gestureMinimumTranslation = 20.0;




- (void)viewDidLoad {
    [super viewDidLoad];
    
     NavigationBarHeight = 64;
     TabbarBottomHeight = 49;
    /** 滚动标题的高度  */
     kTitleVewHeight = 40;
    /** 滚动标题每个item的宽度  */
     kTitleViewItemWidth = 64;
    /** 焦点按钮与下面的距离  */
     kHotViewMargin = 10;
    
    [self addChildViewController:self.mPageViewController];
    [self buildMainScrollView];
     [self.mPageViewController didMoveToParentViewController:self];
    
//    self.view.gestureRecognizers = self.segmentedControl.gestureRecognizers = self.contentScrollView.gestureRecognizers = self.mPageViewController.gestureRecognizers ;
//    self.view.gestureRecognizers = self.mPageViewController.gestureRecognizers ;
//    for (UIGestureRecognizer* recognizer in self.mPageViewController.gestureRecognizers) {
////        recognizer.delegate = self;
//        recognizer.cancelsTouchesInView = NO;
//        if([recognizer isKindOfClass:[UIPanGestureRecognizer class]]){
//            recognizer.enabled = NO;
//            [recognizer addTarget:self action:@selector(handleSwipe:)];
//        }
//    }
    
//    self.canScrollViewScroll = YES;
//    self.canTableViewScroll = NO;
//    
//    self.canTableViewScroll =YES;
//    self.canScrollViewScroll = NO;

    
//    _isTopIsCanNotMoveTabViewPre =YES;
//    [self.view addSubview:self.contentScrollView];
//    [self.contentScrollView addSubview:self.mPageViewController.view];
//    [self.contentScrollView addSubview:self.segmentedControl];
}


//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//   
//    NSLog(@"============%d",gestureRecognizer.state);
//    if([touch.view.superview isKindOfClass:[GuessLikeCollectionCell class]]){
//        return NO;
//    }
//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
////        [self handleSwipe:gestureRecognizer];
//        
//            if(self.selectViewPageIndex == 0 && direction == kCameraMoveDirectionLeft){
//            return NO;
//        }
//    }
//    
//    
//    
//    return YES;
//}
//
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    NSLog(@"============%d",gestureRecognizer.state);
//    return YES;
//}

//
//#pragma mark resolve UITableView and UIPageViewController panGesture Conflict
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    NSLog(@"============%@============/n%@",gestureRecognizer,otherGestureRecognizer);
//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//        return NO;
//    }
//    return NO;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
//    [self changeSubviewFrame];
}

- (void)changeSubviewFrame{
    
    float startY = 0;
    self.contentScrollView.frame = self.view.bounds;
    
    self.headerContentView.frame = CGRectMake(0, startY, self.contentScrollView.width, 160);
    
    startY += self.headerContentView.height;
    
    self.segmentedControl.frame = CGRectMake(0, startY, self.contentScrollView.width, kTitleVewHeight);
    
    startY += self.segmentedControl.height;

    self.mPageViewController.view.frame = CGRectMake(0, startY, self.contentScrollView.width, self.contentScrollView.height-self.segmentedControl.height);

    startY += self.mPageViewController.view.height;
    
    self.contentView.frame = CGRectMake(0, 0, self.contentScrollView.width, startY);
    
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width, startY);
    

//    self.contentScrollView.frame = CGRectMake(0, self.topLayoutGuide.length, self.view.frame.size.width,self.view.height-self.topLayoutGuide.length);
//    float y = 0;
//    if (_headerView) {
//        _headerView.frame = CGRectMake(0, y,self.contentScrollView.width,[self.dataSource respondsToSelector:@selector(heightForHeaderOfViewPager:)]?[self.dataSource heightForHeaderOfViewPager:self]:0);
//        y += _headerView.height;
//    }
//    self.segmentedControl.frame = CGRectMake(0,y, self.contentScrollView.width,[self.dataSource respondsToSelector:@selector(heightForTitleOfViewPager:)]?[self.dataSource heightForTitleOfViewPager:self]:0);
//    y += self.segmentedControl.height;
//    self.mPageViewController.view.frame = CGRectMake(0, y, self.contentScrollView.width, self.contentScrollView.height-self.segmentedControl.height);
//    y +=self.mPageViewController.view.height;
//    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width,y-self.segmentedControl.height);
}

- (void)buildMainScrollView{
    
    [self.view addSubview:self.contentScrollView];
    
    self.contentView = [[UIView alloc]init];
    

    [self.contentScrollView addSubview:self.contentView];
    
    [self.contentView addSubview:self.headerContentView];

    [self.contentView addSubview:self.segmentedControl];
    
    [self.contentView addSubview:self.mPageViewController.view];
    
}

- (void)resetViewConstraints{
    float titleViewHeight = [self.dataSource respondsToSelector:@selector(heightForTitleOfViewPager:)]?[self.dataSource heightForTitleOfViewPager:self]:0;
    kTitleVewHeight = titleViewHeight;
    self.headViewHeight = [self.dataSource respondsToSelector:@selector(heightForHeaderOfViewPager:)]?[self.dataSource heightForHeaderOfViewPager:self]:0;
    
    TabbarBottomHeight = 0.0f ;
    if (self.tabBarController) {
        TabbarBottomHeight = self.tabBarController.tabBar.hidden?0.0f:self.tabBarController.tabBar.height;
    }
    
    NavigationBarHeight = 20.0f ;
    if (self.navigationController) {
        NavigationBarHeight += self.navigationController.navigationBar.hidden?0.0f:self.navigationController.navigationBar.height;
    }
    
    [self.contentScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentScrollView);
        make.width.equalTo(self.contentScrollView);
    }];
    
    [self.headerContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.height.mas_equalTo(@(self.headViewHeight));
    }];
    
    
    [self.segmentedControl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.contentView);
        make.top.mas_equalTo(self.headerContentView.mas_bottom);
        make.height.mas_equalTo(@(titleViewHeight));
    }];
    
    
    [self.mPageViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.mas_equalTo(self.segmentedControl.mas_bottom);
        if (self.tabBarController.tabBar.hidden) {
//            make.bottom.equalTo(self.view);
             make.height.mas_equalTo(self.view.height - titleViewHeight);
        }else{
//            make.bottom.equalTo(self.view).with.offset(-self.tabBarController.tabBar.height);
             make.height.mas_equalTo(self.view.height - titleViewHeight - self.tabBarController.tabBar.height);
        }
    }];
    
//    [self.mPageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.equalTo(self.contentView);
//        make.top.mas_equalTo(self.segmentedControl.mas_bottom);
//        make.height.mas_equalTo(ScreenHeight - titleViewHeight - TabbarBottomHeight);
//    }];

    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mPageViewController.view.mas_bottom);
    }];
    
    
}

#pragma mark -- public


- (void)setDataSource:(id<ScrollPageViewControllerDataSource>)dataSource
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

- (void)showViewControllerByIndex:(NSInteger)index{
    
    
//    UIViewController *vct =self.viewControllerArray[index];
//    [self.mPageViewController setViewControllers:@[vct] direction:index>self.selectViewPageIndex?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
//        if (weakSelf.delegate && [self.delegate respondsToSelector:@selector(viewPagerViewController:didFinishScrollWithCurrentViewController:)]) {
//            [self.delegate viewPagerViewController:weakSelf didFinishScrollWithCurrentViewController:vct];
//        }
//    }];

    @weakify(self);
    UIViewController *vct =self.viewControllerArray[index];
    [self.mPageViewController setViewControllers:@[vct] direction:index>self.selectViewPageIndex?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewPagerViewController:didFinishScrollWithCurrentViewController:)]) {
            [self.delegate viewPagerViewController:self didFinishScrollWithCurrentViewController:vct];
        }
    }];

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
            if (vct.title) {
                [self.viewControllerTitleArray addObject:vct.title];
            }else{
                [self.viewControllerTitleArray addObject:@""];
            }
        }
        self.segmentedControl.sectionTitles = self.viewControllerTitleArray;
        if ([self.dataSource respondsToSelector:@selector(headerViewForInViewPager:)]) {
            [self.headerView removeFromSuperview];
            self.headerView = [self.dataSource headerViewForInViewPager:self];
            [self.headerContentView addSubview:self.headerView];
            [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.headerContentView);
            }];
        }
        [self resetViewConstraints];
        if (self.viewControllerArray.count>0) {
//            self.mPageViewController.dataSource=self;
//            self.mPageViewController.delegate = self;
            self.segmentedControl.selectedSegmentIndex = 0 ;
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

- (UIView*)headerContentView{
    if (!_headerContentView) {
        _headerContentView = [[UIView alloc] init];
    }
    return _headerContentView;
}

- (UIScrollView*)contentScrollView
{
    if (!_contentScrollView) {
        _contentScrollView = [[PageScrollView alloc] init];
        _contentScrollView.scrollsToTop = NO;
        _contentScrollView.delegate= self;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _contentScrollView;
}

- (UIPageViewController*)mPageViewController{
    if (!_mPageViewController) {
        _mPageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
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
//        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
//            @strongify(self);
//            UIViewController *vct =self.viewControllerArray[index];
//            [self.mPageViewController setViewControllers:@[vct] direction:index>_selectViewPageIndex?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
//                _selectViewPageIndex = index;
//                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(viewPagerViewController:didFinishScrollWithCurrentViewController:)]) {
//                    [weakSelf.delegate viewPagerViewController:weakSelf didFinishScrollWithCurrentViewController:vct];
//                }
//            }];
//        }];
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

#pragma mark --  UIPageViewControllerDataSource

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if(viewController){
        NSInteger index = [self.viewControllerArray indexOfObject:viewController];
        if (index==0) {
            return nil;
        }else{
            return self.viewControllerArray[--index];
        }
    }else{
        return nil;
    }
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (self.viewControllerArray.count==0) {
        return nil;
    }
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
    if (self.viewControllerArray.count==0) {
        return ;
    }
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
    if (self.viewControllerArray.count==0) {
        return ;
    }
    _selectViewPageIndex = [self.viewControllerArray indexOfObject:pendingViewControllers[0]];
    if ([self.delegate respondsToSelector:@selector(viewPagerViewController:willScrollerWithCurrentViewController:)]) {
        [self.delegate viewPagerViewController:self willScrollerWithCurrentViewController:pageViewController.viewControllers[0]];
    }
}


#pragma mark --


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        self.contentScrollView.scrollEnabled = NO;
    }
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        if (!self.canTableViewScroll) {
            [scrollView setContentOffset:CGPointZero];
        }
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY<=0) {
            self.canScrollViewScroll = YES;
            [scrollView setContentOffset:CGPointZero];
            self.canTableViewScroll = NO;
        }
    }
    if ([scrollView isEqual:self.contentScrollView]) {
        self.navigationBarAlpha = scrollView.contentOffset.y /(self.headerContentView.frame.size.height - NavigationBarHeight - kTitleVewHeight);
//        [self.navigationController.navigationBar zz_setBackgroundColor:[[UIColor getColor:CustomBarTintColor] colorWithAlphaComponent:self.navigationBarAlpha]];
//        [self.navigationController.navigationBar zz_setElementAlpha:self.navigationBarAlpha];
//
        if(self.canScrollViewScroll){
            if(scrollView.contentOffset.y<40){
                [self updateNavTitle:NO];
            }else{
                [self updateNavTitle:YES];
            }
        }
        CGFloat tabOffsetY = self.headViewHeight;
        CGFloat offsetY = scrollView.contentOffset.y;
        _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
        if (offsetY>=tabOffsetY) {
            scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            _isTopIsCanNotMoveTabView = YES;
        }else{
            _isTopIsCanNotMoveTabView = NO;
        }
        if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
            if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
                self.canTableViewScroll =YES;
                self.canScrollViewScroll = NO;
            }
            if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
                
                if (!self.canScrollViewScroll) {
                    scrollView.contentOffset = CGPointMake(0, tabOffsetY);
                }
            }
        }
    }
    self.contentScrollView.scrollEnabled= YES;
    
//    [self updateNavTitle:NO];
}


-(void)updateNavTitle:(BOOL)status{
    
}


- (void)dealloc
{
    NSLog(@"=======ScrollPageViewController=====%@",self);
}


- (void)handleSwipe:(UIPanGestureRecognizer *)gesture

{
//    gesture.enabled = NO;
    
    NSLog(@"============%d",gesture.state);
    CGPoint translation = [gesture translationInView:self.view];
    
    if (gesture.state ==UIGestureRecognizerStateBegan)
        
    {
        
        direction = kCameraMoveDirectionNone;
        
    }
    
    else if (gesture.state == UIGestureRecognizerStateChanged && direction == kCameraMoveDirectionNone)
        
    {
        
        direction = [self determineCameraDirectionIfNeeded:translation];
        
        
        // ok, now initiate movement in the direction indicated by the user's gesture
        
        switch (direction) {
                
            case kCameraMoveDirectionDown:
                
                NSLog(@"Start moving down");
                
                break;
                
            case kCameraMoveDirectionUp:
                
                NSLog(@"Start moving up");
                
                break;
                
            case kCameraMoveDirectionRight:
                
                NSLog(@"Start moving right");
                
                break;
                
            case kCameraMoveDirectionLeft:
                
                NSLog(@"Start moving left");
                
                break;
                
            default:
                
                break;
                
        }
        
    }else if (gesture.state == UIGestureRecognizerStateEnded)
    
    {
        
        // now tell the camera to stop
        
        NSLog(@"Stop");
        
    }
    
}


// This method will determine whether the direction of the user's swipe

- (CameraMoveDirection)determineCameraDirectionIfNeeded:(CGPoint)translation

{
    
    if (direction != kCameraMoveDirectionNone)
        return direction;
    // determine if horizontal swipe only if you meet some minimum velocity
    if (fabs(translation.x) > gestureMinimumTranslation)
        
    {
        
        BOOL gestureHorizontal = NO;
        if (translation.y ==0.0)
            gestureHorizontal = YES;
        else
            gestureHorizontal = (fabs(translation.x / translation.y) >5.0);
        if (gestureHorizontal)
            
        {
            if (translation.x >0.0)
                return kCameraMoveDirectionRight;
            else
                return kCameraMoveDirectionLeft;
        }
        
    }
    
    // determine if vertical swipe only if you meet some minimum velocity
    
    else if (fabs(translation.y) > gestureMinimumTranslation)
        
    {
        BOOL gestureVertical = NO;
        if (translation.x ==0.0)
             gestureVertical = YES;
        else
            gestureVertical = (fabs(translation.y / translation.x) >5.0);
        if (gestureVertical)
         {
            if (translation.y >0.0)
                return kCameraMoveDirectionDown;
            else
                return kCameraMoveDirectionUp;
        }
    }
    return direction;
    
}




//// called on start of dragging (may require some time and or distance to move)
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    NSLog(@"1");
//}
//// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0){
//     NSLog(@"2");
//}
//// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//     NSLog(@"3");
//}
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//     NSLog(@"4");
//}// called on finger up as we are moving
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSLog(@"5");
//}
//    // called when scroll view grinds to a halt
//
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    NSLog(@"6");
//} // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
//
//
//- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view NS_AVAILABLE_IOS(3_2){
//     NSLog(@"7");
//} // called before the scroll view begins zooming its content
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
//    NSLog(@"8");
//} // scale between minimum and maximum. called after any 'bounce' animations
//
//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
//    NSLog(@"9");
//}



@end
