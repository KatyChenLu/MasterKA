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
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    KAInVoteTableViewCell *mcell = (KAInVoteTableViewCell *)cell;
    
    [mcell showInVote:object[0]];
}

-(NSString *)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath {
    return @"KAInVoteTableViewCell";
}
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    RACSignal *fetchSignal = [self.httpService getCourseDetail:@"4747" resultClass:nil];
    @weakify(self);
    return [[[fetchSignal collect] doNext:^(NSArray *pageSize) {
        @strongify(self);
        //        if(self.mTableView.mj_footer.isRefreshing ){
        //            [self.mTableView.mj_footer endRefreshing];
        //        }
        //        if (self.mTableView.mj_header.isRefreshing) {
        //            [self.mTableView.mj_header endRefreshing];
        //        }
        
    }] map:^id(NSArray *responses) {
        BaseModel *model = responses.firstObject;
        @strongify(self);
        if (model.code==200) {
            
            
            //
            NSDictionary *dic = model.data;
            //
            NSMutableArray*data =[NSMutableArray array];
            //            self.detailSection=[NSMutableArray array];
            
            //            [data addObject:[self getNameAndMoney:self.info]];
            //
            [data addObjectsFromArray:[self getDetail:model.data]];
//            self.info = data;
            self.dataSource=@[data];
//            self.selectVoteArr = [NSMutableArray arrayWithArray:data];
//            self.nomorArr = self.selectVoteArr;
            [self.mTableView reloadData];
            
        }
        return self.dataSource;
    }];
    
}
- (NSMutableArray *)getDetail:(NSDictionary *)info {
    NSMutableArray *detailArr = [NSMutableArray array];
    NSArray *arr = info[@"guess_like"];
    
    for (NSDictionary * dic in arr) {
        [detailArr addObject:@[dic]];
        //        [self.detailSection addObject:@"内容"];
    }
    return detailArr;
}
#pragma mark --
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KADetailVoteViewController *detailVoteVC = [[KADetailVoteViewController alloc] init];
    [self.viewController.navigationController pushViewController:detailVoteVC animated:YES];
}
@end
