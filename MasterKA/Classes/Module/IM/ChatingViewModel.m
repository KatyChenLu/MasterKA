//
//  ChatingViewModel.m
//  MasterKA
//
//  Created by jinghao on 16/5/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "ChatingViewModel.h"
#import "EMChatViewCell.h"
#import "EMChatTimeCell.h"

@interface ChatingViewModel ()
@property (nonatomic,strong)NSString *tag;
@property (nonatomic,strong)NSArray *messgeList;
@property (nonatomic,strong,readwrite)RACCommand *sendMessageCommand;
@property (nonatomic,strong)id releaseResult;

@end

@implementation ChatingViewModel

- (void)initialize
{
    [super initialize];
    self.tag = @"1";
    @weakify(self);
    [RACObserve(self, otherUserid) subscribeNext:^(NSString *x) {
        @strongify(self)
        if(x.length && x.length>0){
            [self first];
        }
    }];
    
    RAC(self,releaseResult) = [self.sendMessageCommand.executionSignals.switchToLatest map:^id(BaseModel *model) {
        @strongify(self)
        if (model.code==200) {
//            [self.viewController hiddenHUDWithString:@"发布成功" error:NO];
            [self.viewController hiddenHUD];
            [self next];
        }else{
//            [self.viewController hiddenHUDWithString:model.message error:YES];
            [self showRequestErrorMessage:model];
        }
        return model;
    }];
    
    [self.sendMessageCommand.executing subscribeNext:^(NSNumber *x) {
        @strongify(self)
        if (x.boolValue) {
            [self.viewController showHUDWithString:@"发送中..."];
        }
    }];
    
    RAC(self,messgeList) = [self.requestRemoteDataCommand.executionSignals.switchToLatest map:^id(id value) {
        NSLog(@"======== %@",value);
//        if ([self.dataSource count]) {
//            [self.mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataSource count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        }
        
        return value;
    }];
    
    
    [[[RACObserve(self, messgeList) filter:^BOOL(NSArray* messgeList) {
        return  (messgeList !=nil && [messgeList isKindOfClass:[NSArray class]]);
    }] deliverOnMainThread] subscribeNext:^(NSArray* list) {
        @strongify(self)
        NSArray *viewModels = [NSArray array];
        if([self.tag isEqualToString:@"1"]){//第一次加载
            viewModels = [list.rac_sequence map:^(NSDictionary *event) {
                MessageModel *viewModel = [[MessageModel alloc] init];
                [viewModel setDictData:event];
                return viewModel;
            }].array;
        }else if([self.tag isEqualToString:@"3"]){//获取新数据
            viewModels = [[list.rac_sequence
                           map:^(NSDictionary *event) {
                               MessageModel *viewModel = [[MessageModel alloc] init];
                               [viewModel setDictData:event];
                               return viewModel;
                           }]
                          concat:[self.dataSource.lastObject rac_sequence]].array;
        }else if([self.tag isEqualToString:@"2"]){//获取旧数据
            viewModels = [[self.dataSource.lastObject rac_sequence] concat:[list.rac_sequence map:^id(NSDictionary *event) {
                MessageModel *viewModel = [[MessageModel alloc] init];
                [viewModel setDictData:event];
                return viewModel;
            }]].array;
        }
        self.dataSource = @[viewModels];
        [self.mTableView reloadData];
    }];
}

- (void)bindTableView:(UITableView *)tableView
{
    [super bindTableView:tableView];
//    self.shouldMoreToRefresh = YES;
    self.shouldPullToRefresh = YES;
}

- (void)first
{
    self.tag = @"3";
    if (self.dataSource.count>0) {
        NSArray *array = self.dataSource[0];
        if (array.count>0) {
            self.currentTime = ((MessageModel*)array.firstObject).timeString;
        }
    }
    [super first];
}

- (void)next{
    self.tag = @"2";
    if (self.dataSource.count>0) {
        NSArray *array = self.dataSource[0];
        if (array.count>0) {
            self.currentTime = ((MessageModel*)array.lastObject).timeString;
        }
    }
    [super next];
}
- (RACCommand*)sendMessageCommand
{
    if (!_sendMessageCommand) {
        @weakify(self);
        _sendMessageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            RACSignal *coverSignal = nil;
            if([input isKindOfClass:[UIImage class]]){
                coverSignal = [self.httpService uploadImageOne:[input toUploadString] resultClass:nil];
            }
            if(coverSignal){
                RACSignal *signal = [RACSignal combineLatest:@[coverSignal]];
                signal = [[signal map:^id(RACTuple *tuple) {
                    @strongify(self);
                    BaseModel *firstModel = tuple.first;
                    NSString *coverUrl = nil;
                    if (firstModel.code==200) {
                        coverUrl = firstModel.data[@"url"];
                    }
                    return [self.httpService sendIMMessage:coverUrl toUserid:self.otherUserid type:@"2" resultClass:nil];
                }] switchToLatest];
                return [[signal collect] map:^id(NSArray *value) {
                    return [value firstObject];
                }];
            }else{
                return [[[self.httpService sendIMMessage:input toUserid:self.otherUserid type:@"1" resultClass:nil]collect] map:^id(id value) {
                    return [value firstObject];
                }];
            }
        }];
    }
    return _sendMessageCommand;
}

- (RACSignal*)requestRemoteDataSignalWithPage:(NSUInteger)page
{
    if (self.currentTime == nil) {
        self.tag = @"1";
    }
    RACSignal *fetchSignal = [self.httpService queryIMMessageListWithUserid:self.otherUserid currentTime:self.currentTime tag:self.tag pageSize:self.pageSize.integerValue resultClass:nil];
    @weakify(self);
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
        return model.data;
    }];
}

#pragma mark  --

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *obj = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        return 40;
    }
    else{
        return [EMChatViewCell tableView:tableView heightForRowAtIndexPath:indexPath withObject:(MessageModel *)obj];
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource[indexPath.section] count]) {
        id obj = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[NSString class]]) {
            EMChatTimeCell *timeCell = (EMChatTimeCell *)[tableView dequeueReusableCellWithIdentifier:@"MessageCellTime"];
            if (timeCell == nil) {
                timeCell = [[EMChatTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCellTime"];
                timeCell.backgroundColor = [UIColor clearColor];
                timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            timeCell.textLabel.text = (NSString *)obj;
            
            return timeCell;
        }
        else{
            MessageModel *model = (MessageModel *)obj;
            NSString *cellIdentifier = [EMChatViewCell cellIdentifierForMessageModel:model];
            EMChatViewCell *cell = (EMChatViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[EMChatViewCell alloc] initWithMessageModel:model reuseIdentifier:cellIdentifier];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.messageModel = model;
            return cell;
        }
    }else{
        return nil;
    }
    
}
@end
