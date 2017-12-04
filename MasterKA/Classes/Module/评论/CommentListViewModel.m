//
//  CommentListViewModel.m
//  MasterKA
//
//  Created by jinghao on 16/4/28.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "CommentListViewModel.h"
#import "CommentTableViewCell.h"

@interface CommentListViewModel ()<CommentTableViewCellDelegate>
@property (nonatomic,strong)NSArray *commentPageList;
@property (nonatomic,strong)NSMutableDictionary *selectItemData;
@property (nonatomic,strong,readwrite)RACCommand *sendCommentCommand;

@end

@implementation CommentListViewModel

- (void)initialize{
    [super initialize];
    @weakify(self);
    [[RACObserve(self, shareId) filter:^BOOL(NSString *value) {
        return value!=nil;
    }] subscribeNext:^(id x) {
        @strongify(self);
        [self first];
    }];
    
    [[RACObserve(self, index_article_id) filter:^BOOL(NSString *value) {
        return value!=nil;
    }] subscribeNext:^(id x) {
        @strongify(self);
        [self first];
    }];

    [[RACObserve(self, sendMessageResult) filter:^BOOL(id value) {
        return value !=nil;
    }] subscribeNext:^(id x) {
        if (self.replyData) {
            [self.selectItemData[@"reply"] addObject:x];
            [self.mTableView reloadData];
        }else{
            NSMutableArray *array = [NSMutableArray new];
            [array addObject:x];
            [array addObjectsFromArray:self.dataSource.lastObject];
            self.dataSource = @[array];
            [self.mTableView reloadData];
        }
    }];
    
    self.sendCommentCommand = [[RACCommand alloc] initWithSignalBlock:^(NSString *comment) {
        @strongify(self)
        if(self.replyData){
            
            
            if (self.index_article_id && ![self.index_article_id isEqualToString:@""]) {
                
                return [[self.httpService addCommentsReplyCommentId:self.replyData[@"comment_id"] otherUserId:self.replyData[@"uid"] content:comment resultClass:nil]takeUntil:self.rac_willDeallocSignal];
            }
            
            return [[self.httpService addCommentsReply:self.isMasterShare commentId:self.replyData[@"comment_id"] otherUserId:self.replyData[@"uid"] content:comment resultClass:nil] takeUntil:self.rac_willDeallocSignal];
            
            
            
        }else{
            
            
            if (self.index_article_id && ![self.index_article_id isEqualToString:@""]) {
                
                return [[self.httpService addCommentsArticle_id:self.index_article_id content:comment resultClass:nil]takeUntil:self.rac_willDeallocSignal];
                
            }
            
            return [[self.httpService addComments:self.isMasterShare shareId:self.shareId content:comment resultClass:nil] takeUntil:self.rac_willDeallocSignal];
        }
        
      
        
        
    }];
    
    RAC(self,commentPageList) = [self.requestRemoteDataCommand.executionSignals.switchToLatest map:^id(BaseModel *model) {
        NSLog(@"======== %@",model);
        if (model.code==200) {
            return model.data;
        }
        return nil;
    }];
    
    [RACObserve(self, commentPageList) subscribeNext:^(NSArray *commentPageList) {
        @strongify(self);
        if (commentPageList) {
            if(self.curPage.integerValue==1){
                self.dataSource = @[commentPageList];
                [self.mTableView reloadData];
                [self checkOnlyOneComment];
            }else{
                
                NSArray *viewModels = [[[self.dataSource.lastObject rac_sequence]
                                        map:^(id event) {
                                            return event;
                                        }]
                                       concat:commentPageList.rac_sequence].array;

                self.dataSource = @[viewModels];
                [self.mTableView reloadData];

//                NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
//                [commentPageList enumerateObjectsUsingBlock:^(id event, NSUInteger idx, BOOL *stop) {
//                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
//                    [indexPaths addObject:indexPath];
//                }];
//                [self.mTableView beginUpdates];
//                [self.mTableView insertRowsAtIndexPaths:indexPaths.copy withRowAnimation:UITableViewRowAnimationFade];
//                [self.mTableView endUpdates];
            }
        }
    }];
    
}

- (void)bindTableView:(UITableView *)tableView
{
    [super bindTableView:tableView];
    self.cellReuseIdentifier = @"CommentTableViewCell";
    [self.mTableView registerCellWithReuseIdentifier:self.cellReuseIdentifier];
    self.shouldMoreToRefresh = YES;
    self.shouldPullToRefresh = YES;
   

}

