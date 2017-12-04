//
//  SystemMessageViewController.m
//  HiGoMaster
//
//  Created by jinghao on 15/6/16.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "SystemMessageTableViewCell.h"
#import "GoodDetailViewController.h"
//#import "MasterShareSearchViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
//#import "MasterShareSearchViewController.h"
@interface SystemMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger messagePage;
    NSInteger pageSize;
}
@property (nonatomic,weak)IBOutlet UITableView* mTableView;
@property (nonatomic,strong)NSMutableArray* dataSource;
@property (nonatomic,strong)SystemMessageTableViewCell* systemMessageCell;
@end

static NSString* systemMsgCell = @"SystemMessageTableViewCell";

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.params[@"title"];
    messagePage = 1;
    pageSize = 10;
    self.systemMessageCell  = [self.mTableView dequeueReusableCellWithIdentifier:@"SystemMessageTableViewCell"];
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self headerRereshing];
    
    self.mTableView.backgroundColor = self.view.backgroundColor;
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
    [_delegate rerfeshSystemBall:@"system"];
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
    [[httpService getSystemMessage:messagePage page_size:pageSize resultClass:nil] subscribeNext:^(BaseModel *model){
        
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
    return [tableView fd_heightForCellWithIdentifier:systemMsgCell cacheByIndexPath:indexPath configuration:^(id cell) {
        SystemMessageTableViewCell* replyCell = (SystemMessageTableViewCell*)cell;
        [replyCell setItemData:self.dataSource[indexPath.row]];
    } ];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    SystemMessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:systemMsgCell];
    [cell setItemData:self.dataSource[indexPath.row]];
    
    if(indexPath.row+1 == self.dataSource.count){
        [self footerRereshing];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * item = self.dataSource[indexPath.row];
    NSString* targetType = [item objectForKey:@"target_type"];
    //（1：课程；2：达人；3：课程卡片；4：达人卡片；5：html5页面；6：课程关键字）'
    if (targetType && [targetType isKindOfClass:[NSString class]]) {	
        id targetContent = item[@"target_content"];
        if (targetType.integerValue==1) {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Goods" bundle:[NSBundle mainBundle]];
            UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
            myView.params = @{@"courseId":targetContent} ;
            [self.navigationController pushViewController:myView animated:YES];
        }else if (targetType.integerValue==2) {
            NSString *url = [NSString stringWithFormat:@"%@?uid=%@",URL_MasterCenter,targetContent];
            [self pushViewControllerWithUrl:url];
        }else if (targetType.integerValue==5) {
           [self pushViewControllerWithUrl:targetContent];
        }else if (targetType.integerValue==3||targetType.integerValue==4 || targetType.intValue == 7) {
            [self pushViewControllerWithUrl:item[@"pfurl"]];
        }else if (targetType.integerValue==6 ){
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"MasterShare" bundle:[NSBundle mainBundle]];
            UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"MasterShareSearchViewController"];
            myView.params=@{@"text":targetContent};
//            UIViewController *vct = [UIStoryboard viewController:@"MasterShare" identifier:@"MasterShareSearchViewController"];
            [self pushViewController:myView animated:YES];
        }
    }
}



@end
