//
//  KAHomeViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/10/10.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAHomeViewController.h"
#import "NavCityBtn.h"

#import "MasterSearchListModel.h"
#import "SDCycleScrollView.h"
#import "KAHomeTableView.h"
#import "CourseListModel.h"
#import "ItemCourseModel.h"
#import "ImageTopBtn.h"
#import "KAFilterViewController.h"
#import "KAPlaceViewController.h"
#import "KACustomViewController.h"
#import "KAOrdersViewController.h"

#import "UserClient.h"

#define btnW  ([UIScreen mainScreen].bounds.size.width-MARGIN)/3
#define btnH    69
#define MARGIN  2
#define counts 3


@interface KAHomeViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NavCityBtn *cityBtn;

@property (nonatomic, strong) NSArray *bannerList;
@property (nonatomic, strong) NSArray *itemModelArr;
@property (nonatomic, strong) MasterSearchListModel *masterShareList;
@property (nonatomic, strong) SDCycleScrollView *loopScrollView;
@property (nonatomic, strong) KAHomeTableView *kaHomeTableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIButton *releaseBtn;
@property (nonatomic, strong) UIButton *customizeBtn;
@end

@implementation KAHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"团建";
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBtn];
    
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"@"] forState:UIControlStateNormal];
    [button addTarget:self.navigationController action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = rightBarButtonItem;
   
    UIBarButtonItem *fetchItem = [[UIBarButtonItem alloc] initWithCustomView:self.voteNavView];
    
    self.navigationItem.rightBarButtonItem = fetchItem;
    
    self.cnt = [UserClient sharedUserClient].voteNum;
    
    [self.view addSubview:self.kaHomeTableView];
    
    self.kaHomeTableView.baseVC = self;
    
    self.kaHomeTableView.tableHeaderView = self.headView;
    
    [self requestKAHomeData:@"1" pageId:@"1"];
    
    
    @weakify(self)
    
    [RACObserve(self, bannerList) subscribeNext:^(NSArray *list) {
        
        @strongify(self)
        
        if (list && list.count>0) {
            
            NSMutableArray *banerUrlArray = [NSMutableArray new];
            
            for (MasterShareBannerModel *model in list) {
                
                [banerUrlArray addObject:model.pic_url];
                
            }
            
            self.loopScrollView.imageURLStringsGroup = banerUrlArray;
        }
        
    }];
    
    NSInteger height = IsPhoneX?(65+100+34):(65+100);
    
    self.customizeBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-65, ScreenHeight-height, 65, 40)];
    
    [self.customizeBtn setImage:[UIImage imageNamed:@"高端定制"] forState:UIControlStateNormal];
    
//    self.customizeBtn.hidden = YES;
    
    [self.customizeBtn addTarget: self action:@selector(customizeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.customizeBtn];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tabBarController.tabBar setHidden:NO];
    
     self.customizeBtn.hidden = NO;
    
     self.cntLabel.text = [NSString stringWithFormat:@"%ld",[UserClient sharedUserClient].voteNum];
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self.tabBarController.tabBar setHidden:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.tabBarController.tabBar setHidden:YES] ;
    
    self.customizeBtn.hidden = YES;
    
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return NO;
}
#pragma fanfa
- (void)requestKAHomeData:(NSString*)page pageId:(NSString*)pageId {
    
    
    
    
     RACSignal *fetchSignal = [[HttpManagerCenter sharedHttpManager] RequestForSearchData:page page:pageId page_size:@"10" resultClass:[MasterSearchListModel class]];

    [fetchSignal subscribeNext:^(BaseModel *baseModel) {
        if (baseModel.code == 200) {
            
            NSLog(@"%@" ,baseModel.data);
            self.masterShareList = baseModel.data;
            self.bannerList = self.masterShareList.banner_list;
        }

    }completed:^{

    }];
    
    
    RACSignal *fetchSignal1 = [[HttpManagerCenter sharedHttpManager] getCategoryList:@"0" order_type:nil select_type:nil page:@"1" page_size:@"10" resultClass:[CourseListModel class]];
    
    @weakify(self)
    [fetchSignal1 subscribeNext:^(BaseModel *model) {
        @strongify(self)
        if (model.code==200) {
            
            
            CourseListModel * course = model.data;
            
            self.itemModelArr = course.item_list;
           [_headView addSubview:[self creatSectionHeadView]];
            
            self.kaHomeTableView.kaHomeData = course.course_list;
            [self.kaHomeTableView reloadData];
        }
        
    }completed:^{
             
    }];
}

