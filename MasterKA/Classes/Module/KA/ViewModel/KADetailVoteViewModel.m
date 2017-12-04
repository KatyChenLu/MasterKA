//
//  KADetailVoteViewModel.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/22.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KADetailVoteViewModel.h"
#import "KAPreVoteTableViewCell.h"
#import "KAInVoteTableViewCell.h"
@implementation KADetailVoteViewModel
- (void)initialize {
    [super initialize];
    
    
}
- (void)bindTableView:(UITableView *)tableView {
    [super bindTableView:tableView];
    [self.mTableView registerCellWithReuseIdentifier:@"KAPreVoteTableViewCell"];
    [self.mTableView registerCellWithReuseIdentifier:@"KAInVoteTableViewCell"];
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    
    if (indexPath.section == 0) {
        KAInVoteTableViewCell *cmell = (KAInVoteTableViewCell *)cell;
        [cmell showInVote:object];
    }else{
        
        KAPreVoteTableViewCell *mcell = (KAPreVoteTableViewCell *)cell;
        mcell.KApreVoteBtn.hidden = YES;
        mcell.imvBotton.constant = 32;
        [mcell showKAPreVoteDetail:object[0]];
    }
    
}
-(NSString *)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return @"KAInVoteTableViewCell";
    }else{
          return @"KAPreVoteTableViewCell";
    }
 
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
        
            self.dataSource=@[data[0],data];
            
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
    
}
@end
