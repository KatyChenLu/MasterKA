//
//  KAHomeViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/10/10.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAHomeViewController.h"
#import "NavCityBtn.h"

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import "SDCycleScrollView.h"
#import "KAHomeTableView.h"
#import "CourseListModel.h"
#import "ItemCourseModel.h"
#import "ImageTopBtn.h"
#import "KAFilterViewController.h"
#import "KAPlaceViewController.h"
#import "KACustomViewController.h"
#import "KAOrdersViewController.h"
#import "KABannerModel.h"

#import "KAFristHomeModel.h"
#import "ChooseCityController.h"
#import "KAHomeSlideView.h"
#import "KASearchViewController.h"
#import "KAMomentViewController.h"
#import "KACollectViewController.h"
#import "AticleBannerListModel.h"
#import "MineInfoViewController.h"

#define btnW  ([UIScreen mainScreen].bounds.size.width-MARGIN)/3
#define btnH    69
#define MARGIN  2
#define counts 3


@interface KAHomeViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,BMKGeoCodeSearchDelegate,UITextFieldDelegate>{
    NSString *_cityName;
    
    NSString * _currentProvince;
}
@property(nonatomic , copy)NSString * city_code;
//轮播数据源
@property (nonatomic, strong) NSArray *bannerList;
//主页列表
@property (nonatomic, strong) KAHomeTableView *kaHomeTableView;
//轮播
@property (nonatomic, strong) SDCycleScrollView *loopScrollView;
//轮播banner和选择
@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UIView * sectionHeadView;
//定制悬浮按钮
@property (nonatomic, strong) UIButton *customizeBtn;
//地址按钮
@property (nonatomic, strong) NavCityBtn *cityBtn;
//地址和搜索
@property (nonatomic, strong) UIView *placeAndSearchView;
//
@property(nonatomic ,assign)BOOL isPull;
//页数
@property(nonatomic ,copy)NSString * page;
//每页单位
@property(nonatomic ,copy)NSString * page_size;
//
@property (nonatomic, strong) BMKGeoCodeSearch * searcher;
//头像消息小圆点
@property (nonatomic, strong) UIView *redPointView;
//侧拉个人中心
@property (nonatomic, strong)KAHomeSlideView *slideView;
//黑色蒙版
@property (nonatomic, strong) UIView *bgView;
//个人信息
@property (nonatomic, strong)NSDictionary *userInfo;
//首页头像
@property (nonatomic, strong)UIButton *headerBtn;

@property (nonatomic, strong)UILabel *seachBtn;
//引导图
@property (nonatomic, strong)UIView *guideBGView;
@property (nonatomic, strong)UIImageView *guideImg;
@property (nonatomic, strong)UIImageView *guideImg1;
@property (nonatomic, strong)UIImageView *guideImg2;
@property (nonatomic, assign)NSInteger guideTapInt;



@end

@implementation KAHomeViewController
- (BMKGeoCodeSearch *)searcher {
    if (!_searcher) {
        _searcher =[[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
        
        
    }
    return _searcher;
}
- (NavCityBtn *)cityBtn {
    if (!_cityBtn) {
        _cityBtn = [NavCityBtn buttonWithType:UIButtonTypeCustom];
        
        [_cityBtn setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
        
        [_cityBtn addTarget: self action:@selector(chooseCity:) forControlEvents:UIControlEventTouchUpInside];
        
        _cityBtn.frame= CGRectMake(0, 0, 60, 30);
        
        //        _cityBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 17);
        
        [_cityBtn setTitle:[NSString stringWithFormat:@"    %@",_cityName] forState:UIControlStateNormal];
        
        _cityBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [_cityBtn setTitleColor:RGBFromHexadecimal(0x202020) forState:UIControlStateNormal];
        
        [_cityBtn sizeToFit];
        
    }
    return _cityBtn;
}

- (UIView *)placeAndSearchView {
    if (!_placeAndSearchView) {
        _placeAndSearchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 100, 30)];
        UIView *psView = [[UIView alloc] initWithFrame:CGRectMake(9, 0, ScreenWidth- 100-10, 30)];
        [_placeAndSearchView addSubview:psView];
        
        psView.backgroundColor = RGBFromHexadecimal(0xf8f7f5);
        psView.layer.cornerRadius = 8.0f;
        psView.layer.masksToBounds = YES;
        [psView addSubview:self.cityBtn];
        self.cityBtn.centerY = psView.centerY;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(60, 7, 0.5, 16)];
        lineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [psView addSubview:lineView];
        UIView *seachView = [[UIView alloc] initWithFrame:CGRectMake(60 + 10, 0, ScreenWidth - 100 - 61 -10, 30)];
        seachView.backgroundColor = [UIColor clearColor];
        [psView addSubview:seachView];
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
        img.frame = CGRectMake(0, 0, 16, 16);
        img.centerY = psView.centerY;
        
        [seachView addSubview:img];
        [seachView addSubview:self.seachBtn];
        self.seachBtn.centerY =psView.centerY;
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchAction)];
        [singleTapGestureRecognizer setNumberOfTapsRequired:1];
        
        [seachView addGestureRecognizer:singleTapGestureRecognizer];
        
    }
    return _placeAndSearchView;
}
- (UILabel  *)seachBtn {
    if (!_seachBtn) {
        _seachBtn = [[UILabel alloc] init];
        _seachBtn.text = @"   搜索你感兴趣的活动";
        _seachBtn.textColor = [UIColor lightGrayColor];
        _seachBtn.frame = CGRectMake(20, 0, 200, 30);
        _seachBtn.font =[UIFont systemFontOfSize:12];
    }
    return _seachBtn;
}

