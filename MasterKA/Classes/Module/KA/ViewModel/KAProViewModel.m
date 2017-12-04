//
//  KAProViewModel.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/21.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAProViewModel.h"
#import "KAPreVoteTableViewCell.h"

@interface KAProViewModel ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *info;
@property (nonatomic, strong)NSMutableArray *nomorArr;

@end

@implementation KAProViewModel
- (void)initialize {
    [super initialize];
    self.nomorArr = [NSMutableArray array];
    
}
- (void)bindTableView:(UITableView *)tableView {
    [super bindTableView:tableView];
    [self.mTableView registerCellWithReuseIdentifier:@"KAPreVoteTableViewCell"];
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
        [self.nomorArr removeLastObject];
        self.selectVoteArr = self.nomorArr;
    }];
    [mcell showKAPreVoteDetail:object[0]];
}

-(NSString *)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath {
    return @"KAPreVoteTableViewCell";
}
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    RACSignal *fetchSignal = [self.httpService getVoteCartListsPage:[NSString stringWithFormat:@"%lu",(unsigned long)page] pageSize:@"10" resultClass:nil];
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
            self.info = data;
            self.dataSource = data;
            self.selectVoteArr = [NSMutableArray arrayWithArray:data];
            self.nomorArr = self.selectVoteArr;
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
            
            [self.nomorArr removeLastObject];
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
