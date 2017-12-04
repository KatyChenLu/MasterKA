//
//  ShopAllViewController.m
//  MasterKA
//
//  Created by 余伟 on 16/9/26.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "ShopAllViewController.h"
#import "ShopAllTable.h"
#import "CourseListModel.h"
#import "MasterTableHeaderView.h"
#import "MasterTableFooterView.h"

@interface ShopAllViewController ()
@property(nonatomic , assign)NSInteger curPage;

@property(nonatomic ,copy)NSString * pageSize;

@end

@implementation ShopAllViewController
{
    ShopAllTable * _allTable;
    
}
- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshShopView) name:@"refreshShopView" object:nil];
    
    self.orderID = nil;
    self.selectID = nil;
    self.curPage = 1;
    self.categoryId = @"0";
    
    self.pageSize = @"10";
    
    _allTable = [[ShopAllTable alloc]initWithFrame:CGRectMake(0, 0, self.view.width, ScreenHeight-49-64)];
    
    [self.view addSubview:_allTable];
    
    
    
    _allTable.mj_header = [MasterTableHeaderView addRefreshGifHeadViewWithRefreshBlock:^{
        
        [self first];
        
    }];
    
    _allTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self requestRemoteDataSignalWithPage:self.curPage +=1 withCategoryId:self.categoryId withOrder_type:self.orderID  withSelect_type:nil andPage_size:self.pageSize];
        
    }];
    
    
    @weakify(self);
    [_allTable setJumpH5:^(NSString *pfurl) {
       
        @strongify(self);
        
        [self pushViewControllerWithUrl:pfurl];
        
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        [self requestRemoteDataSignalWithPage:self.curPage withCategoryId:self.categoryId withOrder_type:nil withSelect_type:nil andPage_size:self.pageSize];
    });
    _allTable.estimatedRowHeight = 0;
    _allTable.estimatedSectionFooterHeight = 0;
    _allTable.estimatedSectionHeaderHeight = 0;
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
    
    RACSignal *fetchSignal = [[HttpManagerCenter sharedHttpManager] getCategoryList:categoryId order_type:order_type select_type:select_type page:[NSString stringWithFormat:@"%lu",(unsigned long)page] page_size:pageSize resultClass:[CourseListModel class]];//
    //    return fetchSignal;
    @weakify(self)
    [fetchSignal subscribeNext:^(BaseModel *model) {
        @strongify(self)
        if (model.code==200) {
            
            
            NSLog(@"%@", select_type);
            
            CourseListModel * course = model.data;
            
            _allTable.itemModel = course.item_list;
            
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
//       
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
    
    [self requestRemoteDataSignalWithPage:self.curPage withCategoryId:self.categoryId withOrder_type:self.orderID withSelect_type:self.selectID andPage_size:self.pageSize];

    
}
- (void)refreshShopView {
    [_allTable.mj_header beginRefreshing];
    
    self.curPage = 1;
    
    [self requestRemoteDataSignalWithPage:self.curPage withCategoryId:self.categoryId withOrder_type:self.orderID withSelect_type:self.selectID andPage_size:self.pageSize];
}
-(void)dealloc {
      [[NSNotificationCenter  defaultCenter] removeObserver:self  name:@"refreshShopView" object:nil];
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
