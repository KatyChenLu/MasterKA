//
//  KAMomentViewModel.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/6.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAMomentViewModel.h"
#import "KAPlaceAndMomentCell.h"
#import "KAMomentDetailViewController.h"

@implementation KAMomentViewModel
- (void)initialize {
    [super initialize];
    //    self.nomorArr = [NSMutableArray array];
    
}
- (void)bindTableView:(UITableView *)tableView {
    [super bindTableView:tableView];
    [self.mTableView registerCellWithReuseIdentifier:@"KAPlaceAndMomentCell"];
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    KAPlaceAndMomentCell *mcell = (KAPlaceAndMomentCell *)cell;
    
    [mcell showMoment:object];
}

-(NSString *)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath {
    return @"KAPlaceAndMomentCell";
}
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    RACSignal *fetchSignal = [self.httpService queryMomentList:[NSString stringWithFormat:@"%lu",(unsigned long)page] pageSize:@"10" resultClass:nil];
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
    
    KAMomentDetailViewController *placeDetailVC = [[KAMomentDetailViewController alloc] init];
    placeDetailVC.params = @{@"moment_id":dic[@"moment_id"]};
    [self.viewController pushViewController:placeDetailVC animated:YES];
}
@end
