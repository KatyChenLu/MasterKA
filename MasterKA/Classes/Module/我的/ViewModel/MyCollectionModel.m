//
//  MyCollectionModel.m
//  MasterKA
//
//  Created by hyu on 16/5/10.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MyCollectionModel.h"
#import "CourseTableViewCell.h"
#import "GoodsListCellViewMode.h"
#import "CourseListModel.h"
#import "GoodDetailViewController.h"
@implementation MyCollectionModel
- (void)initialize
{
    [super initialize];
    //    [[self.requestRemoteDataCommand execute:nil] subscribeNext:^(id x) {
    //        NSLog(@"======111 ==== %@",x);
    //    }];
    
}

- (void)bindTableView:(UITableView *)tableView
{
    [super bindTableView:tableView];
    self.cellReuseIdentifier = @"CourseTableViewCell";
    [self.mTableView registerCellWithReuseIdentifier:@"CourseTableViewCell"];
    self.shouldMoreToRefresh = YES;
    self.shouldPullToRefresh = YES;
    self.pageSize = @(10);
}

- (RACSignal*)requestRemoteDataSignalWithPage:(NSUInteger)page
{
    RACSignal *fetchSignal = [self.httpService getCollects:page pageSize:self.pageSize.integerValue resultClass:[CourseModel class]];
    //    return fetchSignal;
    @weakify(self);
    return [[[fetchSignal collect] doNext:^(id x) {
        NSLog(@"===== x %@",x);
        @strongify(self);
        if(self.mTableView.mj_footer.isRefreshing ){
            [self.mTableView.mj_footer endRefreshing];
        }
        if (self.mTableView.mj_header.isRefreshing) {
            [self.mTableView.mj_header endRefreshing];
        }
        
    }] map:^id(NSArray *responses) {
        NSLog(@"===== value  %@",responses);
        @strongify(self);
        BaseModel *model = responses.firstObject;
        NSArray * array = [NSArray new];
        if (model.code==200) {
            if (![model.data  isEqual:@""]) array = model.data;
            if(array && array.count){
                if([self.curPage intValue] > 1){
                    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithArray:self.dataSource[0]];
                    [indexPaths addObjectsFromArray:array];
                    
                    self.dataSource = @[ indexPaths ];
                    self.info=indexPaths;
                }else{
                    //                    [self.dbService deleteClass:[BaseModel class]];
                    self.dataSource = @[ array ];
                    self.info=array;
                }
                [self.mTableView reloadData];
                
                //                [self.dbService deleteClass:array];
                //                [self.dbService insertModelArray:array];
                
            }
            
            
        }else{
//            [self.viewController hiddenHUDWithString:model.message error:NO];
            [self showRequestErrorMessage:model];
        }
        
        return array;
        
    }];
}
- (void)configureCell:(CourseTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
    CourseTableViewCell *mcell = (CourseTableViewCell*)cell;
    mcell.model = object;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Goods" bundle:[NSBundle mainBundle]];
    GoodDetailViewController *myView = [story instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
    CourseModel *mode = self.dataSource[0][indexPath.row];
//    myView.params = @{@"courseId":mode.course_id,@"coverStr":mode.cover} ;
    [self.viewController.navigationController pushViewController:myView animated:YES];
    
    
}
@end
