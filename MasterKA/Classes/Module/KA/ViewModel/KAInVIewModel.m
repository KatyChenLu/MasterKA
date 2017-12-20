//
//  KAInVIewModel.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/22.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAInVIewModel.h"

#import "KAInVoteTableViewCell.h"
#import "KADetailVoteViewController.h"
@implementation KAInVIewModel
- (void)initialize {
    [super initialize];
    
    
}
- (void)bindTableView:(UITableView *)tableView {
    [super bindTableView:tableView];
    [self.mTableView registerCellWithReuseIdentifier:@"KAInVoteTableViewCell"];
    self.shouldMoreToRefresh = YES;
    self.shouldPullToRefresh = YES;
    self.pageSize = @(10);
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    KAInVoteTableViewCell *mcell = (KAInVoteTableViewCell *)cell;
    
    [mcell showInVote:object];
}

-(NSString *)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath {
    return @"KAInVoteTableViewCell";
}
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    RACSignal *fetchSignal = [self.httpService mineVoteListsPage:[NSString stringWithFormat:@"%lu",(unsigned long)page] pageSize:@"10" resultClass:nil];
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
                    self.dataSource = @[ array ];
                    self.info=array;
                }
                [self.mTableView reloadData];
                
            }
            
        }else{
           
            [self showRequestErrorMessage:model];
        }
        
        return array;
        
    }];
    
}

#pragma mark --
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSource[indexPath.section][indexPath.row];
    KADetailVoteViewController *detailVoteVC = [[KADetailVoteViewController alloc] init];
    detailVoteVC.vote_id =  dic[@"vote_id"];
    [self.viewController.navigationController pushViewController:detailVoteVC animated:YES];
}
@end