- (void)customizeAction:(UIButton *)button {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"KA" bundle:[NSBundle mainBundle]];
    UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"KACustomViewController"];
    [self pushViewController:myView animated:YES];
}


#pragma daili


- (void)circleView:(SDCycleScrollView *)view didSelectedIndex:(NSInteger)index{
    if(self.bannerList.count>0){
        MasterShareBannerModel *model = self.bannerList[index];
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

#pragma lanjiazai
- (SDCycleScrollView *)loopScrollView{
    if (!_loopScrollView) {
        _loopScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(16, 12, ScreenWidth -32,(ScreenWidth-32)*20/35)];
//        _loopScrollView.isAutoScroll = YES;
        _loopScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentLeft;
        _loopScrollView.delegate = self;
    }
    return _loopScrollView;
}

- (KAHomeTableView *)kaHomeTableView {
    if (!_kaHomeTableView) {
        _kaHomeTableView = [[KAHomeTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
//        _kaHomeTableView.backgroundColor = RGBFromHexadecimal(0xf7f5f6);
        
//        _kaHomeTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        

        
    }
    return _kaHomeTableView;
}

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, (ScreenWidth-32)*20/35 + 16 + 69*2 + 2*3)];
        [_headView addSubview:self.loopScrollView];
       
        
    }
    return _headView;
}

-(UIView*)creatSectionHeadView
{
    
    UIView * sectionHeadView = [[UIView alloc]init];
    
    NSArray *btnImgArr = @[@"上门团建服务",@"VIP客户活动",@"年会会务",@"室外团建",@"场地介绍",@"精选"];
        
        
    sectionHeadView.frame = CGRectMake(0, self.loopScrollView.bottom, ScreenWidth, btnH*counts+3*MARGIN);

    
//    sectionHeadView.backgroundColor = [UIColor redColor];
    
    for (int i = 0; i<btnImgArr.count; i++) {
        
        ImageTopBtn * btn = [ImageTopBtn buttonWithType:UIButtonTypeCustom];
      
            
        btn.frame = CGRectMake(i%counts*(btnW+MARGIN), i/counts*(btnH+MARGIN)+MARGIN, btnW , btnH);
        
      
        [btn setImage:[UIImage imageNamed:btnImgArr[i]] forState:UIControlStateNormal];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            [btn setTitle:btnImgArr[i] forState:UIControlStateNormal];
            
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            
            btn.adjustsImageWhenHighlighted = NO;
            
            btn.backgroundColor = [UIColor whiteColor];
        
        if (i == 0) {
             [btn addTarget: self action:@selector(pushH5) forControlEvents:UIControlEventTouchUpInside];
        }else if (i == 4){
            [btn addTarget: self action:@selector(pushChangdi) forControlEvents:UIControlEventTouchUpInside];
        }else if (i == 3){
            [btn addTarget: self action:@selector(pushOrders) forControlEvents:UIControlEventTouchUpInside];
        }
        
            
            [sectionHeadView addSubview:btn];
                    
    }
    
    return sectionHeadView;
    
}

- (void)pushOrders {
    
    
    KAOrdersViewController *kaPlaceVC = [[KAOrdersViewController alloc] init];
    [self.navigationController pushViewController:kaPlaceVC animated:YES];
}
- (void)pushChangdi {
    KAPlaceViewController *kaPlaceVC = [[KAPlaceViewController alloc] init];
    [self.navigationController pushViewController:kaPlaceVC animated:YES];
}

- (void)pushH5 {
    KAFilterViewController *kaFilterVC = [[KAFilterViewController alloc] init];
    [self.navigationController pushViewController:kaFilterVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