- (UIImageView *)guideImg {
    if (!_guideImg) {
        _guideImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Guide0"]];
    }
    return _guideImg;
}
- (UIImageView *)guideImg1 {
    if (!_guideImg1) {
        _guideImg1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Guide1"]];
        NSInteger height = IsPhoneX?(65+100+34):(65+100);
        _guideImg1.frame = CGRectMake(ScreenWidth-188-35, ScreenHeight-height-100, 188, 110);
    }
    return _guideImg1;
}
- (UIImageView *)guideImg2 {
    if (!_guideImg2) {
        _guideImg2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Guide2"]];
        _guideImg2.frame = CGRectMake((ScreenWidth -355)/2, (ScreenHeight -232)/2, 355, 232);
    }
    return _guideImg2;
}

- (UIView *)guideBGView {
    if (!_guideBGView) {
        _guideBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _guideBGView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [_guideBGView addSubview:self.guideImg];
        [self.guideImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_guideBGView.mas_right).offset(-6);
            make.top.equalTo(_guideBGView.mas_top).offset(23+(IsPhoneX?44:0));
            make.width.equalTo(@195);
            make.height.equalTo(@118);
        }];
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(guideTap)];
        [singleTapGestureRecognizer setNumberOfTapsRequired:1];
        
        [_guideBGView addGestureRecognizer:singleTapGestureRecognizer];
    }
    return _guideBGView;
}
- (UIButton *)customizeBtn {
    if (!_customizeBtn) {
        
        NSInteger height = IsPhoneX?(65+100+34):(65+100);
        
        _customizeBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-102*0.7, ScreenHeight-height, 102*0.7, 67*0.7)];
        
        [_customizeBtn setImage:[UIImage imageNamed:@"高端定制"] forState:UIControlStateNormal];
        
        //    self.customizeBtn.hidden = YES;
        
        [_customizeBtn addTarget: self action:@selector(customizeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customizeBtn;
}
- (void)guideTap {
    if (self.guideTapInt == 0) {
        [self.guideImg removeFromSuperview];
        [self.guideBGView addSubview:self.guideImg1];
    }else if (self.guideTapInt == 1){
        
        [self.guideImg1 removeFromSuperview];
        [self.guideBGView addSubview:self.guideImg2];
    }else if (self.guideTapInt == 2){
        
        [self.guideImg2 removeFromSuperview];
        [self.guideBGView removeFromSuperview];
    }
    self.guideTapInt++;
}
- (void)configureGuide {
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSString* appCode = [userDefault objectForKey:FristStartAppVersionKey];
    if (appCode==nil || ![App_Version isEqualToString:appCode])//新版本
    {
        if (appCode == nil) {
    
//            self.firstInstall = YES;
            self.guideTapInt = 0;
            [[UIApplication sharedApplication].keyWindow addSubview:self.guideBGView];
            
        }
        [userDefault setObject: App_Version forKey:FristStartAppVersionKey];
        [userDefault synchronize];


    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = @"1";
    self.page_size = @"10";
    self.city_code = [UserClient sharedUserClient].city_code;
    _cityName = [UserClient sharedUserClient].city_name?:@"北京";

    [self.view addSubview:self.kaHomeTableView];
     self.kaHomeTableView.tableHeaderView = self.headView;
    
    self.kaHomeTableView.baseVC = self;
    
    [self requestKAHomeData:self.page pageId:self.page_size];
    //配置NAV
    [self configureNavBar];
    
    
    
//    guide
    [self configureGuide];
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.customizeBtn];
    //获取我的主页
    [self RefurbishMyInfo];
    //获取定位
    [self beginLoacation];
    [self addNotifications];
    

}
- (void)showCusBtn:(BOOL)show {
    NSInteger height = IsPhoneX?(65+100+34):(65+100);
    if (show) {
        [UIView animateWithDuration:0.5 animations:^{
            self.customizeBtn.frame = CGRectMake(ScreenWidth-102*0.7, ScreenHeight-height, 102*0.7, 67*0.7);
            self.customizeBtn.alpha = 1.0f;
        }];
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            self.customizeBtn.frame = CGRectMake(ScreenWidth-102*0.7*0.5, ScreenHeight-height, 102*0.7, 67*0.7);
            self.customizeBtn.alpha = 0.5f;
        }];
    }
}
- (void)configureNavBar {
    
       self.navigationItem.titleView = self.placeAndSearchView;
    
    UIView *leftBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    
    _headerBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    
    
    [_headerBtn addTarget:self action:@selector(showSlideViewAction) forControlEvents:UIControlEventTouchUpInside];
    
    _headerBtn.layer.cornerRadius = 16.0f;
    _headerBtn.layer.masksToBounds = YES;
    [leftBarView addSubview:_headerBtn];
    
    
    
    self.redPointView = [[UIView alloc] initWithFrame:CGRectMake(24, 0, 8, 8)];
    self.redPointView.backgroundColor = [UIColor redColor];
    self.redPointView.layer.cornerRadius = 4.0f;
    self.redPointView.layer.masksToBounds = YES;
    self.redPointView.hidden = YES;
    [leftBarView addSubview:self.redPointView];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarView];
    self.navigationItem.leftBarButtonItem = rightBarButtonItem;
    
    
    
    UIBarButtonItem *fetchItem = [[UIBarButtonItem alloc] initWithCustomView:self.voteNavView];
    
    self.navigationItem.rightBarButtonItem = fetchItem;
    
    self.navigationController.navigationBar.layer.shadowColor = RGBFromHexadecimal(0x2D2D2D).CGColor; //shadowColor阴影颜色
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(2.0f , 2.0f);
    self.navigationController.navigationBar.layer.shadowOpacity = 0.06f;//阴影透明度，默认0
    self.navigationController.navigationBar.layer.shadowRadius = 8.0f;//阴影半径
    
}
- (void)addNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefurbishMyInfo) name:@"RefurbishMyInfo" object:nil];
}
- (void)dealloc{
    
    [self removeNotifications];
    
}
- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefurbishMyInfo" object:nil];
}
- (void)beginLoacation{
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){[[UserClient sharedUserClient].locationLat floatValue], [[UserClient sharedUserClient].locationLng floatValue]};
    
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [self.searcher reverseGeoCode:reverseGeoCodeSearchOption];
    
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.customizeBtn.hidden = NO;
    
    [self reloadCntLabel];
    
    self.navigationController.navigationBar.layer.shadowColor = RGBFromHexadecimal(0x2D2D2D).CGColor; //shadowColor阴影颜色
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(2.0f , 2.0f);
    self.navigationController.navigationBar.layer.shadowOpacity = 0.06f;//阴影透明度，默认0
    self.navigationController.navigationBar.layer.shadowRadius = 8.0f;//阴影半径
    
