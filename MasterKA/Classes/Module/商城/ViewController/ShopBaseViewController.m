//
//  ShopBaseViewController.m
//  MasterKA
//
//  Created by 余伟 on 16/8/15.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#define RANDOMCOLOR   [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
#define selfViewWidth self.view.size.width/2
#define selfViewHight self.view.size.height/2

#define btnW  ([UIScreen mainScreen].bounds.size.width-MARGIN)*0.5
#define btnH    69
#define MARGIN  2
#define counts 2
#import "ShopBaseViewController.h"
#import "CategoryView.h"
#import "MajorViewController.h"
#import "Masonry.h"
#import "CourseViewController.h"
#import "MasterCategoryModel.h"
#import "ShopAllViewController.h"
#import "LeftTitleBtn.h"
#import "FilterView.h"
#import "SequenceView.h"
#import "MapCourseController.h"
#import "BaseNavigationController.h"


#import "ShopAllTable.h"
#import "CourseListModel.h"
#import "MasterTableHeaderView.h"
#import "MasterTableFooterView.h"
#import "ImageTopBtn.h"


@interface ShopBaseViewController ()<UIPageViewControllerDelegate , UIPageViewControllerDataSource,UITextViewDelegate>
@property (nonatomic,strong)NSString *orderId;
@property (nonatomic,strong)NSString *selectId;

@property(nonatomic , assign)NSInteger curPage;

@property(nonatomic ,copy)NSString * pageSize;
@end

@implementation ShopBaseViewController
{
    CategoryView * _shopView ;
    NSString * _city;
    NSArray * category_list;
    NSArray * _controllerArr;
    UIPageViewController * _pageViewVC;
    MajorViewController *_majorVC;
    NSString * _categoryId;
    CourseViewController * _currentCourseVc;
    NSInteger orderIndex;
    BaseViewController * _currentVc;
    UIImageView *_adImageView;
    
//    ShopAllViewController * _allVc;
    
    NSArray * _allCategor;
    UIView* _filterView;
    FilterView * _bgView;
    SequenceView * _sequenceView;
    
    UIView* notifyView;
    UIView* blackgroudView1;
    UIView* blackgroudView2;
    UIView* blackgroudView3;
    UIView* blackgroudView4;
    UIButton* queryBtn;
    BOOL isZhuanTiItem;
    
    ShopAllTable * _allTable;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.orderId = @"";
    
    self.selectId = @"";
    
    self.index = 0;
    
    isZhuanTiItem = YES;
    
    [self.tabBarController.tabBar setHidden:NO];
    
    [self navigationBarButtonConfiguration];
    
    [self  buildUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshShopView) name:@"refreshShopView" object:nil];
    
    self.orderID = nil;
    self.selectID = nil;
    self.curPage = 1;
    self.categoryId = @"0";
    
    self.pageSize = @"10";
    
    NSInteger height = IsPhoneX?(88+34+49):(64+49);
    
    _allTable = [[ShopAllTable alloc]initWithFrame:CGRectMake(0, 50, self.view.width, ScreenHeight-height-50)];
   
    [self.view addSubview:_allTable];
    
    _allTable.mj_header = [MasterTableHeaderView addRefreshGifHeadViewWithRefreshBlock:^{
        
        [self first];
        
    }];
    
    _allTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self requestRemoteDataSignalWithPage:self.curPage +=1 withCategoryId:self.categoryId withOrder_type:self.orderID  withSelect_type:nil andPage_size:self.pageSize];
        
    }];

     [self first];

    
    _allTable.estimatedRowHeight = 0;
    _allTable.estimatedSectionFooterHeight = 0;
    _allTable.estimatedSectionHeaderHeight = 0;
    
    [_allTable setSeparatorColor:[UIColor clearColor]];
    self.delegate = _shopView;
    
    _city =  [UserClient sharedUserClient].city_name;
    
    [self initRemoteData];
    
}


