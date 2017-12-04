//
//  GoodsHomeViewController.m
//  MasterKA
//
//  Created by jinghao on 16/4/15.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "GoodsHomeViewController.h"
#import "ShareRootModel.h"
#import "LoopScrollView.h"
#import "GoodsHeadView.h"
#import "FSDDropdownPicker.h"
#import "FSDDropdownPickerView.h"
#import "LocationItem.h"
#import "GoodsSubListViewController.h"

#import "MasterTableHeaderView.h"
#import "MJRefresh.h"
#import "TableViewModel.h"
#import "CollectionViewModel.h"

@interface GoodsHomeViewController ()<ScrollPageViewControllerDelegate,ScrollPageViewControllerDataSource,FSDDropdownPickerViewDelegate,LoopScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) ShareRootModel *shareRootModel;
@property (nonatomic, strong) LoopScrollView *headView;

@property (nonatomic, strong) GoodsHeadView *goodsHeadView;

@property (nonatomic,strong)NSString* cityCode;//城市code
@property (nonatomic,strong)NSString* sortId;//兴趣分类ID
@property (nonatomic,strong)NSString* orderId;//排序ID
@property (nonatomic,strong)NSString* filterId;//筛选ID

@property (nonatomic,strong) FSDDropdownPickerView *titleView;

@property (nonatomic,strong) UIButton *shuaiXuanBtn;

@property (nonatomic,strong)  UIBarButtonItem *shuaiXuanItem;
@property (nonatomic,strong)  UIBarButtonItem *giftItem;

@property BOOL showTitle;//筛选ID

@end

@implementation GoodsHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    self.delegate = self;
    self.cityCode = self.userClient.city_code;
    [self.tabBarController.tabBar setHidden:YES];
    
    
    //    self.contentScrollView.delaysContentTouches = YES;
    //    self.contentScrollView.canCancelContentTouches = NO;
    
//    self.segmentedControl.titleTextAttributes =  @{
//                                                   NSFontAttributeName : [UIFont systemFontOfSize:13.0f],
//                                                   NSForegroundColorAttributeName : [UIColor colorWithHex:0x737373],
//                                                   };
//    self.segmentedControl.selectedTitleTextAttributes =  @{
//                                                           NSFontAttributeName : [UIFont systemFontOfSize:13.0f],
//                                                           NSForegroundColorAttributeName : [UIColor colorWithHex:0x737373],
//                                                           };
//    
//    self.segmentedControl.selectionIndicatorColor = [UIColor colorWithHex:0xa52040];
//    self.segmentedControl.selectionIndicatorHeight = 1.0f;
//    //    self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 15, 0, 15);
//    self.segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -6, 0);
    [self initRemoteData];
    
    UIButton * left_menu = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [left_menu setImage:nil forState:UIControlStateNormal];
    
    UIBarButtonItem*userHeadItem = [[UIBarButtonItem alloc] initWithCustomView:left_menu];
    [self.navigationItem setLeftBarButtonItem:userHeadItem animated:YES];
    
    
    
    
    UIButton *shoppingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shoppingBtn setImage:[UIImage imageNamed:@"selectOrder"] forState:UIControlStateNormal];
    [shoppingBtn addTarget:self action:@selector(selectOrderOnClick:) forControlEvents:UIControlEventTouchUpInside];
    shoppingBtn.frame= CGRectMake(0, 0, 35, 44);
    //    [shoppingBtn sizeToFit];
    shoppingBtn.contentEdgeInsets = UIEdgeInsetsMake(1, 5, -1, -5);
    UIBarButtonItem *shoppingItem = [[UIBarButtonItem alloc] initWithCustomView:shoppingBtn];
    
    UIButton *releaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [releaseBtn setImage:[UIImage imageNamed:@"liping"] forState:UIControlStateNormal];
    [releaseBtn addTarget:self action:@selector(giftOnClick:) forControlEvents:UIControlEventTouchUpInside];
    releaseBtn.frame= CGRectMake(0, 0, 35, 44);
    UIBarButtonItem *releaseItem = [[UIBarButtonItem alloc] initWithCustomView:releaseBtn];
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:releaseItem, nil];
    
    self.shuaiXuanItem = shoppingItem;
    self.giftItem = releaseItem;
    _shuaiXuanBtn = shoppingBtn;
    
    //    [self addTitleView];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseRootViewControllerNotification:) name:@"CourseRootViewControllerNotification" object:nil];
    //判断用户有没有切换过城市 ， 如果切换过 就重现加载数据
    if (![self.cityCode isEqualToString:self.userClient.city_code]) {
        
        self.cityCode =  self.userClient.city_code;
        
        [self initRemoteData];
    }
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    //[self.tabBarController.tabBar setHidden:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showTarBarVC" object:nil];
    [self showHelpImageView:@"bangzhushangcheng"];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.tabBarController.tabBar setHidden:YES];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CourseRootViewControllerNotification" object:nil];