//    UIView *linView = [self.navigationController.navigationBar viewWithTag:20];
//    [linView removeFromSuperview];
    
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self.tabBarController.tabBar setHidden:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.tabBarController.tabBar setHidden:YES] ;
    
    self.customizeBtn.hidden = YES;
    
    //不使用时将delegate设置为 nil
    _searcher.delegate = nil;
    
    self.navigationController.navigationBar.layer.shadowColor = [UIColor clearColor].CGColor; //shadowColor阴影颜色
    
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0.0f , 0.0f);
//    UIView *lineView = [[UIView alloc]init];
//    lineView.backgroundColor = RGBFromHexadecimal(0xeaeaea);
//    lineView.translatesAutoresizingMaskIntoConstraints = NO;
//    lineView.tag = 20;
//    [self.navigationController.navigationBar addSubview:lineView];
//    UIView *superView = self.navigationController.navigationBar;
//    [superView addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
//    [superView addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
//    [superView addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
//    [lineView addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1]];
    
}
-(void)RefurbishMyInfo{
    @weakify(self)
    self.userInfo = [NSDictionary dictionary];
    
    [[[HttpManagerCenter sharedHttpManager] queryKAUserCenterWith:nil] subscribeNext:^(BaseModel *model){
        @strongify(self)
        if (model.code==200) {
            self.userInfo = model.data;
            
        }else {
            
        }
    }];
    
}
- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self);
    [RACObserve(self, userInfo) subscribeNext:^(NSDictionary * x) {
        @strongify(self);
        if ([self.userInfo[@"is_login"] isEqualToString:@"1"]) {
            [_headerBtn setImageUrlForState:UIControlStateNormal withUrl:[self.userInfo[@"img_top"] ClipImageUrl:[NSString stringWithFormat:@"%f",32*0.75*ScreenScale]] placeholderImage:[UIImage imageNamed:@"headPlaceorder"]];
            [self.slideView.headImgBtn setImageUrlForState:UIControlStateNormal withUrl:[self.userInfo[@"img_top"] ClipImageUrl:[NSString stringWithFormat:@"%f",32*0.75*ScreenScale]] placeholderImage:[UIImage imageNamed:@"headPlaceorder"]];
            self.slideView.nameLabel.hidden = NO;
            self.slideView.nameLabel.text = self.userInfo[@"nikename"]?:@"我是谁?";
            self.slideView.loginBtn.hidden = YES;
            self.slideView.dingdanDianView.hidden = [self.userInfo[@"ka_order_num"] isEqualToString:@"0"]?YES:NO;
//            self.slideView.xiangceDianView.hidden = [self.userInfo[@"ka_photo_num"] isEqualToString:@"0"]?YES:NO;
//            self.redPointView.hidden = self.slideView.dingdanDianView.hidden&&self.slideView.xiangceDianView.hidden;
           
            
//            self.kaHomeTableView.isChange = YES;
//             [self first];
        }else {
            [_headerBtn setImage:[UIImage imageNamed:@"headPlaceorder"] forState:UIControlStateNormal];
            [_slideView.headImgBtn setImage:[UIImage imageNamed:@"headPlaceorder"] forState:UIControlStateNormal];
            _slideView.loginBtn.hidden = NO;
            _slideView.nameLabel.hidden = YES;
            _slideView.dingdanDianView.hidden = YES;
//            _slideView.xiangceDianView.hidden = YES;
            self.redPointView.hidden = YES;
            [[UserClient sharedUserClient] setVoteNum:0];
//            self.kaHomeTableView.isChange = YES;
//            [self first];
            [self reloadCntLabel];
          
        }
        
    }];
}

