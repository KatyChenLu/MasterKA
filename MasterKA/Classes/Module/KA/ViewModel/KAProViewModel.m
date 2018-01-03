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
    self.selectVoteArr = self.nomorArr ;
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addVoteBtnChange:) name:@"addVote" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelVoteBtnChange:) name:@"cancelVote" object:nil];
}
- (void)cancelVoteBtnChange:(NSNotification *)notify {
    NSDictionary * notifyDic = [notify object];
    
    if ([notifyDic[@"isDetail2Vote"] isEqualToString:@"1"]) {
        for (NSDictionary *infoDic in self.info) {
            if([infoDic[@"ka_course_id"] isEqualToString:notifyDic[@"ka_course_id"]]){
                
                for (NSString *selectID in self.nomorArr) {
                    if ([infoDic[@"ka_course_id"] isEqualToString:selectID]) {
                        [self.nomorArr removeObject:selectID];
                    }
                }
                
                self.selectVoteArr = self.nomorArr;
                
                [self.info removeObject:infoDic];
                self.dataSource=@[self.info];
                [self.mTableView reloadData];
                //            [self.mTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
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
    NSMutableDictionary *dataDic = object;
    [dataDic setValue:@"0" forKey:@"isSelect"];
    for (NSString *kaid in self.selectVoteArr) {
        if ([kaid isEqualToString:object[@"ka_course_id"]]) {
            [dataDic setValue:@"1" forKey:@"isSelect"];
        }
    }
    [mcell setKaProVoteDic:dataDic];
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
                    self.dataSource = @[model.data];
                    self.info = self.dataSource[0];
                }else {
                    
                    self.dataSource = @[];
                }
            }
            [self.mTableView reloadData];
            
        }else{
            
            [self showRequestErrorMessage:model];
        }
        
        return self.dataSource;
    }];
    
}

#pragma mark --
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *votePeopleData =  self.dataSource[indexPath.section][indexPath.row];
    
    KAPreVoteTableViewCell *cell = [self.mTableView cellForRowAtIndexPath:indexPath];
    
    cell.KApreVoteBtn.selected = !cell.KApreVoteBtn.selected;
    if (cell.KApreVoteBtn.isSelected) {
        cell.isVoteImg.image = [UIImage imageNamed:@"选择"];
        [self.nomorArr addObject:votePeopleData[@"ka_course_id"]];
        self.selectVoteArr = self.nomorArr;
    }else{
        cell.isVoteImg.image = [UIImage imageNamed:@"未选择"];
        [self.nomorArr removeObject:votePeopleData[@"ka_course_id"]];
        self.selectVoteArr = self.nomorArr;
    }
}
//设cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
    
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        KAPreVoteTableViewCell *cell = [self.mTableView cellForRowAtIndexPath:indexPath];
        
        [self.viewController deleteVoteActionWithKaCourseId:cell.ka_course_id];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelVote" object:@{@"ka_course_id":cell.ka_course_id}];
        
        if (cell.KApreVoteBtn.isSelected) {
            for (NSString *selectID in self.selectVoteArr) {
                if ([cell.ka_course_id isEqualToString:selectID]) {
                    [self.nomorArr removeObject:selectID];
                    break;
                }
            }
            
            
        }
        self.selectVoteArr = self.nomorArr;
        [self.info removeObjectAtIndex:indexPath.row];
        self.dataSource=@[self.info];
        
        [self.mTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}
@end
