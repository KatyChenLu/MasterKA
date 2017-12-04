//
//  MyShareViewController.m
//  MasterKA
//
//  Created by hyu on 16/5/4.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MyShareViewController.h"
#import "MyShareModel.h"
#import "UITableView+Gzw.h"
@interface MyShareViewController ()
@property (nonatomic, strong,readonly) MyShareModel *viewModel;
@end

@implementation MyShareViewController

@synthesize viewModel = _viewModel;
@synthesize mTableView = _mTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    id __strong Sself=self;
    self.mTableView.delegate = Sself;
    self.mTableView.dataSource = Sself;
    self.viewModel.title =self.params[@"title"]?self.params[@"title"]:@"我的发布";
    [self.viewModel bindTableView:self.mTableView];
    self.viewModel.couse_id=self.params[@"course_id"];
    [self.mTableView.mj_header beginRefreshing];
    //    self.viewModel.curPage = @(1);
    
    self.mTableView.descriptionText = @"大咖们都在炫酷，你不尝试一下吗?";
    
    //去掉tableView多余的横线
//    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    self.mTableView.separatorInset=UIEdgeInsetsMake(0,0, 0, 0);//top left bottom right
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- getter and setter

- (MyShareModel*)viewModel{
    if (_viewModel==nil) {
        _viewModel = [[MyShareModel alloc] initWithViewController:self];
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
