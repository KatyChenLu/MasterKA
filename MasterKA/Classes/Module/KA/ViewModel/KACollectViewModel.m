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
#import "KACollectViewController.h"

@implementation KACollectViewModel
- (void)initialize {
    [super initialize];
        self.addVoteKAID = [NSMutableArray array];
    self.cancelVoteKAID = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addVoteBtnChange:) name:@"addVote" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelVoteBtnChange:) name:@"cancelVote" object:nil];
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(showCustomBtn) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.myTimer forMode:NSRunLoopCommonModes];
}

- (void)cancelVoteBtnChange:(NSNotification *)notify {
    NSDictionary * infoDic = [notify object];
    
    if ([self.addVoteKAID containsObject:infoDic[@"ka_course_id"]]) {
        [self.addVoteKAID removeObject:infoDic[@"ka_course_id"]];
    }
    if (![self.cancelVoteKAID containsObject:infoDic[@"ka_course_id"]]) {
        [self.cancelVoteKAID addObject:infoDic[@"ka_course_id"]];
    }
    
}
- (void)addVoteBtnChange:(NSNotification *)notify {
    NSDictionary * infoDic = [notify object];
    if ([self.cancelVoteKAID containsObject:infoDic[@"ka_course_id"]]) {
        [self.cancelVoteKAID removeObject:infoDic[@"ka_course_id"]];
    }
    if (![self.addVoteKAID containsObject:infoDic[@"ka_course_id"]]) {
        [self.addVoteKAID addObject:infoDic[@"ka_course_id"]];
    }
    
}
- (void)bindTableView:(UITableView *)tableView {
    [super bindTableView:tableView];
    [self.mTableView registerCellWithReuseIdentifier:@"KACollectTableViewCell"];
    self.shouldMoreToRefresh = YES;
    self.shouldPullToRefresh = YES;
    self.pageSize = @(10);
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    KACollectTableViewCell *mcell = (KACollectTableViewCell *)cell;
    mcell.collectDic = object;
    
    @weakify(self);
    for (NSString * addVoteStr in self.addVoteKAID) {
        if ([mcell.ka_course_id isEqualToString:addVoteStr]) {
            [mcell.collectDic setValue:@"1" forKey:@"is_vote_cart"];
            mcell.addVoteBtn.selected = YES;
            mcell.addVoteBtn.borderWidth = 1.0f;
            mcell.addVoteBtn.borderColor = RGBFromHexadecimal(0xb9b8af);
            
        }
    }
    
    for (NSString *cancelVoteStr in self.cancelVoteKAID) {
        if ([mcell.ka_course_id isEqualToString:cancelVoteStr]){
            [mcell.collectDic setValue:@"0" forKey:@"is_vote_cart"];
            mcell.addVoteBtn.selected = NO;
            mcell.addVoteBtn.borderWidth = 0.0f;
            mcell.addVoteBtn.borderColor = [UIColor clearColor];
        }
    }
    
    [mcell setCanceljoinClick:^(NSString *ka_course_id) {
        @strongify(self);
        [self.viewController deleteVoteActionWithKaCourseId:ka_course_id];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelVote" object:@{@"ka_course_id":ka_course_id}];
    }];
    
    [mcell setJoinClick:^(UIImageView *joinImgView,NSString *ka_course_id) {
        @strongify(self);
        [self.viewController addVoteActionWithJoinImgView:joinImgView KaCourseId:ka_course_id Animation:YES];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"addVote" object:@{@"ka_course_id":ka_course_id}];
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
        NSLog(@"===== value  %@",responses);
        @strongify(self);
        BaseModel *model = responses.firstObject;
        NSArray * array = [NSArray new];
        if (model.code==200) {
            if (![model.data  isEqual:@""]) array = model.data;
            if(array && array.count){
                if([self.curPage intValue] > 1){
                    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithArray:self.dataSource[0]];
                    [indexPaths addObjectsFromArray:array];
                    
                    self.dataSource = @[ indexPaths ];
                    self.info=indexPaths;
                }else{
                    self.dataSource = @[ array ];
                    self.info=array;
                }
                [self.mTableView reloadData];
                
            }
            
        }else{
            
            [self showRequestErrorMessage:model];
        }
        
        return array;
        
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
            
            
            if (model.code==200) {
              
                [self.viewController toastWithString:model.message error:NO];
            }else{
                [self.viewController toastWithString:model.message error:YES];
            }
        }];
        [self.info removeObjectAtIndex:indexPath.row];
        self.dataSource=@[self.info];
          [self.mTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
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
- (NSTimer *)myTimer {
    if (!_myTimer) {
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(showCustomBtn) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_myTimer forMode:NSRunLoopCommonModes];
    }
    return _myTimer;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.myTimer invalidate];
    self.myTimer = nil;
    [(KACollectViewController *)self.viewController showCusBtn:NO];
    self.isShowCusBtn = NO;
}
-(void)showCustomBtn{
    
    NSLog(@"szdfasdasdd---sdasdasd99999999999999999999999@-@");
    if (!self.isShowCusBtn) {
        [(KACollectViewController *)self.viewController showCusBtn:YES];
        self.isShowCusBtn = YES;
    }
    [self.myTimer invalidate];
    self.myTimer = nil;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(showCustomBtn) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.myTimer forMode:NSRunLoopCommonModes];
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addVote" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelVote" object:nil];
    [self.myTimer invalidate];
    self.myTimer = nil;
}
@end