- (void)checkOnlyOneComment{
    //如果是从个人中心进来的，进入应该直接有回复谁
    if( self.shareId && ![self.shareId isEqualToString:@""] && self.commentId && ![self.commentId isEqualToString:@""]){
        NSMutableDictionary *repley =[NSMutableDictionary new];
        [repley setObject:self.params[@"uid"] forKey:@"uid"];
        [repley setObject:self.params[@"commentId"] forKey:@"comment_id"];
        [repley setObject:self.params[@"nikename"] forKey:@"nikename"];
        self.replyData = repley;
        if(self.dataSource && self.dataSource.count > 0){
            self.selectItemData = self.dataSource[0][0];
        }
        
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
    CommentTableViewCell* commentCell = (CommentTableViewCell*)cell;
    commentCell.delegate = self;
    [commentCell setItemData:object];
    cell.tag = indexPath.row;
}

- (RACSignal*)requestRemoteDataSignalWithPage:(NSUInteger)page
{   @weakify(self);
    
    if (self.index_article_id && ![self.index_article_id isEqualToString:@""]) {
        
        RACSignal *fetchSignal = [self.httpService getComment:self.index_article_id page:[NSString stringWithFormat:@"%ld" , page] pageSize:[NSString stringWithFormat:@"%ld",self.pageSize.integerValue] resultClass:nil];
        return [[[fetchSignal collect] doNext:^(NSArray *responses) {
            @strongify(self);
            if(self.mTableView.mj_footer.isRefreshing ){
                [self.mTableView.mj_footer endRefreshing];
            }
            if (self.mTableView.mj_header.isRefreshing) {
                [self.mTableView.mj_header endRefreshing];
            }
            
        }] map:^id(NSArray *responses) {
            BaseModel *model = responses.firstObject;
            return model;
        }];

        
    }
    
    
    
    
    
    if( self.shareId && ![self.shareId isEqualToString:@""] && self.commentId && ![self.commentId isEqualToString:@""]){
        
        RACSignal *fetchSignal = [self.httpService getCommentDetail:page page_size:self.pageSize.integerValue commentId:self.commentId resultClass:nil];
        //    return fetchSignal;
        return [[[fetchSignal collect] doNext:^(NSArray *responses) {
            @strongify(self);
            if(self.mTableView.mj_footer.isRefreshing ){
                [self.mTableView.mj_footer endRefreshing];
            }
            if (self.mTableView.mj_header.isRefreshing) {
                [self.mTableView.mj_header endRefreshing];
            }
            
        }] map:^id(NSArray *responses) {
            BaseModel *model = responses.firstObject;
            return model;
        }];
        
    }else{
        RACSignal *fetchSignal = [self.httpService queryCommentList:self.isMasterShare shareId:self.shareId page:page pageSize:self.pageSize.integerValue resultClass:nil];
        //    return fetchSignal;
        return [[[fetchSignal collect] doNext:^(NSArray *responses) {
            @strongify(self);
            if(self.mTableView.mj_footer.isRefreshing ){
                [self.mTableView.mj_footer endRefreshing];
            }
            if (self.mTableView.mj_header.isRefreshing) {
                [self.mTableView.mj_header endRefreshing];
            }
            
        }] map:^id(NSArray *responses) {
            BaseModel *model = responses.firstObject;
            return model;
        }];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    if(self.replyData){
        if( self.shareId && ![self.shareId isEqualToString:@""] && self.commentId && ![self.commentId isEqualToString:@""]){
            //如果是个人中心进来，就一直不清空回复的谁
        }else{
            self.replyData = nil;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id itemData = self.dataSource[indexPath.section][indexPath.row];
    
    NSMutableDictionary *repley =[NSMutableDictionary new];
    [repley setObject:itemData[@"uid"] forKey:@"uid"];
    [repley setObject:itemData[@"comment_id"] forKey:@"comment_id"];
    [repley setObject:itemData[@"nikename"] forKey:@"nikename"];
    self.replyData = repley;
    self.selectItemData = itemData;
}


#pragma mark --

- (void)commentTableViewCell:(CommentTableViewCell*)cell replyInfo:(id)replyInfo
{
    
    NSIndexPath *cellIndex = [self.mTableView indexPathForCell:cell];
    id itemData = self.dataSource[cellIndex.section][cellIndex.row];
    NSMutableDictionary *repley =[NSMutableDictionary new];
    [repley setObject:replyInfo[@"uid"] forKey:@"uid"];
    [repley setObject:itemData[@"comment_id"] forKey:@"comment_id"];
    [repley setObject:replyInfo[@"nikename"] forKey:@"nikename"];
    [repley setObject:replyInfo[@"reply_id"] forKey:@"reply_id"];
    self.replyData = repley;
}
- (void)commentTableViewCellHeadView:(CommentTableViewCell*)cell itemData:(id)itemData
{
    id uid = [itemData objectForKey:@"uid"];
    NSString *url = [NSString stringWithFormat:@"%@?uid=%@",URL_MasterCenter,uid];
    [self.viewController pushViewControllerWithUrl:url];
}

@end