//    if(self.titleView.isDropped){
//        [self.titleView hideDropdownAnimated:YES];
//    }
    
}

- (void)courseRootViewControllerNotification:(NSNotification *)x{
    if ([x.object isKindOfClass:[UIScrollView class]]) {
        [self performSelectorOnMainThread:@selector(scrollViewDidScroll:) withObject:x.object waitUntilDone:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --

- (void)initRemoteData{
    @weakify(self)
    RACSignal *racSignal =[[HttpManagerCenter sharedHttpManager] queryCourseIndex:[ShareRootModel class]];
    
    [racSignal subscribeNext:^(BaseModel *model) {
        @strongify(self)
        if (model.code==200) {
            self.shareRootModel = model.data;
        }else{
            
        }
    } completed:^{
        
    }];
}

- (void)setShareRootModel:(ShareRootModel *)shareRootModel
{
    _shareRootModel = shareRootModel;
    [self initHeadViewData];
}
//- (LoopScrollView*)headView{
//    if (!_headView) {
//        _headView = [[LoopScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 206)];
//        //        _headView = self.goodsHeadView.imgLoopView;
//    }
//    return _headView;
//}

//- (GoodsHeadView*)goodsHeadView{
//    if (!_goodsHeadView) {
//        _goodsHeadView = [GoodsHeadView loadInstanceFromNib];
//        _goodsHeadView.imgLoopView.delegate = self;
//        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushSearchVC:)];
//        [_goodsHeadView.searchBtn addGestureRecognizer:singleTap];
//        
//        UITapGestureRecognizer *singleTap2 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyOnClick:)];
//        [_goodsHeadView.companyBtn addGestureRecognizer:singleTap2];
//        
//    }
//    return _goodsHeadView;
//}

- (void)initHeadViewData{
    [self.viewControllers removeAllObjects];
    @weakify(self);
    
    for (CategoryModel *model in self.shareRootModel.category_list) {
        
        GoodsSubListViewController *vct = (GoodsSubListViewController*)[UIViewController viewControllerWithStoryboard:@"Goods" identifier:@"GoodsSubListViewController"];
        vct.params = @{@"title":model.name,@"categoryId":model.categoryId};
        vct.title = model.name;
        vct.shuaiXuanBtn = self.shuaiXuanBtn;
        [self.viewControllers addObject:vct];
        [((TableViewModel*)vct.viewModel).requestRemoteDataCommand.executing subscribeNext:^(NSNumber *x) {
            @strongify(self);
            if(!x.boolValue){
                [self.contentScrollView.mj_header endRefreshing];
                NSLog(@"==============contentScrollView.mj_header============");
            }
        }];
    }
    NSMutableArray *banerUrlArray = [NSMutableArray new];
    for (MasterShareBannerModel *model in self.shareRootModel.banner_list) {
        [banerUrlArray addObject:model.pic_url];
    }
    if (self.viewControllers.count>0) {
        [self reload];
        self.contentScrollView.mj_header = [MasterTableHeaderView headerWithRefreshingBlock:^{
            @strongify(self);
            CategoryModel *model = self.shareRootModel.category_list[self.selectViewPageIndex];
            GoodsSubListViewController *vct = self.viewControllers[self.selectViewPageIndex];
            [vct setValue:model.categoryId forKey:@"categoryId"];
        } ];
    }
}

- (NSMutableArray*)viewControllers
{
    if (!_viewControllers) {
        _viewControllers = [NSMutableArray array];
    }
    return _viewControllers;
}

//#pragma mark -- HJHPageViewControllerDataSource,HJHPageViewControllerDelegate
//
//- (NSInteger)numberOfViewControllersInViewPager:(ScrollPageViewController *)viewPager
//{
//    return self.viewControllers.count;
//}
//
//- (UIViewController *)viewPager:(ScrollPageViewController *)viewPager indexOfViewControllers:(NSInteger)index
//{
//    return self.viewControllers[index];
//}
//
//-(CGFloat)heightForTitleOfViewPager:(ScrollPageViewController *)viewPager
//{
//    return 40.0f;
//}
//
//- (CGFloat)heightForHeaderOfViewPager:(ScrollPageViewController *)viewPager
//{
//    return 43;
////    return 206;
//}
//
//- (UIView*)headerViewForInViewPager:(ScrollPageViewController *)viewPager
//{
////    return self.headView;
//    return self.goodsHeadView;
//}


#pragma mark -- FSDDropdownPickerDelegate

//- (BOOL)dropdownPickerView:(FSDDropdownPickerView *)dropdownPicker didSelectOption:(id <FSDPickerItemProtocol> )option
//{
//    LocationItem *item = (LocationItem *)option;
//    self.cityCode = self.userClient.city_code = item.data[@"city_code"];
//    [self initRemoteData];
//    return TRUE;
//}
//
//- (void)dropdownPickerView:(FSDDropdownPickerView *)dropdownPicker didDropDown:(BOOL)drop
//{
//    //    [self.masterDropDownMenu dismiss];
//    //
//    //    if (drop) {
//    //        self.navigationItem.title = @"选择城市";
//    //        self.navigationItem.titleView = nil;
//    //        self.navigationItem.rightBarButtonItem = nil;
//    //    }else{
//    //        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:messageButton];
//    //        self.navigationItem.title =nil;
//    //        self.navigationItem.titleView = searchBar;
//    //
//    //    }
//}


//
//- (IBAction)pushSearchVC:(id)sender {
//    
//    UIViewController *vct = [UIStoryboard viewController:@"MasterShare" identifier:@"MasterShareSearchViewController"];
//    [self pushViewController:vct animated:YES];
//    
//}
//
//- (IBAction)giftOnClick:(id)sender {
//    
//    NSString *path = [UserClient sharedUserClient].activity_url ;
//    [self pushViewControllerWithUrl:path ];
//    
//}
//
//- (IBAction)selectOrderOnClick:(id)sender {
//    
//    [self.viewControllers[self.selectViewPageIndex] performSelector:@selector(clickSelectOrder:) withObject:nil];
//}
//
//- (IBAction)companyOnClick:(id)sender {
//    
//    NSString *path = [UserClient sharedUserClient].enterprise_course_url ;
//    [self pushViewControllerWithUrl:path ];
//}
//
//- (IBAction)selectCity:(id)sender {
//    
//}
//
//-(void)updateNavTitle:(BOOL)status{
//    if(status != self.showTitle){
//        if(status){
//            self.searchTitleView.delegate = self;
//            self.navigationItem.titleView = self.searchTitleView;
//            
//        }else{
//            self.navigationItem.titleView = self.titleView;
//            
//        }
//        self.showTitle = status;
//    }
//}
//
//-(void)viewPagerViewController:(ScrollPageViewController *)viewPager didFinishScrollWithCurrentViewController:(GoodsSubListViewController *)ViewController{
//    NSString* categoryId = ViewController.params[@"categoryId"];
//    int orderId = [ViewController.params[@"orderId"] intValue];
//    int selectId = [ViewController.params[@"selectId"] intValue];
//    if(categoryId && [categoryId isEqualToString:@"-1"]){
//        [self.titleView setPaddingLeft:10.5f];
//        self.navigationItem.rightBarButtonItems = @[self.giftItem];
//        
//    }else{
//        
//        if(orderId  || selectId ){
//            [_shuaiXuanBtn setImage:[UIImage imageNamed:@"selectOrder-yes"] forState:UIControlStateNormal];
//        }else{
//            [_shuaiXuanBtn setImage:[UIImage imageNamed:@"selectOrder"] forState:UIControlStateNormal];
//        }
//        [self.titleView setPaddingLeft:32.0f];
//        UIBarButtonItem *shoppingItem = [[UIBarButtonItem alloc] initWithCustomView:_shuaiXuanBtn];
//        self.navigationItem.rightBarButtonItems = @[self.giftItem,shoppingItem];
//        
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"showTarBarVC" object:nil];
//}

//#pragma mark -- UITextFieldDelegate
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    UIViewController *vct = [UIStoryboard viewController:@"MasterShare" identifier:@"MasterShareSearchViewController"];
//
//    [self pushViewController:vct animated:YES];
//    return NO;
//}


//- (void)circleView:(LoopScrollView *)view didSelectedIndex:(NSInteger)index
//{
//    MasterShareBannerModel *model = self.shareRootModel.banner_list[index];
//    if ([model.is_login integerValue]==1 && !self.userClient.rawLogin) {
//        [self doLogin];
//    }else{
//        [self pushViewControllerWithUrl:model.pfurl];
//    }
//}
//
//- (void)circleView:(LoopScrollView *)view didScrollToIndex:(NSInteger)index
//{
//    
//}



@end