#pragma mark - fangfa -
- (void)requestKAHomeData:(NSString*)page pageId:(NSString*)pageId {
    
    
    RACSignal *fetchSignal = [[HttpManagerCenter sharedHttpManager] getHomeDataListsPage:page pageSize:self.page_size resultClass:nil];
    
    [fetchSignal subscribeNext:^(BaseModel *baseModel) {
        if (baseModel.code == 200) {
            
            self.bannerList = baseModel.data[@"banner"];
            
            if (self.bannerList && self.bannerList.count>0) {
                
                NSMutableArray *banerUrlArray = [NSMutableArray new];
                
                for (NSDictionary *model in self.bannerList) {
                    
                    [banerUrlArray addObject:model[@"pic_url"]];
                    
                }
                NSMutableArray *bannerArr = [NSMutableArray array];
                [banerUrlArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *url =   [[banerUrlArray[idx] ClipImageUrl:[NSString stringWithFormat:@"%f",(ScreenWidth- 24)*0.75*[UIScreen mainScreen].scale]] masterFullImageUrl];
                    [bannerArr addObject:url];
                }];
                
                self.loopScrollView.imageURLStringsGroup = bannerArr;
            }
        }
        [self.headView addSubview:[self creatSectionHeadView]];
        
        
        self.kaHomeTableView.kaHomeData = baseModel.data[@"course_lists"];
        [self.kaHomeTableView reloadData];
        
        
        if ([[(NSDictionary *)baseModel.data allKeys] containsObject:@"vote_cart_num"]) {
            [[UserClient sharedUserClient] setVoteNum:[baseModel.data[@"vote_cart_num"] integerValue]];
            
            [self reloadCntLabel];
        }
        if ([page isEqualToString:@"1"]) {
            if ([baseModel.data[@"red_num"] isEqualToString:@"0"]) {
                self.redPointView.hidden = YES;
            }else{
                self.redPointView.hidden = NO;
            }
        }
       
        
    }completed:^{
        
        if(self.kaHomeTableView.mj_header.isRefreshing){
            
            [self.kaHomeTableView.mj_header endRefreshing];
            
        }
        
        if(self.kaHomeTableView.mj_footer.isRefreshing){
            
            [self.kaHomeTableView.mj_footer endRefreshing];
        }
    }];
    
    
}

