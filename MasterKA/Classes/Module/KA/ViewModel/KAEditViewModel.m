//
//  KAEditViewModel.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/8.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAEditViewModel.h"
#import "KAEditTableViewCell.h"
#import "KADetailViewController.h"

@interface KAEditViewModel ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *nomorArr;

@end
@implementation KAEditViewModel
- (void)initialize {
    [super initialize];
    self.nomorArr = [NSMutableArray array];
    
}
- (void)bindTableView:(UITableView *)tableView {
    [super bindTableView:tableView];
    [self.mTableView registerCellWithReuseIdentifier:@"KAEditTableViewCell"];
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    KAEditTableViewCell *mcell = (KAEditTableViewCell *)cell;
    
    [mcell showKAPreVoteDetail:object];
}

-(NSString *)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath {
    return @"KAEditTableViewCell";
}
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {

    
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        
        
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSDictionary *sDic in self.info) {
            for (int i = 0; i<self.selArr.count; i++) {
                if ([[sDic allKeys] containsObject:@"ka_course_id"]) {
                    if ([sDic[@"ka_course_id"] isEqualToString:self.selArr[i]]) {
                        [dataArr addObject:sDic];
                    }
                }
            }
        }
        
        
        self.info = dataArr;
        self.dataSource = @[dataArr];
        
        [self.mTableView reloadData];
        
        [subscriber sendNext:self.dataSource];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];

}

#pragma mark --
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *votePeopleData =  self.dataSource[indexPath.section][indexPath.row];
    
    KADetailViewController *kaDetailVC = [[KADetailViewController alloc] init];
    
    kaDetailVC.ka_course_id = votePeopleData[@"ka_course_id"];
    kaDetailVC.headViewUrl = votePeopleData[@"course_cover"];
    
    [self.viewController pushViewController:kaDetailVC animated:YES];
}

@end