-(UIView*)creatSectionHeadView
{
    
    UIView * sectionHeadView = [[UIView alloc]init];
    
    NSArray *itArr =  _allTable.itemModel;
        if (itArr.count == 3) {
            
            sectionHeadView.frame = CGRectMake(0, 0, ScreenWidth, btnH+2*MARGIN);
        }else{
    
            
            sectionHeadView.frame = CGRectMake(0, 0, ScreenWidth, btnH*counts+3*MARGIN);
        }
    
//        sectionHeadView.backgroundColor = [UIColor redColor];
    
    for (int i = 0; i<itArr.count; i++) {
        
        ImageTopBtn * btn = [ImageTopBtn buttonWithType:UIButtonTypeCustom];
        if (itArr.count == 3) {
            
            btn.frame = CGRectMake(i%itArr.count*(([UIScreen mainScreen].bounds.size.width-2*MARGIN)/3+MARGIN), i/itArr.count*(+MARGIN)+MARGIN, ([UIScreen mainScreen].bounds.size.width-2*MARGIN)/3 , btnH);
        }else{
            
            btn.frame = CGRectMake(i%counts*(btnW+MARGIN), i/counts*(btnH+MARGIN)+MARGIN, btnW , btnH);
        }
        
        
        
        SDWebImageManager * manger = [SDWebImageManager sharedManager];
        
        if (_allTable.itemModel.count != 0) {
            
            ItemCourseModel * item = _allTable.itemModel[i];
            
            btn.pfurl = item.pfurl;
 
            
            [btn setImageUrlForState:UIControlStateNormal withUrl:item.pic_url placeholderImage:nil];
            
            
            [btn setTitle:[NSString stringWithFormat:@"%@" ,item.name] forState:UIControlStateNormal];
            
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            
            btn.adjustsImageWhenHighlighted = NO;
            
            btn.backgroundColor = [UIColor whiteColor];
            
            [btn addTarget: self action:@selector(pushH5:) forControlEvents:UIControlEventTouchUpInside];
            
            [sectionHeadView addSubview:btn];
            
        }
    }
    
    return sectionHeadView;
    
}


-(void)pushH5:(ShopTopImageBtn *)sender
{
    
//    self.jumpH5(sender.pfurl);
    [self pushViewControllerWithUrl:sender.pfurl];
}


-(void)ischangeRefreshData
{
    _allTable.ischange = YES;
    
    [self requestRemoteDataSignalWithPage:self.curPage withCategoryId:self.categoryId withOrder_type:nil withSelect_type:nil andPage_size:self.pageSize];
    
    [_allTable reloadData];
}


- (void)requestRemoteDataSignalWithPage:(NSUInteger)page withCategoryId:(NSString *)categoryId withOrder_type:(NSString*)order_type withSelect_type:(NSString*)select_type andPage_size:(NSString*)pageSize
{
    
    self.categoryId = categoryId;
    
    self.orderID = order_type;
    
    RACSignal *fetchSignal = [[HttpManagerCenter sharedHttpManager] getCategoryList:categoryId order_type:order_type select_type:select_type page:[NSString stringWithFormat:@"%lu",(unsigned long)page] page_size:pageSize resultClass:[CourseListModel class]];
    
    @weakify(self)
    [fetchSignal subscribeNext:^(BaseModel *model) {
        @strongify(self)
        if (model.code==200) {
            
            
            NSLog(@"%@", select_type);
            
            CourseListModel * course = model.data;
            
            _allTable.itemModel = course.item_list;
             _allTable.tableHeaderView = [self creatSectionHeadView];
            
            _allTable.model = (NSMutableArray *)course.course_list;
            
            if (course.course_list.count == 0) {
                
                
                [self showHUDWithString:@"没有更多数据"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self hiddenHUD];
                    
                });
                
            }
            [_allTable reloadData];
            
        }else{
            
        }
    } completed:^{
        
        [self hiddenHUD];
        
        if(_allTable.mj_footer.isRefreshing){
            
            [_allTable.mj_footer endRefreshing];
            
        }
        
        if(_allTable.mj_header.isRefreshing){
            
            [_allTable.mj_header endRefreshing];
        }
        
        
        
    }];
    
    
    
}


- (void)first
{
    [_allTable.itemModel removeAllObjects];
    
    [_allTable.model removeAllObjects];
    
    self.curPage = 1;
    
     [self showHUDWithString:@"数据加载中..."];
    
    [self requestRemoteDataSignalWithPage:self.curPage withCategoryId:self.categoryId withOrder_type:self.orderID withSelect_type:self.selectID andPage_size:self.pageSize];
    
    
}
- (void)refreshShopView {
    [_allTable.mj_header beginRefreshing];
    
    self.curPage = 1;
    
    [self requestRemoteDataSignalWithPage:self.curPage withCategoryId:self.categoryId withOrder_type:self.orderID withSelect_type:self.selectID andPage_size:self.pageSize];
}
#pragma mark ——— private methods

