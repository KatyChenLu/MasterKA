//
//  KAPlaceViewModel.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/27.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAPlaceViewModel.h"
//#import "KAPlaceTableViewCell.h"
#import "KAPlaceAndMomentCell.h"
#import "KAPlaceDetailViewController.h"

@implementation KAPlaceViewModel
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

    [mcell showPlaces:object];
}

-(NSString *)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath {
    return @"KAPlaceAndMomentCell";
}
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    RACSignal *fetchSignal = [self.httpService queryKAFieldListPage:[NSString stringWithFormat:@"%lu",(unsigned long)page] pageSize:@"10" resultClass:nil];
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
   
    NSDictionary *dic = self.dataSource[indexPath.section][indexPath.row];
    
    KAPlaceDetailViewController *placeDetailVC = [[KAPlaceDetailViewController alloc] init];
    placeDetailVC.params = @{@"field_id":dic[@"field_id"]};
    [self.viewController pushViewController:placeDetailVC animated:YES];
}
@end
