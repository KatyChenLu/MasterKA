//
//  KACollectViewModel.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/15.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KACollectViewModel.h"
#import "KACollectTableViewCell.h"
#import "KADetailViewController.h"

@implementation KACollectViewModel
- (void)initialize {
    [super initialize];
    //    self.nomorArr = [NSMutableArray array];
    
}
- (void)bindTableView:(UITableView *)tableView {
    [super bindTableView:tableView];
    [self.mTableView registerCellWithReuseIdentifier:@"KACollectTableViewCell"];
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    KACollectTableViewCell *mcell = (KACollectTableViewCell *)cell;
    mcell.collectDic = object;
    
    @weakify(self);
    
    [mcell setCanceljoinClick:^(NSString *ka_course_id) {
        @strongify(self);
        [self.viewController deleteVoteActionWithKaCourseId:ka_course_id];
    }];
    
    [mcell setJoinClick:^(UIImageView *joinImgView,NSString *ka_course_id) {
        @strongify(self);
        [self.viewController addVoteActionWithJoinImgView:joinImgView KaCourseId:ka_course_id Animation:YES];
     }];
        
}

-(NSString *)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath {
    return @"KACollectTableViewCell";
}
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    RACSignal *fetchSignal = [self.httpService getLikeListsPage:[NSString stringWithFormat:@"%lu",(unsigned long)page] pageSize:@"10" resultClass:nil];
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
            self.info = model.data;
            self.dataSource=@[model.data];
            [self.mTableView reloadData];
            
        }
        return self.dataSource;
        
        
    }];
    
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

        KACollectTableViewCell *cell = [self.mTableView cellForRowAtIndexPath:indexPath];

        @weakify(self);
        [[[HttpManagerCenter sharedHttpManager] cancelLikeCource:cell.ka_course_id resultClass:nil] subscribeNext:^(BaseModel *model) {
            @strongify(self)
            [self.info removeObjectAtIndex:indexPath.row];
            self.dataSource=@[self.info];
            if (model.code==200) {
                [self.mTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.viewController toastWithString:model.message error:NO];
            }else{
                [self.viewController toastWithString:model.message error:YES];
            }
        }];
        
    }
    
}

#pragma mark --
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.dataSource[indexPath.section][indexPath.row];
    
//    KACollectTableViewCell *placeDetailVC = [[KACollectTableViewCell alloc] init];
//    placeDetailVC.params = @{@"moment_id":dic[@"moment_id"]};
//    [self.viewController pushViewController:placeDetailVC animated:YES];
    
    NSDictionary *votePeopleData =  self.dataSource[indexPath.section][indexPath.row];
    
    KADetailViewController *kaDetailVC = [[KADetailViewController alloc] init];
    
    kaDetailVC.ka_course_id = votePeopleData[@"ka_course_id"];
    kaDetailVC.headViewUrl = votePeopleData[@"course_cover"];
    
    [self.viewController pushViewController:kaDetailVC animated:YES];
}
@end