- (void)navigationBarButtonConfiguration {
    
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [searchBtn setImage:[UIImage imageNamed:@"放大镜"] forState:UIControlStateNormal];
    
    searchBtn.size = CGSizeMake(35, 44);
    
    [searchBtn addTarget: self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * searchItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    
    self.navigationItem.leftBarButtonItem = searchItem;
    
    self.fetchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fetchBtn.size = CGSizeMake(35,44);
    self.fetchBtn.backgroundColor = [UIColor clearColor];
    [self.fetchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.fetchBtn.titleLabel.font= [UIFont systemFontOfSize:15];
    [self.fetchBtn addTarget:self action:@selector(map:) forControlEvents:UIControlEventTouchUpInside];
    [self.fetchBtn setImage:[UIImage imageNamed:@"地图-"] forState:UIControlStateNormal];
    UIBarButtonItem *fetchItem = [[UIBarButtonItem alloc] initWithCustomView:self.fetchBtn];

    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:fetchItem,nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![_city isEqualToString:[UserClient sharedUserClient].city_name]) {
        self.orderId = @"";
        self.selectId = @"";
        
        _shopView.isChange = YES;
        
        _city = [UserClient sharedUserClient].city_name;

        [self initRemoteData];
        [self ischangeRefreshData];
        
    }
    
    [self.tabBarController.tabBar setHidden:NO];}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tabBarController.tabBar setHidden:NO];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.tabBarController.tabBar setHidden:YES];
    
}

- (void)buildUI {

    LeftTitleBtn * categoryBtn = [[LeftTitleBtn alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 50)];
    [categoryBtn addTarget: self action:@selector(category:) forControlEvents:UIControlEventTouchUpInside];
    [categoryBtn setTitle:@"分类" forState:UIControlStateNormal];
    categoryBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [categoryBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [categoryBtn setImage:[UIImage imageNamed:@"jiantouxia1"] forState:UIControlStateNormal];
    
    LeftTitleBtn * sequenceBtn =  [[LeftTitleBtn alloc]initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 50)];
    [sequenceBtn setTitle:@"排序" forState:UIControlStateNormal];
    sequenceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sequenceBtn addTarget: self action:@selector(sequence:) forControlEvents:UIControlEventTouchUpInside];
    [sequenceBtn setImage:[UIImage imageNamed:@"jiantouxia1"] forState:UIControlStateNormal];
    [sequenceBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    _filterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    _filterView.backgroundColor = [UIColor whiteColor];
    
    [_filterView addSubview:categoryBtn];
    [_filterView addSubview:sequenceBtn];
    
    [self.view addSubview:_filterView];
   
//    _allVc = [[ShopAllViewController alloc]init];
//
//    [self addChildViewController:_allVc];
//
//
//    [self.view addSubview:_allVc.view];
//
//    [_allVc didMoveToParentViewController:self];
//
//    [self layoutUI];
}

//- (void)layoutUI {
//
//    [_allVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.mas_equalTo(50);
//
//        make.left.mas_equalTo(self.view.mas_left);
//
//        make.right.mas_equalTo(self.view.mas_right);
//
//        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-100);
//    }];
//}


//取消企业课广告
-(void)cancelClick:(UIButton *)sender
{
    
    [_adImageView removeFromSuperview];
    
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _shopView.transform = CGAffineTransformIdentity;
        
        _pageViewVC.view.transform = CGAffineTransformIdentity;
        
        
        
    }completion:^(BOOL finished) {
        
        
        
    }];
    
    //    CGRect main = _mainCollection.frame;
    //
    //    main.size.height += 40;
    //
    //    _mainCollection.frame = main;
    //
    
    //    _mainCollection.frame = CGRectMake(0, 40, self.view.bounds.size.width, _mainCollection.bounds.size.height+40);
    
}

