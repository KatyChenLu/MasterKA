//
//  SelectDetailModel.m
//  MasterKA
//
//  Created by hyu on 16/5/18.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "SelectDetailModel.h"
#import "SelectDetailViewCell.h"
@implementation SelectDetailModel
- (void)initialize
{
    [super initialize];
    //    [[self.requestRemoteDataCommand execute:nil] subscribeNext:^(id x) {
    //        NSLog(@"======111 ==== %@",x);
    //    }];
    @weakify(self);
    [[RACObserve(self, course_store) filter:^BOOL(NSArray* array) {
        return ( array.count>0);
    }] subscribeNext:^(id x) {
        @strongify(self);
        [self showStores];
    }];

    
}
-(void)showStores{
    self.dataSource=@[self.course_store];
    [self.mTableView reloadData];
}
- (void)bindTableView:(UITableView *)tableView
{
    [super bindTableView:tableView];
    self.cellReuseIdentifier = @"SelectDetailViewCell";
    [self.mTableView registerCellWithReuseIdentifier:@"SelectDetailViewCell"];
}


- (void)configureCell:(SelectDetailViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(NSDictionary*)object
{
    if(object.count==3){
        [cell showChoice:object ByIdentifier :@"store"];
    }else{
        [cell showChoice:object ByIdentifier :@"course_cfg"];
    }
    //    [cell bindViewModel:[self.info objectAtIndex:indexPath.row]];
//    [cell showMyFollow:[self.info objectAtIndex:indexPath.row]];
}

@end
