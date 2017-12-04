//
//  TableViewModel.h
//  MasterKA
//
//  Created by jinghao on 16/2/23.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseViewModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MJRefresh.h"
@interface TableViewModel : BaseViewModel<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak)UITableView *mTableView;

/// The data source of table view.
@property (nonatomic,strong)NSArray *dataSource;

/// The list of section titles to display in section index view.
@property (nonatomic,strong)NSArray *dataSection;

@property (nonatomic,strong)NSString *cellReuseIdentifier;

@property (nonatomic,copy)NSString *keywords;//查询关键字


@property (nonatomic, assign)BOOL autoShowNoMore; //detault YES

@property (nonatomic, assign)BOOL showNoMoreWithAll; //detault NO


@property (nonatomic, assign)BOOL autoShowHUD; //detault YES

@property (nonatomic, assign)BOOL autoRequestRemoteDataSignal; //detault YES

/**
 *  分页数据量
 */
@property (nonatomic, strong)NSNumber *pageSize;

/**
 *  当前页数
 */
@property (nonatomic, strong)NSNumber *curPage;

@property (nonatomic,assign)BOOL shouldPullToRefresh;

@property (nonatomic,assign)BOOL shouldMoreToRefresh;

@property (nonatomic, strong,readonly) RACCommand *didSelectCommand;

@property (nonatomic, strong, readonly) RACCommand *requestRemoteDataCommand;

- (void)bindTableView:(UITableView*)tableView;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

- (NSString*)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath;

/**
 *  开始请求
 */
- (void)first;

/**
 *  下一页
 */
- (void)next;

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page;
@end