//企业课
-(void)companyClick:(UIBarButtonItem *)item {
    
    [_adImageView removeFromSuperview];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _shopView.transform = CGAffineTransformIdentity;
        
        _pageViewVC.view.transform = CGAffineTransformIdentity;
        
    }];
    
    
    NSString *path = _shopView.model.enterprise_course_img_url[@"pfurl"] ;
    [self pushViewControllerWithUrl:path ];
    
    
}

//筛选

- (void)gotoSelectOrder{
   
    if (self.selectOrderVCT == nil) {
        NSString *vctUrl = [NSString stringWithFormat:@"%@",URL_GoodsSelectOrder];
        self.selectOrderVCT = [self.urlManager viewControllerWithUrl:vctUrl];
    }
    
    if (self.selectOrderVCT) {
        
        if (self.selectOrderVCT.maskView) {
            [self.selectOrderVCT dismissPopControllerWithMaskAnimated:YES];
        }else{
            self.selectOrderVCT.title = @"请选择筛选或排序条件";
            self.selectOrderVCT.toolsView.hidden = YES;
            self.selectOrderVCT.params = @{@"orderId":self.orderId,@"selectId":self.selectId};
            
            [self popViewControllerWithMask:self.selectOrderVCT animated:YES setEdgeInsets:UIEdgeInsetsMake(0, 0, 250, 0)];
            @weakify(self);
            [self.selectOrderVCT setCallbackBlock:^(id callBackData) {
                @strongify(self);
                NSLog(@"%@",callBackData);
                if([callBackData isKindOfClass:[SelectTypeModel class]]){
                    SelectTypeModel* type = callBackData;
                    self.selectId = type.item_id;
                    
                }else if([callBackData isKindOfClass:[OrderTypeModel class]]){
                    OrderTypeModel* type = callBackData;
                    self.orderId = type.item_id;
                }
                
                //                _currentCourseVc

                if(self.index == 0){
                ShopAllViewController* vc = _controllerArr[0];
                    vc.orderID = self.orderId;
                    vc.selectID = self.selectId;
                    [vc first];
                    
                }
                else{
               CourseViewController* vc = _controllerArr[self.index];
                    vc.orderId = self.orderId;
                    vc.selectId = self.selectId;
                    [vc first];
 
                }

                self.params = @{@"orderId":self.orderId,@"selectId":self.selectId};
            }];
        }
    }
    
}




-(void)adImage {
    
    
    if (_adImageView) {
       
        return;

    }
    _adImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -58, self.view.bounds.size.width, 58)];
    
    
    [_adImageView setImageWithURLString:_shopView.model.enterprise_course_img_url[@"pic_url"]];
    
    _adImageView.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyClick:)];
    
    [_adImageView addGestureRecognizer:tap];
    
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //        cancelBtn.backgroundColor = [UIColor redColor];
    
    [cancelBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    
    
    cancelBtn.frame = CGRectMake(self.view.bounds.size.width-30, 20, 20, 20);
    
    [cancelBtn addTarget: self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_adImageView addSubview:cancelBtn];
    
    [self.view addSubview:_adImageView];
    
    
    [_shopView reloadData];
    
    [_shopView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.3 animations:^{
            
            
            //            _mainCollection.frame = CGRectMake(0, 40,self.view.bounds.size.width,  self.view.frame.size.height-148);
            _adImageView.transform = CGAffineTransformMakeTranslation(0, 58);
            
            _shopView.transform = CGAffineTransformMakeTranslation(0, 58);
            
            _pageViewVC.view.transform = CGAffineTransformMakeTranslation(0, 58);
            
            
        }completion:^(BOOL finished) {
            
            
        }];
        
    });
    
    
}

- (void)initRemoteData{
    
    
    @weakify(self)
    RACSignal *racSignal =[[HttpManagerCenter sharedHttpManager] queryCourseIndex:[ShareRootModel class]];
    
    [racSignal subscribeNext:^(BaseModel *model) {
        @strongify(self)
        if (model.code==200) {
            NSLog(@"%@" ,model.data);
//            [self showHUDWithString:@"数据加载中..."];
            NSLog(@"%@",model.data);
            _shopView.model = model.data;
            
            ShareRootModel * rootModel = model.data;
            
            _allCategor = rootModel.all_category_list;
            
            
            
//            }
        }
    } completed:^{
        
        [_shopView reloadData];
        
        
        [_shopView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:nil];
        
//        [self adImage];
        
        [self hiddenHUD];
    }];
}



