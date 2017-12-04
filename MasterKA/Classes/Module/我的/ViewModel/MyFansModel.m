//
//  MyFansModel.m
//  MasterKA
//
//  Created by hyu on 16/4/28.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MyFansModel.h"
#import "MyFansCell.h"
@implementation MyFansModel
- (void)initialize
{
    [super initialize];
    //    [[self.requestRemoteDataCommand execute:nil] subscribeNext:^(id x) {
    //        NSLog(@"======111 ==== %@",x);
    //    }];
    
}
-(void)removeFollowAndRefresh{
    @weakify(self);
     [[[HttpManagerCenter sharedHttpManager] removeAttention:self.dataSource[0][self.removeIndex.row][@"fid"] resultClass:nil] subscribeNext:^(BaseModel *model){
         @strongify(self);
        if(model.code ==200){
            [self.viewController hiddenHUDWithString:model.message error:NO];
            [self.info removeObjectAtIndex:self.removeIndex.row];
            self.dataSource=@[self.info];
            [self.mTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.removeIndex] withRowAnimation:UITableViewRowAnimationLeft];
        }else{
            [self showRequestErrorMessage:model];
        }
    }];
}

- (void)bindTableView:(UITableView *)tableView
{
    [super bindTableView:tableView];
    self.cellReuseIdentifier = @"MyFansCell";
    [self.mTableView registerCellWithReuseIdentifier:@"MyFansCell"];
    self.shouldMoreToRefresh = YES;
    self.shouldPullToRefresh = YES;
    self.pageSize = @(10);
}

- (RACSignal*)requestRemoteDataSignalWithPage:(NSUInteger)page
{
    RACSignal *fetchSignal;
    
    
 
    
    
    
    if(self.course_id){
        fetchSignal=[self.httpService getStudents:self.course_id page:page pageSize:self.pageSize.integerValue resultClass:nil];
    }
    else if(self.share_id&&[self.master isEqualToString:@"user"])
    {
            fetchSignal=[self.httpService getUsersFans:self.share_id page:page pageSize:self.pageSize.integerValue resultClass:nil];
    
    }
    else if(self.share_id&&[self.master isEqualToString:@"master"]){
            fetchSignal=[self.httpService getMasterFans:self.share_id page:page pageSize:self.pageSize.integerValue resultClass:nil];
    
    }
    else{
        if([self.comeIdentity isEqual:@"fans"]){
            fetchSignal= [self.httpService queryMyFansByPage:page pageSize:self.pageSize.integerValue resultClass:nil];
        }else{
            fetchSignal = [self.httpService queryMyFollowsByPage:page pageSize:self.pageSize.integerValue resultClass:nil];
        }
        
    }
    
    
    if (self.index_article_id && ![self.index_article_id isEqualToString:@""]) {
        fetchSignal = [self.httpService getLikeList:self.index_article_id page:[NSString stringWithFormat:@"%ld" , page] pageSize:[NSString stringWithFormat:@"%ld" ,self.pageSize.integerValue] resultClass:nil];
        
        
        
    }
    
    //    return fetchSignal;
    @weakify(self);
    return [[[fetchSignal collect] doNext:^(id x) {
        NSLog(@"===== x %@",x);
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
        NSMutableArray * array = [NSMutableArray new];
        if (model.code==200) {
            if (![model.data  isEqual:@""]) array = model.data;
            if(array && array.count){
                if([self.curPage intValue] > 1){
                    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithArray:self.dataSource[0]];
                    [indexPaths addObjectsFromArray:array];
                    
                    self.dataSource = @[ indexPaths ];
                     self.info=indexPaths;
                }else{
//                    [self.dbService deleteClass:[BaseModel class]];
                    self.dataSource = @[ array ];
                     self.info=array;
                }
                [self.mTableView reloadData];
                
                //                [self.dbService deleteClass:array];
//                [self.dbService insertModelArray:array];
                
            }
            
            
        }else{
            [self showRequestErrorMessage:model];
//            [self.viewController hiddenHUDWithString:model.message error:NO];
        }
        
        return array;
        
    }];
}
- (void)configureCell:(MyFansCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(NSDictionary*)object
{
//    [cell bindViewModel:[self.info objectAtIndex:indexPath.row]];
    [cell showMyfans:object identity:self.comeIdentity shareId:self.share_id];
    if([self.comeIdentity  isEqual:@"follow"]){
         [cell.removeFollow addTarget:self action:@selector(doRefuseOrder:event:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)doRefuseOrder:(id)senter event:(id)event{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.mTableView];
    self.removeIndex = [self.mTableView indexPathForRowAtPoint:currentTouchPosition];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"取消关注" message:@"确定取消关注么" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag =201;
    [alertView show];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *uid =self.dataSource[0][indexPath.row][@"uid"]?self.dataSource[0][indexPath.row][@"uid"]:self.dataSource[0][indexPath.row][@"fid"];
    NSString *url = [NSString stringWithFormat:@"%@?uid=%@",URL_MasterCenter,uid];
    [self.viewController pushViewControllerWithUrl:url];
    
    
}
#pragma mark --  UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1 && alertView.tag==201) {
        [self removeFollowAndRefresh];
    }
}
@end
