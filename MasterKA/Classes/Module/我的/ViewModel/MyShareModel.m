//
//  MyShareModel.m
//  MasterKA
//
//  Created by hyu on 16/5/4.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MyShareModel.h"
//#import "UserShareListCell.h"
//#import "MasterShareTableViewCell.h"
@interface MyShareModel ()
@property (nonatomic,strong)MasterShareListModel *shareList;
@property (nonatomic,strong, readwrite)RACCommand *shareCommand;
@property (nonatomic,strong, readwrite)RACCommand *masterShareCommand;


@end
@implementation MyShareModel
- (void)initialize
{
    [super initialize];
    //    [[self.requestRemoteDataCommand execute:nil] subscribeNext:^(id x) {
    //        NSLog(@"======111 ==== %@",x);
    //    }];
    @weakify(self);
    [self.didSelectCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *model) {
        @strongify(self)
        NSString * url = [NSString stringWithFormat:@"%@?shareId=%@",URL_MasterShareDetail,model[@"share_id"]];
        if ([model[@"master"] isEqualToString:@"user"]) {
            url = [NSString stringWithFormat:@"%@?shareId=%@",URL_UserShareDetail,model[@"share_id"]];
        }
        [self.viewController pushViewControllerWithUrl:url];
    }];
  
    self.shareCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSArray *data) {
        @strongify(self)
        if ([self.viewController doLogin]) {
            [[[HttpManagerCenter sharedHttpManager] removeUserShare:data[0] resultClass:nil] subscribeNext:^(BaseModel *model){
                @strongify(self);
                if(model.code ==200){
                    [self.viewController hiddenHUDWithString:model.message error:NO];
                    NSMutableArray * temp =[[NSMutableArray alloc]initWithArray:self.dataSource[0]];
                    
                    NSIndexPath * index = data[1];
                    [temp removeObjectAtIndex:index.row];
                    
                    
                    
                    self.dataSource=@[temp];
                    
                    [self.mTableView reloadData];
                }else{
                    [self showRequestErrorMessage:model];
                }
            }];
            
            
        }
        return [RACSignal empty];
    }];
    self.masterShareCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSArray *data) {
        @strongify(self)
        if ([self.viewController doLogin]) {
            [[[HttpManagerCenter sharedHttpManager] removeMasterShare:data[0] resultClass:nil] subscribeNext:^(BaseModel *model){
                @strongify(self);
                if(model.code ==200){
                    [self.viewController hiddenHUDWithString:model.message error:NO];
                    NSMutableArray * temp =[[NSMutableArray alloc]initWithArray:self.dataSource[0]];
                    
                    NSIndexPath * index = data[1];
                    [temp removeObjectAtIndex:index.row];
                    
                    
                    
                    self.dataSource=@[temp];
                    
                    [self.mTableView reloadData];
                }else{
                    [self showRequestErrorMessage:model];
                }
            }];
            
            
        }
        return [RACSignal empty];
    }];
    
}

- (void)bindTableView:(UITableView *)tableView
{
    [super bindTableView:tableView];
    self.cellReuseIdentifier = @"UserShareListCell";
    [self.mTableView registerCellWithReuseIdentifier:@"UserShareListCell"];
    [self.mTableView registerCellWithReuseIdentifier:@"MasterShareTableViewCell"];
    self.shouldMoreToRefresh = YES;
    self.shouldPullToRefresh = YES;
    self.pageSize = @(10);
}
- (RACSignal*)requestRemoteDataSignalWithPage:(NSUInteger)page
{
    RACSignal *fetchSignal;
    if(self.couse_id){
        fetchSignal=[self.httpService getCourseShareBycourseId:self.couse_id page:page pageSize:self.pageSize.integerValue resultClass:nil];
    }else{
        fetchSignal = [self.httpService getMyShare:page pageSize:self.pageSize.integerValue resultClass:nil];
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
//- (void)configureCell:(MyShareCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(NSDictionary*)object
//{
//    //    [cell bindViewModel:[self.info objectAtIndex:indexPath.row]];
//    [cell showMyShare:[self.info objectAtIndex:indexPath.row]];
//}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(NSDictionary *)object
{
//    if ([[[self.info objectAtIndex:indexPath.row] objectForKey:@"master"] isEqual:@"user"]) {
//        UserShareListCell *shareCell = (UserShareListCell*)cell;
//        shareCell.shareCommand = self.shareCommand;
//        [shareCell showMyShare:object WithIndex:indexPath];
//    }else{
//        MasterShareTableViewCell *shareCell = (MasterShareTableViewCell*)cell;
//        shareCell.contentLabel.text = object[@"content"];
//        shareCell.nikeNameLabel.text = object[@"nikename"];
//        shareCell.titleLabel.text = object[@"title"];
//        if (object [@"tag_name"] && ![object[@"tag_name"] isEmpty]) {
//            [shareCell.tagButton setTitle:object[@"tag_name"] forState:UIControlStateNormal];
//        }else{
//            shareCell.tagButton.hidden = YES;
//        }
//        [shareCell.likeButton setTitle:object[@"like_count"] forState:UIControlStateNormal];
//        [shareCell.browseButton setTitle:object[@"browse_count"] forState:UIControlStateNormal];
//        
//        [shareCell.userHeadView setImageWithURLString:object[@"img_top"]];
//        [shareCell.coverView setImageWithURLString:object[@"cover"]];
//        shareCell.masterShareCommand = self.masterShareCommand;
//        [shareCell showMyMasterShare:object WithIndex:indexPath];
//        
//        
////        [shareCell.tagButton addTarget:self action:@selector(tagButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        }
}
- (NSString*)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",[[self.info objectAtIndex:indexPath.row] objectForKey:@"master"]);
    if ([[[self.info objectAtIndex:indexPath.row] objectForKey:@"master"] isEqual:@"user"]) {
        return self.cellReuseIdentifier;
    }else{
        return @"MasterShareTableViewCell";
    }
}
@end
