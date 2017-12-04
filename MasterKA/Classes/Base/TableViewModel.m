//
//  TableViewModel.m
//  MasterKA
//
//  Created by jinghao on 16/2/23.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "TableViewModel.h"
#import "BaseTableViewCell.h"
#import "MasterTableFooterView.h"
#import "MasterTableHeaderView.h"
#import "GzwTableViewLoading.h"
@interface TableViewModel ()
@property (nonatomic,strong)NSNumber *nextPageNumber;
@property (nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;
@property (nonatomic, strong,readwrite) RACCommand *didSelectCommand;

@end

@implementation TableViewModel

- (void)initialize {
    [super initialize];
    self.autoShowNoMore = YES;
    self.autoShowHUD = YES;
    self.pageSize =  @(10);
    self.curPage = @(1);
    self.nextPageNumber = @(1);
    self.dataSource = [NSArray new];
    self.dataSection = [NSArray new];
    self.cellReuseIdentifier = @"BaseTableViewCell";
    self.autoRequestRemoteDataSignal = YES;
    @weakify(self);
    
    [[self.didBecomeActiveSignal filter:^BOOL(id value) {
        @strongify(self);
        return self.autoRequestRemoteDataSignal;
    }] subscribeNext:^(id x) {
        @strongify(self);
        [self first];
    }];
    
    [[RACObserve(self, curPage) filter:^BOOL(id value) {
        @strongify(self);
        return (value!=nil && self.active) || !self.autoRequestRemoteDataSignal;
    }] subscribeNext:^(NSNumber *page) {
        @strongify(self);
        [self.requestRemoteDataCommand execute:page];
    }];
    
    RACSignal *keywordSignal = [[[RACObserve(self, keywords)
                                 skip:1]
                                throttle:0.5] distinctUntilChanged];
    [[keywordSignal filter:^BOOL(NSString *value) {
        @strongify(self);
        BOOL result = ![value isEmpty];
        if (!result) {
            self.dataSource = @[];
            [self.mTableView reloadData];
        }
        return result;
    }] subscribeNext:^(id x) {
        @strongify(self)
        [self first];
    }];
    
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        RACSignal *siganl = [RACSignal empty];
        if (self.viewController.callbackBlock) {
            self.viewController.callbackBlock(input);
            if (self.viewController.maskView) {
                [self.viewController dismissPopControllerWithMaskAnimated:YES];
            }else{
                [self.viewController gotoBack];
            }
        }else{
            siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [subscriber sendNext:input];
                [subscriber sendCompleted];
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }
        return siganl;
    }];

    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^(NSNumber *page) {
        @strongify(self)
        return [[self requestRemoteDataSignalWithPage:page.integerValue] takeUntil:self.rac_willDeallocSignal];
    }];

    [RACObserve(self, shouldMoreToRefresh) subscribeNext:^(NSNumber *more) {
        @strongify(self)
        if (more.boolValue) {
            self.mTableView.mj_footer = [MasterTableFooterView footerWithRefreshingBlock:^{
                @strongify(self)
                [self next];
            } ];
            self.mTableView.mj_footer.automaticallyHidden = NO;
        }else{
            self.mTableView.mj_footer =  nil;
        }
    }];
    [RACObserve(self, shouldPullToRefresh) subscribeNext:^(NSNumber *more) {
        @strongify(self)
        if (more.boolValue) {
//            self.mTableView.mj_header = [MasterTableHeaderView headerWithRefreshingBlock:^{
//                @strongify(self)
//                [self first];
//            } ];
            
            self.mTableView.mj_header = [MasterTableHeaderView addRefreshGifHeadViewWithRefreshBlock:^{
                
                @strongify(self)
                [self first];
                
            }];
        }else{
            self.mTableView.mj_header =  nil;
        }
    }];
    
    [self.requestRemoteDataCommand.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        if((self.mTableView.mj_header &&self.mTableView.mj_header.isRefreshing) || (self.mTableView.mj_footer &&self.mTableView.mj_footer.isRefreshing)){
            return ;
        }
        if (executing.boolValue) {
            self.mTableView.loading = YES;
            NSLog(@"requestRemoteDataCommand  start======%@",self);
            if(self.autoShowHUD)[self.viewController showHUDWithString:nil];
        } else {
            NSLog(@"requestRemoteDataCommand  end======%@",self);
            
            NSInteger count =0;
            if (self.dataSource.count>0) {
                if(self.showNoMoreWithAll){
                    for (NSArray* array in self.dataSource) {
                        count +=array.count;
                    }
                }else{
                    NSArray* array = self.dataSource.lastObject;
                    if ([array isKindOfClass:[NSArray class]]) {
                        count = array.count;
                    }
                }
            }
            if (count==0) {
                self.mTableView.loading = NO;
            }
            
            if(self.autoShowHUD) [self.viewController hiddenHUD];
            
            if (self.mTableView.mj_footer && self.autoShowNoMore) {
                if ((count%self.pageSize.integerValue) !=0 || count==0) {
                    [self.mTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }
    }];

}

- (void)dealloc {
    NSLog(@"===============viewModel dealloc============%@",self);
    _mTableView.dataSource = nil;
    _mTableView.delegate = nil;
}

- (void)bindTableView:(UITableView*)tableView
{
    self.mTableView = tableView;
    [self.mTableView clearDefaultStyle];
    self.mTableView.delegate= self;
    self.mTableView.dataSource = self;
    
    [self.mTableView registerClass:[BaseTableViewCell class] forCellReuseIdentifier:self.cellReuseIdentifier];
    @weakify(self);
    [self.mTableView gzwLoading:^{
        @strongify(self);
        [self.requestRemoteDataCommand execute:self.curPage];
    }];
}

- (void)first
{
    self.curPage = @1;
    [self.mTableView.mj_footer resetNoMoreData];
}

- (void)next
{
    self.curPage  = [NSNumber numberWithInteger: [self.curPage integerValue] + 1];
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page{
    return [RACSignal empty];
}

#pragma mark -- 


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {}

- (NSString*)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath
{
    return self.cellReuseIdentifier;
}
#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource ? self.dataSource.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self getReuseIdentifierWithIndexPath:indexPath] forIndexPath:indexPath];
    id object = self.dataSource[indexPath.section][indexPath.row];
    [self configureCell:cell atIndexPath:indexPath withObject:(id)object];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self);
    CGFloat height = [tableView fd_heightForCellWithIdentifier:[self getReuseIdentifierWithIndexPath:indexPath] configuration:^(id cell) {
        @strongify(self);
        id object = self.dataSource[indexPath.section][indexPath.row];
        [self configureCell:cell atIndexPath:indexPath withObject:(id)object];
    }];
    return height;
}

#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.didSelectCommand && indexPath.section<self.dataSource.count && indexPath.row< ((NSArray*)self.dataSource[indexPath.section]).count){
        id object = self.dataSource[indexPath.section][indexPath.row];
        [self.didSelectCommand execute:object];
    }
}


@end