- (void)customizeAction:(UIButton *)button {
   
        if([self doLogin]){
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"KA" bundle:[NSBundle mainBundle]];
            UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"KACustomViewController"];
            [self pushViewController:myView animated:YES];
        }
   
}

#pragma mark - SlideNavigationController Methods -

//- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
//{
//    return NO;
//}
//
//- (BOOL)slideNavigationControllerShouldDisplayRightMenu
//{
//    return NO;
//}


#pragma daili


- (void)circleView:(SDCycleScrollView *)view didSelectedIndex:(NSInteger)index{
    if(self.bannerList.count>0){
        KABannerModel *model = self.bannerList[index];
        if ([model.is_login integerValue]==1 && !self.userClient.rawLogin) {
            [self doLogin];
        }else{
            
            //广告位统计
            RACSignal * singal = [[HttpManagerCenter sharedHttpManager]totalAds_data_id:model.ads_data_id index:[NSString stringWithFormat:@"%ld",index] resultClass:nil];
            
            
            [singal subscribeNext:^(BaseModel *model) {
                
                if (model.code == 200) {
                    
                    NSLog(@"%@", model.data);
                }
                
            }];
            
            [self pushViewControllerWithUrl:model.pfurl];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0){
    
    if(buttonIndex == 1){
        
        RLMResults *categoryResult = [CityModel allObjects];
        
        NSMutableDictionary*  _cityDic = [NSMutableDictionary dictionary];
        
        NSString * currentStr = @"";
        
        for (CityModel* model in categoryResult) {
            
            [_cityDic setValue:model.city_code forKey:model.city_name];
            
            if ([_currentProvince isEqualToString:model.city_name]) {
                
                if ([model.city_name containsString:@"省"]||[model.city_name containsString:@"市"]) {
                    
                    NSRange rangeCity = [model.city_name rangeOfString:@"市"];
                    NSRange rangeProvince = [model.city_name rangeOfString:@"省"];
                    
                    NSString * str;
                    NSLog(@"%lu , %lu" , (unsigned long)rangeProvince.length , rangeProvince.location);
                    
                    if (rangeCity.length != 0) {
                        
                        str = [model.city_name substringToIndex:rangeCity.location];
                        
                        NSLog(@"%@" , str);
                    }else if(rangeProvince.length !=0 )
                    {
                        
                        str = [model.city_name substringToIndex:rangeProvince.location];//rangeProvince
                        
                        NSLog(@"%@" , str);
                        
                    }
                    
                    currentStr = str;
                    
                }
                
            }
            
        }
        
        
        [self.cityBtn setTitle:[NSString stringWithFormat:@"    %@",currentStr] forState:UIControlStateNormal];
        
        for ( NSString * str  in [_cityDic allKeys]) {
            
            if([str isEqualToString:_currentProvince]) {
                
                self.city_code = _cityDic[str];
                
            }
            
        }
        
        
        [UserClient sharedUserClient].city_code = self.city_code;
        
        [UserClient sharedUserClient].city_name = currentStr;
        
        
        self.kaHomeTableView.isChange = YES;
        
        //如果用户切换城市就重现加载数据
        [self requestKAHomeData:self.page pageId:self.page_size];
        
    }
    
    
    
}
#pragma mark ——— BMKGeoCodeSearchDelegate

//返回反地理编码搜索结果

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    if (error == BMK_SEARCH_NO_ERROR) {//检索结果正常返回
        
        NSLog(@"省份名称_%@" , result.addressDetail.province);
        
        if ([CLLocationManager locationServicesEnabled] &&
            ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse
             || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {//定位功能可用，开始定位
                
                NSLog(@"定位开启");
                
                RLMResults *categoryResult = [CityModel allObjects];
                
                for (CityModel* model in categoryResult) {
                    
                    if ([result.addressDetail.province isEqualToString:model.city_name]) {
                        
                        if (![result.addressDetail.province containsString:_cityName]) {
                            
                            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"您的位置已改变至%@，是否切换城市",result.addressDetail.province] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"切换", nil];
                            [alert show];
                            
                        }
                        
                    }
                    
                }
                
                _currentProvince = result.addressDetail.province;
                
            }else if (![CLLocationManager locationServicesEnabled]&&[CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
                
                NSLog(@"定位关闭");
                
                return;
                
            }
    }else {
        
        NSLog(@"抱歉，未找到结果");
        
    }
    
}


#pragma mark ——— event response

- (void)chooseCity:(UIButton *)sender{
    
    UIStoryboard * story = [UIStoryboard storyboardWithName:@"KA" bundle:nil];
    
    ChooseCityController * chooseCityVC = [story instantiateViewControllerWithIdentifier:@"ChooseCityController"];
    
    @weakify(self)
    
    [chooseCityVC setChangeCityBlock:^(CityModel * model){
        
        @strongify(self)
        
        [self.cityBtn setTitle:[NSString stringWithFormat:@"    %@",model.alias_name] forState:UIControlStateNormal];
        
        [UserClient sharedUserClient].city_code = model.city_code;
        
        [UserClient sharedUserClient].city_name = model.alias_name;
        
        self.page = @"1";
        
        self.kaHomeTableView.isChange = YES;
        
        [self requestKAHomeData:self.page pageId:self.page_size];
        
    }];
    
    [self presentViewController:chooseCityVC animated:YES completion:nil];
    
}



#pragma lanjiazai
- (SDCycleScrollView *)loopScrollView{
    if (!_loopScrollView) {
        _loopScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(16, 12, ScreenWidth -32,(ScreenWidth-32)*20/35)];
        _loopScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _loopScrollView.pageDotImage = [UIImage imageNamed:@"未选中轮播标签"];
        _loopScrollView.currentPageDotImage = [UIImage imageNamed:@"选中轮播标签"];
        _loopScrollView.delegate = self;
        _loopScrollView.layer.cornerRadius = 8.0f;
        _loopScrollView.layer.masksToBounds = YES;
    }
    return _loopScrollView;
}


