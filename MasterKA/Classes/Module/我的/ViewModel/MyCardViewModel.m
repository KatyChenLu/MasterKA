//
//  MyCardViewModel.m
//  MasterKA
//
//  Created by hyu on 16/4/29.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MyCardViewModel.h"
#import "MyCardCell.h"
#import "JiangyouCourceViewController.h"
@implementation MyCardViewModel
- (void)initialize
{
    [super initialize];
    //    [[self.requestRemoteDataCommand execute:nil] subscribeNext:^(id x) {
    //        NSLog(@"======111 ==== %@",x);
    //    }];
    @weakify(self);
    [self.didSelectCommand.executionSignals.switchToLatest subscribeNext:^(id input) {
        @strongify(self);
        UIViewController *vct = [UIViewController viewControllerWithName:@"CardPayViewController"];
        [vct setValue:input[@"cardId"] forKey:@"cardId"];
        [self.viewController pushViewController:vct animated:YES];
    }];
    
}

- (void)bindTableView:(UITableView *)tableView
{
    [super bindTableView:tableView];
    self.cellReuseIdentifier = @"MyCardCell";
    [self.mTableView registerCellWithReuseIdentifier:@"MyCardCell"];
    self.shouldMoreToRefresh = YES;
    self.shouldPullToRefresh = YES;
    self.pageSize = @(10);
}

- (RACSignal*)requestRemoteDataSignalWithPage:(NSUInteger)page
{
    RACSignal *fetchSignal = [self.httpService getMyCard:page pageSize:self.pageSize.integerValue resultClass:nil];
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
                self.info=[NSArray array];
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
            [self showRequestErrorMessage:model];
//            [self.viewController hiddenHUDWithString:model.message error:NO];
        }

        
        return array;
        
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id point = [self.dataSource[indexPath.section][indexPath.row] objectForKey:@"cardId"];

    JiangyouCourceViewController* aaa = [[JiangyouCourceViewController alloc]init];
     aaa.card_id = point;
     [self.viewController.navigationController pushViewController:aaa animated:YES];

}

- (void)configureCell:(MyCardCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(NSDictionary*)object
{
//    [cell bindViewModel:[self.info objectAtIndex:indexPath.row]];
    [cell showCard:[self.info objectAtIndex:indexPath.row]];
}

@end
