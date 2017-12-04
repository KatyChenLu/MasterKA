//
//  MyScoreAccountControllor.m
//  MasterKA
//
//  Created by hyu on 16/5/25.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MyScoreAccountControllor.h"
#import "ScoreAccountModel.h"
@interface MyScoreAccountControllor ()
@property (strong ,nonatomic ) ScoreAccountModel *viewModel;
@end

@implementation MyScoreAccountControllor
@synthesize viewModel = _viewModel;
@synthesize mTableView = _mTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel.title = @"我的M点";
    [self.viewModel bindTableView:self.mTableView];
    [self.mTableView.mj_header beginRefreshing];
    //    self.viewModel.curPage = @(1);
    
    //去掉tableView多余的横线
    //    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    self.mTableView.separatorInset=UIEdgeInsetsMake(0,0, 0, 0);//top left bottom right
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- getter and setter

- (ScoreAccountModel*)viewModel{
    if (_viewModel==nil) {
        _viewModel = [[ScoreAccountModel alloc] initWithViewController:self];
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