- (KAHomeTableView *)kaHomeTableView {
    if (!_kaHomeTableView) {
        _kaHomeTableView = [[KAHomeTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
        _kaHomeTableView.mj_header = [MasterTableHeaderView addRefreshGifHeadViewWithRefreshBlock:^{
            
            [self first];
            
        }];
        
        _kaHomeTableView.mj_footer = [MasterTableFooterView footerWithRefreshingBlock:^{
            
            [self more];
            
        }];
    }
    return _kaHomeTableView;
}

- (void)first {
    [_kaHomeTableView.kaHomeData removeAllObjects];
    self.page = @"1";
    [self requestKAHomeData:self.page pageId:self.page_size];
    [_kaHomeTableView reloadData];
}

- (void)more {
    self.page = [NSString stringWithFormat:@"%d",[self.page intValue]+1];
    [self requestKAHomeData:self.page pageId:self.page_size];
    
}
- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, (ScreenWidth-32)*20/35 + 16 + 69*2 + 2*3 +42)];
        [_headView addSubview:self.loopScrollView];
        _headView.backgroundColor = [UIColor whiteColor];
        
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, (ScreenWidth-32)*20/35 + 16 + 69*2 + 2*3, ScreenWidth, 42)];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel * showLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 26)];
        showLabel.text = @"热门推荐";
        showLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:22];
        showLabel.textColor = [UIColor blackColor];
        showLabel.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:showLabel];
        [_headView addSubview:headerView];
    }
    return _headView;
}

