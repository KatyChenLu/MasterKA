//
//  MyFansViewController.m
//  MasterKA
//
//  Created by hyu on 16/4/28.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MyFansViewController.h"
#import "MyFansModel.h"
@interface MyFansViewController ()
@property (nonatomic, strong,readonly) MyFansModel *viewModel;
@end

@implementation MyFansViewController
@synthesize viewModel = _viewModel;
@synthesize mTableView = _mTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
      self.viewModel.title = self.params[@"title"];
    [self.viewModel bindTableView:self.mTableView];
    [self.mTableView.mj_header beginRefreshing];
    self.viewModel.share_id = self.params[@"share_id"];
    self.viewModel.course_id=self.params[@"course_id"];
    self.viewModel.index_article_id = self.index_article_id;
    
    self.viewModel.master = self.params[@"master"];
    self.viewModel.comeIdentity=self.params[@"comeIdentity"];
    //    self.viewModel.curPage = @(1);
    
    //去掉tableView多余的横线
        self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    self.mTableView.separatorInset=UIEdgeInsetsMake(0,0, 0, 0);//top left bottom right
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- getter and setter

- (MyFansModel*)viewModel{
    if (_viewModel==nil) {
        _viewModel = [[MyFansModel alloc] initWithViewController:self];
    }
    return _viewModel;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
