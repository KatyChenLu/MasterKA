//
//  MajorViewController.m
//  MasterKA
//
//  Created by 余伟 on 16/8/15.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MajorViewController.h"

#import "ShopTableView.h"
#import "CourseListModel.h"
#import "MasterTableHeaderView.h"
#import "MasterTableFooterView.h"


@interface MajorViewController ()

@property(nonatomic , assign)NSInteger curPage;

@property(nonatomic ,copy)NSString * pageSize;

@end

@implementation MajorViewController
{
    ShopTableView * _tableView;
    
     NSString * _city;
}




-(void)viewDidLoad
{
    
    [super viewDidLoad];
    
    _city = [UserClient sharedUserClient].city_name;
    
    self.curPage = 1;
    
    self.pageSize = @"10";
    
    _tableView = [[ShopTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-148)];
    

    
    [_tableView setJumpH5:^(NSString *urlStr) {
        
        
        [self pushViewControllerWithUrl:urlStr];
        
    }];
    
    _tableView.mj_header = [MasterTableHeaderView headerWithRefreshingBlock:^{
        
        
        [self first];
        
    }];

    
    _tableView.mj_footer = [MasterTableFooterView footerWithRefreshingBlock:^{
        
        
        [self requestRemoteDataSignalWithPage:self.curPage +=1 withCategoryId:@"-1" withOrder_type:nil withSelect_type:nil andPage_size:self.pageSize];
        
    }];

    
    
    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoMajor:) name:@"major" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoCourse:) name:@"course" object:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        [self requestRemoteDataSignalWithPage:self.curPage withCategoryId:@"-1" withOrder_type:nil withSelect_type:nil andPage_size:self.pageSize];
    });
    
    
}






-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![_city isEqualToString:[UserClient sharedUserClient].city_name]) {
        
        self.curPage = 1;
        [self showHUDWithString:@"切换城市中..."];
        
        _tableView.isChange = YES;
        
        [self requestRemoteDataSignalWithPage:self.curPage withCategoryId:@"-1" withOrder_type:nil withSelect_type:nil andPage_size:self.pageSize];
        
        
        
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"cityChange" object:nil];
        
        _city = [UserClient sharedUserClient].city_name;
        
        
        [self hiddenHUD];
    }
    
}












//跳h5
-(void)gotoMajor:(NSNotification *)notify{
    
    
    [self pushViewControllerWithUrl:notify.object];
    
    
}


//跳课程详情

-(void)gotoCourse:(NSNotification *)notify{
    
    
    NSString *url = [NSString stringWithFormat:@"%@?courseId=%@",URL_GoodsDetail,notify.object];
    [self pushViewControllerWithUrl:url];
    
}



- (void)requestRemoteDataSignalWithPage:(NSUInteger)page withCategoryId:(NSString *)categoryId withOrder_type:(NSString*)order_type withSelect_type:(NSString*)select_type andPage_size:(NSString*)pageSize
{
    RACSignal *fetchSignal = [[HttpManagerCenter sharedHttpManager] getCategoryList:categoryId order_type:order_type select_type:select_type page:[NSString stringWithFormat:@"%lu",(unsigned long)page] page_size:pageSize resultClass:[CourseListModel class]];//
    //    return fetchSignal;
    @weakify(self)
    [fetchSignal subscribeNext:^(BaseModel *model) {
        @strongify(self)
        if (model.code==200) {
            
//            self.model = model.data;
            _tableView.model = model.data;
            
            
            CourseListModel * course = model.data;
            
            if (course.subject_list.count == 0) {
                
                
                [self showHUDWithString:@"没有更多数据"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self hiddenHUD];
                    
                });
            
            }
          
            
        }else{
            
        }
    } completed:^{
        
        
        [_tableView reloadData];
//
        [_tableView.mj_footer endRefreshing];
        
        [_tableView.mj_header endRefreshing];
        
        [self hiddenHUD];
        
        
    }];
    
    
    
}



- (void)first
{
    [self showHUDWithString:@"加载中.."];
    
    [_tableView.sourceArr removeAllObjects];
    
    self.curPage = 1;
    [_tableView.mj_footer resetNoMoreData];
    //
        [self requestRemoteDataSignalWithPage:self.curPage withCategoryId:@"-1" withOrder_type:nil withSelect_type:nil andPage_size:self.pageSize];
    
    [_tableView reloadData];
    
    [_tableView.mj_header endRefreshing];
    
}



@end