-(UIView*)creatSectionHeadView
{
    if (!_sectionHeadView) {
        NSArray *btnImgArr = [UserClient sharedUserClient].sence;
        if (btnImgArr.count) {
           _sectionHeadView = [[UIView alloc]init];
            
            _sectionHeadView.frame = CGRectMake(0, self.loopScrollView.bottom, ScreenWidth, btnH*counts+3*MARGIN);
    
                [btnImgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ImageTopBtn * btn = [ImageTopBtn buttonWithType:UIButtonTypeCustom];
                    
                    btn.frame = CGRectMake(idx%counts*(btnW+MARGIN), idx/counts*(btnH+MARGIN)+MARGIN, btnW , btnH);
                    
                    [btn setImageUrlForState:UIControlStateNormal withUrl:btnImgArr[idx][@"url"] placeholderImage:nil];
                    
                    [btn setTitle:btnImgArr[idx][@"name"] forState:UIControlStateNormal];
                    
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    
                    btn.titleLabel.font = [UIFont systemFontOfSize:12];
                    
                    btn.adjustsImageWhenHighlighted = NO;
                    
                    btn.backgroundColor = [UIColor whiteColor];
                    
                    btn.scenesID = btnImgArr[idx][@"id"]?:@"";
                    btn.titleName = btnImgArr[idx][@"name"]?:@"";
                    if (idx == 4){
                        [btn addTarget: self action:@selector(pushChangdi) forControlEvents:UIControlEventTouchUpInside];
                    }else if (idx == 5){
                        [btn addTarget: self action:@selector(pushJingchai) forControlEvents:UIControlEventTouchUpInside];
                    }else{
                        [btn addTarget: self action:@selector(pushFiler:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    
                    
                    [_sectionHeadView addSubview:btn];
                }];
        }else {
            
            NSDictionary *nomolDic =[self creatNomolDic];
            [[UserClient sharedUserClient] setAppConfigUrlFormDic:nomolDic];
            [self.headView addSubview:[self creatSectionHeadView]];
        }
    }
    return _sectionHeadView;
}
- (void)pushJingchai {
    KAMomentViewController *kaPlaceVC = [[KAMomentViewController alloc] init];
    [self.navigationController pushViewController:kaPlaceVC animated:YES];
}
- (NSDictionary *)creatNomolDic{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *citysArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cityJson" ofType:@"plist"]];
    [dic setObject:@"0" forKey:@"course_price_min"];
    [dic setObject:@"1000" forKey:@"course_price_max"];
    [dic setObject:@"0" forKey:@"people_num_min"];
    [dic setObject:@"200" forKey:@"people_num_max"];
    NSArray *courseTimeArr = @[@"1小时",@"1.5小时",@"2小时",@"2.5小时",@"3小时",@"3.5小时",@"半天",@"一天",@"两天",@"三天及以上"];
    [dic setObject:courseTimeArr forKey:@"course_time"];
    [dic setObject:@"http:\/\/www.gomaster.cn\/mweb\/index.php?c=ipage&a=about" forKey:@"about_us_url"];
    [dic setObject:@"http:\/\/www.gomaster.cn\/mweb\/index.php?c=ipage&a=agree" forKey:@"agree_url"];
    [dic setObject:@"400-8852446" forKey:@"server_number"];
    
    NSArray *senceArr = @[@{@"id":@1,@"name":@"上门团建服务",@"url":@"uploadfile/ka_sence/1.png"},@{@"id":@2,@"name":@"VIP客户活动",@"url":@"uploadfile/ka_sence/2.png"},@{@"id":@3,@"name":@"户外拓展",@"url":@"uploadfile/ka_sence/3.png"},@{@"id":@4,@"name":@"年会&商场活动",@"url":@"uploadfile/ka_sence/4.png"},@{@"name":@"场地介绍",@"url":@"uploadfile/ka_sence/5.png"},@{@"name":@"精彩时刻",@"url":@"uploadfile/ka_sence/6.png"},];
    
    NSDictionary *reDic = @{@"taking_time":@"15分钟",@"people_num":@[@"待定",@"10～20人",@"21～30人",@"31～40人",@"41～50人",@"50人以上"],@"group_type":@[@"不限",@"上门团建",@"外出团建"],@"course_time":@[@"不限",@"半天",@"一天",@"两天",@"三天及以上"],@"course_price":@[@"不限",@"200元以下",@"200～300元",@"300～500元",@"500元以上"]};
    
    [dic setObject:senceArr forKey:@"sence"];
    [dic setObject:reDic forKey:@"requirement"];
    return dic;
}

- (void)pushChangdi {
    KAPlaceViewController *kaPlaceVC = [[KAPlaceViewController alloc] init];
    [self.navigationController pushViewController:kaPlaceVC animated:YES];
}

- (void)pushFiler:(ImageTopBtn *)btn {
    KAFilterViewController *kaFilterVC = [[KAFilterViewController alloc] init];
    kaFilterVC.scenesID = btn.scenesID;
    kaFilterVC.title = btn.titleName;
    [self.navigationController pushViewController:kaFilterVC animated:YES];
}

- (void)showSlideViewAction {
    
    [self.navigationController.view addSubview:self.bgView];
 
    [self.bgView addSubview:self.slideView];
    
    [UIView animateWithDuration:0.5 animations:^{
           _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.slideView.frame = CGRectMake(0, 0, ScreenWidth*250/375, ScreenHeight);
    } completion:^(BOOL finished) {
        
    }];
    
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
        [singleTapGestureRecognizer setNumberOfTapsRequired:1];
        
        [_bgView addGestureRecognizer:singleTapGestureRecognizer];
    }
    return _bgView;
}

//- (void)panHappen:(UIPanGestureRecognizer *)pan
//{
//    CGPoint point = [pan translationInView:self.slideView];
//
//    CGPoint center = pan.view.center;
//
//    center.x += point.x;
//    if (center.x > 0 && center.x < self.slideView.frame.size.width)
//    {
//        pan.view.center = center;
//    }
//    [pan setTranslation:CGPointMake(0, 0) inView:self.slideView];
//     [self.slideView setNeedsDisplay];
//}
- (KAHomeSlideView *)slideView {
    if (!_slideView) {
        _slideView = [[[NSBundle mainBundle] loadNibNamed:@"KAHomeSlideView" owner:nil options:nil] lastObject];
        _slideView.frame = CGRectMake(-ScreenWidth*250/375, 0, ScreenWidth*250/375, ScreenHeight);
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        swipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [_slideView addGestureRecognizer:swipe];
        if ([UserClient sharedUserClient].rawLogin) {
            [_slideView.headImgBtn setImageUrlForState:UIControlStateNormal withUrl:[UserClient sharedUserClient].userInfo[@"img_top"] placeholderImage:[UIImage imageNamed:@"headPlaceorder"]];
            _slideView.nameLabel.text = [UserClient sharedUserClient].userInfo[@"nikename"]?:@"我是谁?";
            _slideView.loginBtn.hidden = YES;
            
            
        }else {
            
            _slideView.loginBtn.hidden = NO;
            _slideView.nameLabel.hidden = YES;
            _slideView.dingdanDianView.hidden = YES;
//            _slideView.xiangceDianView.hidden = YES;
            [_slideView.headImgBtn setImage:[UIImage imageNamed:@"headPlaceorder"] forState:UIControlStateNormal];
        }
//         [_slideView.shoucangBtn setTitle:[UserClient sharedUserClient].server_number forState:UIControlStateNormal];
        
        @weakify(self);
        [_slideView setFinishSlide:^(NSString *choose) {
            @strongify(self);
            if([self doLogin]){
                if ([choose isEqualToString:@"setting"]) {
                    
                    [self singleTap:nil];
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
                    UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"SettingViewController"];
                    [self pushViewController:myView animated:YES];
                    
                }else if ([choose isEqualToString:@"dingdan"]) {
                    [self singleTap:nil];
                    KAOrdersViewController *kaPlaceVC = [[KAOrdersViewController alloc] init];
                    [self pushViewController:kaPlaceVC animated:YES];
                    
                }else if ([choose isEqualToString:@"shoucang"]){
                    [self singleTap:nil];
                    KACollectViewController *collectVC = [[KACollectViewController alloc] init];
                    [self pushViewController:collectVC animated:YES];
                }else if ([choose isEqualToString:@"xiangce"]){
//                    [self singleTap:nil];
//                    KACollectViewController *collectVC = [[KACollectViewController alloc] init];
//                    [self pushViewController:collectVC animated:YES];
                }else if([choose isEqualToString:@"headerBtn"]){
                     [self singleTap:nil];
//                    MineInfoViewController *mineInfoVC = [[MineInfoViewController alloc] init];
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
                    UIViewController *mineInfoVC = [story instantiateViewControllerWithIdentifier:@"MineInfoViewController"];
                    [self pushViewController:mineInfoVC animated:YES];
                }
            }
        }];
    }
    return _slideView;
}
- (void)singleTap:(id)gestureRecognizer {
    [UIView animateWithDuration:0.2 animations:^{
        _slideView.frame = CGRectMake(-ScreenWidth*250/375, 0, ScreenWidth*250/375, ScreenHeight);
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
//        _bgView = nil;
//        _slideView =nil;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITextFieldDelegate

- (void)searchAction{
    
    KASearchViewController *vct = [[KASearchViewController alloc] init];
    
    [self.navigationController pushViewController:vct animated:YES];
    
}
#pragma SDCycleScrollViewDelegate

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSDictionary * model  =   self.bannerList[index];
    
    
    
    //    RACSignal * singal = [[HttpManagerCenter sharedHttpManager]totalAds_data_id:model.ads_data_id index:index resultClass:nil];
    //
    //    [singal subscribeNext:^(BaseModel * model) {
    //
    //        if (model.code == 200) {
    //
    //            NSLog(@"%@",model.data);
    //
    //        }
    //
    //    }];
    
    [self pushViewControllerWithUrl:model[@"pfurl"]];
    
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
