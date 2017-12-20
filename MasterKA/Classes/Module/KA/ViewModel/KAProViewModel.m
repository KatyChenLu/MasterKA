//
//  KAProViewModel.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/21.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAProViewModel.h"
#import "KAPreVoteTableViewCell.h"
#import "KADetailViewController.h"

@interface KAProViewModel ()<UITableViewDelegate,UITableViewDataSource>



@end

@implementation KAProViewModel
- (void)initialize {
    [super initialize];
    self.nomorArr = [NSMutableArray array];
    self.selectVoteArr = [NSMutableArray array];
    self.info = [NSMutableArray array];
    
}
- (void)bindTableView:(UITableView *)tableView {
    [super bindTableView:tableView];
    [self.mTableView registerCellWithReuseIdentifier:@"KAPreVoteTableViewCell"];
    self.shouldMoreToRefresh = YES;
    self.shouldPullToRefresh = YES;
    self.pageSize = @(10);
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    KAPreVoteTableViewCell *mcell = (KAPreVoteTableViewCell *)cell;
    mcell.KApreVoteBtn.hidden = self.isHideSelect;
    @weakify(self);
    [mcell setSelectClick:^(NSString *kaid) {
        @strongify(self);
        [self.nomorArr addObject:kaid];
        self.selectVoteArr = self.nomorArr;
    }];
    [mcell setDisselectClick:^(NSString *kaid) {
        @strongify(self);
        
        [self.nomorArr removeObject:kaid];
        self.selectVoteArr = self.nomorArr;
    }];
    [mcell setKaProVoteDic:object];
}

-(NSString *)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath {
    return @"KAPreVoteTableViewCell";
}
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    RACSignal *fetchSignal = [self.httpService getVoteCartListsPage:[NSString stringWithFormat:@"%lu",(unsigned long)page] pageSize:@"10" resultClass:nil];
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
        NSArray * array = [NSArray new];
        if (model.code==200) {
            if (![model.data  isEqual:@""]) array = model.data;
         
                if([self.curPage intValue] > 1){
                    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithArray:self.dataSource[0]];
                    [indexPaths addObjectsFromArray:array];
                    
                    self.dataSource = @[ indexPaths ];
                    self.info = self.dataSource[0];
                }else{
                                if (![model.data isEqual:[NSNull null]]) {
//                                    for (NSDictionary *dataDic in model.data) {
//                                        [self.nomorArr addObject:dataDic[@"ka_course_id"]];
//                                    }
                                    self.dataSource = @[model.data];
                                    self.info = self.dataSource[0];
                                }else {
                    
                                    self.dataSource = @[];
                                }
                    
                    
                                self.selectVoteArr = self.nomorArr ;
                    
                }
                [self.mTableView reloadData];
                
        
            
        }else{
            
            [self showRequestErrorMessage:model];
        }
        
        return self.dataSource;
//        if (model.code==200) {
//
//            self.info = model.data;
//
//
//            if (![model.data isEqual:[NSNull null]]) {
//                for (NSDictionary *dataDic in model.data) {
//                    [self.nomorArr addObject:dataDic[@"ka_course_id"]];
//                }
//                self.dataSource = @[model.data];
//            }else {
//
//                self.dataSource = @[];
//            }
//
//
//            self.selectVoteArr = self.nomorArr ;
//            [self.mTableView reloadData];
//
//        }
//        return self.dataSource;
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
//设cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [tableView setEditing:YES animated:YES];
    return UITableViewCellEditingStyleDelete;
    
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.info removeObjectAtIndex:indexPath.row];
        self.dataSource=@[self.info];
        
        [self.mTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        KAPreVoteTableViewCell *cell = [self.mTableView cellForRowAtIndexPath:indexPath];
        if (cell.KApreVoteBtn.isSelected) {
            for (NSString *selectID in self.nomorArr) {
                if ([cell.ka_course_id isEqualToString:selectID]) {
                    [self.nomorArr removeObject:selectID];
                }
            }
            
            self.selectVoteArr = self.nomorArr;
        }
    }
   
}
//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//
//    //添加一个删除按钮
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//
//    }];
//
////    //添加一个置顶按钮
////    UITableViewRowAction *topAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
////
////    }];
////    topAction.backgroundColor = [UIColor blueColor];
////
////    //添加一个编辑按钮
////    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"修改" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
////
////    }];
////    editAction.backgroundColor = [UIColor greenColor];
//
//    return @[deleteAction];
//
//}
@end
