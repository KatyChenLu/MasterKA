//
//  KAVotePeopleViewModel.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/15.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAVotePeopleViewModel.h"
#import "KAVotePeopleTableViewCell.h"

@implementation KAVotePeopleViewModel
- (void)initialize {
    [super initialize];
    //    self.nomorArr = [NSMutableArray array];
    
}
- (void)bindTableView:(UITableView *)tableView {
    [super bindTableView:tableView];
    [self.mTableView registerCellWithReuseIdentifier:@"KAVotePeopleTableViewCell"];
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    KAVotePeopleTableViewCell *mcell = (KAVotePeopleTableViewCell *)cell;
    [mcell showVotePeople:object];
    
}

-(NSString *)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath {
    return @"KAVotePeopleTableViewCell";
}
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    RACSignal *fetchSignal = [self.httpService getItemUserListsWithItemId:self.item_id Page:[NSString stringWithFormat:@"%lu",(unsigned long)page] pageSize:@"10" resultClass:nil];
    @weakify(self);
    return [[[fetchSignal collect] doNext:^(NSArray *pageSize) {
        @strongify(self);
        
        if(self.mTableView.mj_footer.isRefreshing ){
            [self.mTableView.mj_footer endRefreshing];
        }
        if (self.mTableView.mj_header.isRefreshing) {
            [self.mTableView.mj_header endRefreshing];
        }
        
    }] map:^id(NSArray *responses) {
        BaseModel *model = responses.firstObject;
        @strongify(self);
        if (model.code==200) {
            
            self.dataSource=@[model.data];
            [self.mTableView reloadData];
            
        }
        return self.dataSource;
        
        
    }];
    
}

#pragma mark --
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.dataSource[indexPath.section][indexPath.row];
    
}
@end
