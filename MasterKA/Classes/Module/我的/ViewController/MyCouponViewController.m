//
//  MyCouponViewController.m
//  MasterKA
//
//  Created by hyu on 16/4/27.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MyCouponViewController.h"
#import "MyCouponModel.h"
@interface MyCouponViewController ()
@property (nonatomic, strong,readonly) MyCouponModel *viewModel;
@end

@implementation MyCouponViewController
@synthesize viewModel = _viewModel;
@synthesize mTableView = _mTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    id __strong Sself=self;
      self.viewModel.title = @"代金券";
    self.mTableView.delegate = Sself;
    self.mTableView.dataSource = Sself;
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

- (MyCouponModel*)viewModel{
    if (_viewModel==nil) {
        _viewModel = [[MyCouponModel alloc] initWithViewController:self];
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
