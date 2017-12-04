//
//  MineCommentVC.m
//  MasterKA
//
//  Created by xmy on 16/5/18.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MineCommentVC.h"
#import "MyMessageTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface MineCommentVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger messagePage;
    NSInteger pageSize;
}
@property (nonatomic,weak)IBOutlet UITableView* mTableView;
@property (nonatomic,strong)NSMutableArray* dataSource;
@property (nonatomic,strong)MyMessageTableViewCell* systemMessageCell;
@end

static NSString* systemMsgCell = @"MyMessageTableViewCell";

@implementation MineCommentVC

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
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_delegate rerfeshCommentBall:@"comment"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    
    HttpManagerCenter *httpService = [HttpManagerCenter sharedHttpManager];
    [[httpService getCommentList:messagePage page_size:pageSize resultClass:nil] subscribeNext:^(BaseModel *model){
        
        [self hiddenHUD];
        
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
        [replyCell setItemDataComment:self.dataSource[indexPath.row]];
    } ];
    return height;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    MyMessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:systemMsgCell];
    [cell setItemDataComment:self.dataSource[indexPath.row]];
    
    cell.showCustomLineView = YES;
    
    if(indexPath.row+1 == self.dataSource.count){
        [self footerRereshing];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = self.dataSource[indexPath.row];
    NSString *url;
    if([data[@"type"] isEqual:@"1"]){
        url = [NSString stringWithFormat:@"%@?commentId=%@&shareId=%@&master=%@&comeFrom=%@&uid=%@&nikename=%@",URL_ShareCommentList,data[@"id"],data[@"share_id"],data[@"type"],@"MineCommentVC",data[@"uid"],[data[@"nikename"] urlencode]];
    }else{
        url = [NSString stringWithFormat:@"%@?commentId=%@&shareId=%@&comeFrom=MineCommentVC&uid=%@&nikename=%@",URL_ShareCommentList,data[@"id"],data[@"share_id"],data[@"uid"],[data[@"nikename"] urlencode]];
    }

    [self pushViewControllerWithUrl:url];
}




@end
