
//
//  CourseViewController.m
//  MasterKA
//
//  Created by 余伟 on 16/8/15.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "CourseViewController.h"
#import "CourseTableView.h"
#import "MasterTableHeaderView.h"
#import "MasterTableFooterView.h"

@interface CourseViewController ()

@property(nonatomic , assign)NSInteger curPage;

@property(nonatomic ,copy)NSString * pageSize;

@end

@implementation CourseViewController
{
    CourseTableView * _course;
    
    NSString * _city;
}



-(void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.pageSize = @"10";
    
    self.curPage = 1;
    
    self.orderId = @"";
    
    self.selectId = @"";
    
    [self bulidView];
    
     _city = [UserClient sharedUserClient].city_name;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        [self requestRemoteDataSignalWithPage:self.curPage withCategoryId:self.categoryId withOrder_type:nil withSelect_type:nil andPage_size:self.pageSize];
    });
    
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![_city isEqualToString:[UserClient sharedUserClient].city_name]) {
        
        self.curPage = 1;
        [self showHUDWithString:@"切换城市中..."];
        
        _course.isChange = YES;
        
        [self requestRemoteDataSignalWithPage:self.curPage withCategoryId:self.categoryId withOrder_type:nil withSelect_type:nil andPage_size:self.pageSize];
        
        
        
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"cityChange" object:nil];
        
        _city = [UserClient sharedUserClient].city_name;
        
        
        [self hiddenHUD];
    }
    
}




-(void)bulidView {
    
        _course = [[CourseTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-148)];
    
//        _course.mj_header = [MasterTableHeaderView headerWithRefreshingBlock:^{
//        
//        
//        [self first];
//        
//    }];
        _course.mj_header = [MasterTableHeaderView addRefreshGifHeadViewWithRefreshBlock:^{
            
            [self first];
            
        }];
    
        _course.mj_footer = [MasterTableFooterView footerWithRefreshingBlock:^{
        
        
        [self requestRemoteDataSignalWithPage:self.curPage +=1 withCategoryId:self.categoryId withOrder_type:nil withSelect_type:nil andPage_size:self.pageSize];
        
    }];
 
    
    [self.view addSubview:_course];
    
//    [self layouUI];
}



-(void)layouUI {
    
    [_course mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(104);
        
        make.left.right.equalTo(self);
        
        make.bottom.equalTo(self).offset(-44);
        
    }];
    
    
}





- (void)requestRemoteDataSignalWithPage:(NSUInteger)page withCategoryId:(NSString *)categoryId withOrder_type:(NSString*)order_type withSelect_type:(NSString*)select_type andPage_size:(NSString*)pageSize
{
    RACSignal *fetchSignal = [[HttpManagerCenter sharedHttpManager] getCategoryList:categoryId order_type:order_type select_type:select_type page:[NSString stringWithFormat:@"%lu",(unsigned long)page] page_size:pageSize resultClass:[CourseListModel class]];
    //    return fetchSignal;
    @weakify(self)
    [fetchSignal subscribeNext:^(BaseModel *model) {
        @strongify(self)
        if (model.code==200) {
            
            //            self.model = model.data;
        
            
            _course.model = model.data;
            CourseListModel * course = model.data;
            
            if (course.course_list.count == 0) {
                
                
                [self showHUDWithString:@"没有更多数据"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self hiddenHUD];
                    
                });
                
            }
            
            
        }else{
            
        }
    } completed:^{
        
        
        [_course reloadData];
        //
        [_course.mj_footer endRefreshing];
        
        [_course.mj_header endRefreshing];
        
        [self hiddenHUD];
        
    }];
    
    
    
}

- (void)first
{
    [self showHUDWithString:@"加载中。。"];
    
    [_course.courseArr removeAllObjects];
    
    self.curPage = 1;
    [_course.mj_footer resetNoMoreData];
    //
    [self requestRemoteDataSignalWithPage:self.curPage withCategoryId:self.categoryId withOrder_type:self.orderId withSelect_type:self.selectId andPage_size:self.pageSize];
    
    [_course reloadData];
    
    [_course.mj_header endRefreshing];
    
}





@end
