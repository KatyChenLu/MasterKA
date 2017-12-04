//
//  ShopTableView.m
//  shop
//
//  Created by 余伟 on 16/8/10.
//  Copyright © 2016年 余伟. All rights reserved.
//



#define Identifier @"ShopTableViewCell"

#import "ShopTableView.h"
#import "ShopTabelCell.h"
#import "CourseTableViewCell.h"
#import "CourseListModel.h"
#import "MJRefresh.h"
#import "MasterTableHeaderView.h"
#import "MasterTableFooterView.h"
#import "MBProgressHUD.h"


//专题tableView
@interface ShopTableView()<UITableViewDataSource ,UITableViewDelegate>




//加载页数
@property(nonatomic ,assign)NSInteger  curPage;

@property(nonatomic ,copy)NSString * pageSize;


@end

@implementation ShopTableView



-(instancetype)initWithFrame:(CGRect)frame

{
    
    if (self = [super initWithFrame:frame]) {
        
     
        self.delegate = self;
        
        self.dataSource = self;
        
        self.pageSize = @"10";
        
        self.curPage = 1;
//
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
//        self.mj_header = [MasterTableHeaderView headerWithRefreshingBlock:^{
//            
//           
//            [self first];
//            
//        }];
//      
//        
//        self.mj_footer = [MasterTableFooterView footerWithRefreshingBlock:^{
//            
//           
//            [self requestRemoteDataSignalWithPage:self.curPage +=1 withCategoryId:@"-1" withOrder_type:nil withSelect_type:nil andPage_size:@"10"];
//            
//        }];
//    
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            
//            [self requestRemoteDataSignalWithPage:self.curPage withCategoryId:@"-1" withOrder_type:nil withSelect_type:nil andPage_size:self.pageSize];
//        });
//        
//        
//        
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityChange:) name:@"cityChange" object:nil];
//        
    }
    
    return  self;
}





//-(void)cityChange:(NSNotification *)notify
//{
//    
//    self.curPage = 1;
//    
//    [_sourceArr removeAllObjects];
//    
//    [self requestRemoteDataSignalWithPage:self.curPage withCategoryId:@"-1" withOrder_type:nil withSelect_type:nil andPage_size:@"10"];
//    
//    
//}





- (void)requestRemoteDataSignalWithPage:(NSUInteger)page withCategoryId:(NSString *)categoryId withOrder_type:(NSString*)order_type withSelect_type:(NSString*)select_type andPage_size:(NSString*)pageSize
{
    RACSignal *fetchSignal = [[HttpManagerCenter sharedHttpManager] getCategoryList:categoryId order_type:order_type select_type:select_type page:[NSString stringWithFormat:@"%lu",(unsigned long)page] page_size:pageSize resultClass:[CourseListModel class]];
    //    return fetchSignal;
    @weakify(self)
    [fetchSignal subscribeNext:^(BaseModel *model) {
        @strongify(self)
        if (model.code==200) {
            
            self.model = model.data;
      
//            CourseListModel * course = model.data;
            
//            if (course.subject_list.count == 0) {
//                
//                MBProgressHUD * HUD = [[MBProgressHUD alloc]init];
//                
//                HUD.mode = MBProgressHUDModeIndeterminate;
//                
//                HUD.labelText = @"没有更多的数据";
//                
//                [self addSubview:HUD];
//                
//                [HUD show:YES];
//                
//            }
          
            
        }else{
            
        }
    } completed:^{
        
        
        [self reloadData];
        

    }];
    
    
    
}



-(void)setModel:(CourseListModel*)model
{
    
    _model = model;
    
    if (_isChange) {
        
        [_sourceArr removeAllObjects];
        
        self.isChange = NO;
        
    }
    
    
    if (_sourceArr.count == 0) {
        
        _sourceArr = model.subject_list.mutableCopy;
        
    }else{
        
        [_sourceArr addObjectsFromArray:model.subject_list];
        
  
        
        
        
    }
    
    
}






#pragma UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    
    return  self.sourceArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ShopTabelCell * cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    

    
    if (!cell) {
        
        cell = [[ShopTabelCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:Identifier];
    }
    
    cell.model = self.sourceArr[indexPath.row];
    
 

    
    
    return cell;
}




#pragma UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"didSelectRowAtIndexPath");
    
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 380;
}






@end