-(void)search:(UIButton *)sender
{
    [_sequenceView removeFromSuperview];
    [_bgView removeFromSuperview];
//    _bgView = nil;
    
    _bgView = nil;
    _sequenceView = nil;
    
    _sequenceView.sequenceBtn.selected = NO;
    _bgView.twoCategoryView.categoryBtn.selected = NO;
    
    UIViewController *vct = [UIStoryboard viewController:@"MasterShare" identifier:@"MasterShareSearchViewController"];
    
    [self pushViewController:vct animated:YES];
//    return NO;
}

-(void)category:(LeftTitleBtn *)sender
{
    
    NSLog(@"category");
    
     [_sequenceView removeFromSuperview];
    _sequenceView.sequenceBtn.selected = NO;
    
    sender.selected = !sender.selected;
    
    if (!sender.selected) {
        
        [_bgView removeFromSuperview];
        _bgView = nil;
        return;
    }
    
 
    if (!_bgView.superview || _bgView == nil) {
   
        _bgView = [[FilterView alloc]initWithFrame:CGRectMake(0, (IsPhoneX?88:64)+50, ScreenWidth, ScreenHeight-(IsPhoneX?88:64)-50)];

        _bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
        
        _bgView.alpha = 1;
        
        _bgView.model = _allCategor;
        _bgView.firstCategoryView.separatorStyle = UITableViewCellSelectionStyleNone;
        _bgView.twoCategoryView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.tabBarController.view addSubview:_bgView];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _bgView.firstCategoryView.frame = CGRectMake(0, 0, ScreenWidth/2, (_allCategor.count+1) * 44+1);
            _bgView.twoCategoryView.frame = CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, (_allCategor.count+1) * 44+1);
            
        }];
    }
    
    [_bgView setFilter:^(id ID) {
        
        self.categoryId = ID;
        
        [self first];
        
        [UIView animateWithDuration:5 animations:^{
            
            _bgView.frame = CGRectMake(_bgView.frame.origin.x, _bgView.frame.origin.y, ScreenWidth, 1);
            _bgView.twoCategoryView.categoryBtn.selected = NO;
            [_bgView removeFromSuperview];
            _bgView = nil;
            
            
        }];
        
    }];
    
     _bgView.twoCategoryView.categoryBtn = sender;
    
    
}

- (void)sequence:(UIButton *)sender{
    
    [_bgView removeFromSuperview];
    
    _bgView.twoCategoryView.categoryBtn.selected = NO;

    sender.selected = !sender.selected;
    
    if (!sender.selected) {
        
        [_sequenceView removeFromSuperview];
        _sequenceView = nil;
        return;
    }
    
    if (!_sequenceView.superview) {

        _sequenceView = [[SequenceView alloc]initWithFrame:CGRectMake(0, (IsPhoneX?88:64)+50, ScreenWidth, ScreenHeight-(IsPhoneX?88:64)-50)];

        
        _sequenceView.source = @[@"默认",@"人气最高",@"销量最高",@"距离最近",@"上架新课"];
        
        
        _sequenceView.alpha = 1;
        
        _sequenceView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
        
        [_sequenceView setDismiss:^(id index){
            
            self.orderID = index;
            
            [self first];
            
            _sequenceView.sequenceBtn.selected = NO;
            [_sequenceView removeFromSuperview];
            _sequenceView = nil;
            
        }];
        
        
        [self.tabBarController.view addSubview:_sequenceView];
        
        
        [UIView animateWithDuration:0.3 animations:^{
           
            _sequenceView.sequenceTableView.frame = CGRectMake(0, 0, _sequenceView.width, 44*5+1);
            
            
        }];
        
    }
    
      _sequenceView.sequenceBtn = sender;
   
}

- (void)map:(UIButton *)sender{
    
    MapCourseController * mapViewVC = [[MapCourseController alloc]init];
    
    mapViewVC.categorys = _allCategor;
    
    UINavigationController * nav = [[BaseNavigationController alloc]initWithRootViewController:mapViewVC];
    
   
    
    [self.navigationController presentViewController:nav animated:NO completion:nil];
    
    
}



@end
