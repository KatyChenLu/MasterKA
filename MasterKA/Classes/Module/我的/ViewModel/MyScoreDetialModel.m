//
//  MyScoreDetialModel.m
//  MasterKA
//
//  Created by hyu on 16/4/27.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MyScoreDetialModel.h"
#import "MyScoreViewController.h"
#import "MyScoreDetialcell.h"
#import "GoodDetailViewController.h"
@implementation MyScoreDetialModel
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
    self.cellReuseIdentifier =@"MyScoreDetialCell";
    [tableView registerCellWithReuseIdentifier:self.cellReuseIdentifier];
    self.shouldMoreToRefresh = YES;
    self.shouldPullToRefresh = YES;
    self.pageSize = @(10);
}

- (RACSignal*)requestRemoteDataSignalWithPage:(NSUInteger)page
{
    RACSignal *fetchSignal = [self.httpService getCourse:page pageSize:self.pageSize.integerValue resultClass:nil];
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
//        BaseModel *model = responses.firstObject;
//        NSDictionary * dic = [NSDictionary new];
//        NSMutableArray *array =[NSMutableArray array];
//        if (model.code==200) {
//            if (![model.data  isEqual:@""]) dic = model.data;
//            NSArray *detail=[dic objectForKey:@"detail"];
//            for(NSDictionary *monDic in detail){
//                NSArray *montharr=[monDic objectForKey:@"credit"];
//                for (NSDictionary * ddic in montharr) {
//                    [array addObject:ddic];
//                }
//            }
//            self.info=array;
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
                    self.dataSource = @[ array ];
                    self.info=array;
                }
                [self.mTableView reloadData];
            }
            
            
        }else{
            [self showRequestErrorMessage:model];
//            [self.viewController hiddenHUDWithString:model.message error:NO];
        }
        
        return array;
        
    }];
}

- (void)configureCell:(MyScoreDetialCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(NSDictionary*)object
{
    
    [cell showCourse:[self.info objectAtIndex:indexPath.row]];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Goods" bundle:[NSBundle mainBundle]];
    GoodDetailViewController *myView = [story instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
    NSDictionary *mode = self.dataSource[indexPath.section][indexPath.row];
    myView.params = @{@"courseId":mode[@"course_id"],@"coverStr":mode[@"cover"]} ;
    [self.viewController.navigationController pushViewController:myView animated:YES];
    
}
@end
