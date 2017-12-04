//
//  JiangyouModel.m
//  MasterKA
//
//  Created by lijiachao on 16/7/26.
//  Copyright © 2016年 jinghao. All rights reserved.
//
#import "GoodsSubListViewModel.h"
#import "CourseListModel.h"
#import "SubCourseModel.h"
#import "CourseTableViewCell.h"
#import "GoodsSubCell.h"
#import "CourseModel.h"
#import "GoodDetailViewController.h"
#import "JiangyouModel.h"

@interface JiangyouModel ()
@property (nonatomic,strong,readwrite)RACCommand *courseCommand;
@property (nonatomic,strong)NSString *orderId;
@property (nonatomic,strong)NSString *selectId;

@property (nonatomic,strong)NSString *page;
@property (nonatomic,strong)NSString *page_size;
@property (nonatomic,strong) NSArray* courseArray;
@end
@implementation JiangyouModel

- (void)initialize
{
    [super initialize];
    self.orderId = @"";
    self.selectId = @"";
    
    @weakify(self)
    RAC(self,self.courseArray) = [self.requestRemoteDataCommand.executionSignals.switchToLatest map:^id(id value) {
        NSLog(@"======== %@",value);
        return value;
    }];
    
    self.courseCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(CourseModel *model) {
        @strongify(self)
//        NSString *url = [NSString stringWithFormat:@"%@?courseId=%@",URL_GoodsDetail,model.course_id];
//        [self.viewController pushViewControllerWithUrl:url];
        return [RACSignal empty];
    }];
    
    [[[RACObserve(self, self.courseArray) filter:^BOOL(NSArray* courseListModel) {
        return  (courseListModel !=nil);
    }] deliverOnMainThread] subscribeNext:^(NSArray* courseListModel) {
        @strongify(self)
        
        NSArray *list = courseListModel;
        self.dataSource = @[list];
        [self.mTableView reloadData];
    }];
}

- (void)bindTableView:(UITableView *)tableView
{
    [super bindTableView:tableView];
    
    [tableView registerCellWithReuseIdentifier:@"CourseTableViewCell"];
    
    self.shouldMoreToRefresh = YES;
    self.shouldPullToRefresh = YES;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(self.dataSource ==nil || self.dataSource.count == 0)
    {
        return 0;
    }
    else
    {
        NSArray *array = self.dataSource[section];
        return array.count;
    }
}

- (NSString*)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath
{
    return @"CourseTableViewCell";
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
    CourseTableViewCell *mcell = (CourseTableViewCell*)cell;
    mcell.model = object;
}

- (RACSignal*)requestRemoteDataSignalWithPage:(NSUInteger)page
{
    RACSignal *fetchSignal = [self.httpService getJiangYouCardList:self.cardId page:@"1" page_size:@"10"  resultClass:[CourseModel class]];
    //    return fetchSignal;
    @weakify(self)
    return [[[fetchSignal collect] doNext:^(NSArray *responses) {
        @strongify(self)
        if(self.mTableView.mj_footer.isRefreshing ){
            [self.mTableView.mj_footer endRefreshing];
        }
        if (self.mTableView.mj_header.isRefreshing) {
            [self.mTableView.mj_header endRefreshing];
        }
        
    }] map:^id(NSArray *responses) {
        BaseModel *model = responses.firstObject;
        self.courseArray = model.data;
        return model.data;
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Goods" bundle:[NSBundle mainBundle]];
    GoodDetailViewController *myView = [story instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
    if(self.dataSource[indexPath.section] && self.dataSource[indexPath.section][indexPath.row] ){
        CourseModel *mode = self.dataSource[indexPath.section][indexPath.row];
        if([mode isKindOfClass:[CourseModel class]]){
//            myView.params = @{@"courseId":mode.course_id,@"coverStr":mode.cover} ;
            [self.viewController.navigationController pushViewController:myView animated:YES];
        }
    }
}

@end
