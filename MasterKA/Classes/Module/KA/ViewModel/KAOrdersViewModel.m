//
//  KAOrdersViewModel.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/28.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAOrdersViewModel.h"
#import "KAPreVoteTableViewCell.h"
#import "KAOrderDetailViewController.h"
@implementation KAOrdersViewModel
- (void)initialize {
    [super initialize];
    
    
}
- (void)bindTableView:(UITableView *)tableView {
    [super bindTableView:tableView];
    [self.mTableView registerCellWithReuseIdentifier:@"KAPreVoteTableViewCell"];
    
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
  
        
        KAPreVoteTableViewCell *mcell = (KAPreVoteTableViewCell *)cell;
        mcell.KApreVoteBtn.hidden = YES;
        mcell.imvBotton.constant = 74;
        [mcell showKAPreVoteDetail:object[0]];

    
}
-(NSString *)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath {
  
        return @"KAPreVoteTableViewCell";
 
    
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
            
            self.dataSource=@[data];
            
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
    
    KAOrderDetailViewController *vc = [[KAOrderDetailViewController alloc] init];
    [self.viewController pushViewController:vc animated:YES];
}
@end
