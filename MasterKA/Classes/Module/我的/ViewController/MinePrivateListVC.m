//
//  MinePrivateListVC.m
//  MasterKA
//
//  Created by xmy on 16/5/18.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MinePrivateListVC.h"
#import "MyMessageTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface MinePrivateListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger messagePage;
    NSInteger pageSize;
}
@property (nonatomic,weak)IBOutlet UITableView* mTableView;
@property (nonatomic,strong)NSMutableArray* dataSource;
@property (nonatomic,strong)MyMessageTableViewCell* systemMessageCell;
@end

static NSString* systemMsgCell = @"MyMessageTableViewCell";

@implementation MinePrivateListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.params[@"title"];
    messagePage = 1;
    pageSize = 10;
    [self.mTableView registerCellWithReuseIdentifier:systemMsgCell];
    self.systemMessageCell  = [self.mTableView dequeueReusableCellWithIdentifier:systemMsgCell];
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    
    [self.mTableView clearDefaultStyle];
    self.mTableView.backgroundColor = self.view.backgroundColor;
    
    [self headerRereshing];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_delegate rerfeshMinePrivateBall:@"MinePrivate"];
}
- (NSMutableArray*)dataSource
{   
    if (_dataSource==nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)getUserNewsList {
    
    [self showHUDWithString:@"加载中..."];
    @weakify(self);
    HttpManagerCenter *httpService = [HttpManagerCenter sharedHttpManager];
    [[httpService getPrivateNews:messagePage page_size:pageSize resultClass:nil] subscribeNext:^(BaseModel *model){
        @strongify(self);
        [self hiddenHUD];
        if (model.code==200) {
            NSArray* array = model.data;
            if (array && array.count>0) {
                if (messagePage <= 1) {
                    [self.dataSource removeAllObjects];
                }
                [self.dataSource addObjectsFromArray:array];
                [self.mTableView reloadData];
            }else{
                //            [self toastWithString:@"没有更多数据！" error:YES];
            }
        }else{
            [self showRequestErrorMessage:model];
        }
        
        
    } error:^(NSError *error) {
        [self hiddenHUD];
        
        
    } completed:^{
        //         [self hiddenHUDWithString:nil error:NO];
    }];
    
}

- (void)headerRereshing{
    messagePage = 1;
    [self getUserNewsList];
}

- (void)footerRereshing{
    messagePage ++;
    [self getUserNewsList];
}

#pragma mark -- UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height =[tableView fd_heightForCellWithIdentifier:systemMsgCell cacheByIndexPath:indexPath configuration:^(id cell) {
        MyMessageTableViewCell* replyCell = (MyMessageTableViewCell*)cell;
        [replyCell setItemData:self.dataSource[indexPath.row]];
    } ];
    return height;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    MyMessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:systemMsgCell];
    [cell setItemData:self.dataSource[indexPath.row]];
    
    cell.showCustomLineView = YES;
    
    if(indexPath.row+1 == self.dataSource.count){
        [self footerRereshing];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = self.dataSource[indexPath.row];
    
    NSString * url = [NSString stringWithFormat:@"%@?userId=%@",URL_IMChating,data[@"uid"]];
    [self pushViewControllerWithUrl:url];
}

@end
