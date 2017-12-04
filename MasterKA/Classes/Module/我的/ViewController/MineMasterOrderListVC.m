//
//  MineMasterOrderListVC.m
//  MasterKA
//
//  Created by xmy on 16/5/25.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MineMasterOrderListVC.h"
#import "MasterOrderListModel.h"
#import "MasterOrderInfoCell.h"

@interface MineMasterOrderListVC ()
@property (nonatomic, strong,readonly) MasterOrderListModel *viewModel;
@end

@implementation MineMasterOrderListVC
@synthesize viewModel = _viewModel;
@synthesize mTableView = _mTableView;
- (void)viewDidLoad {
    [super viewDidLoad];

    self.viewModel.orderStatus = self.params[@"orderStatus"];
    self.viewModel.comeIdentifier = self.params[@"comeIdentifier"];
    self.viewModel.title = @"我的课程订单";
    [self.viewModel bindTableView:self.mTableView];
//    self.mTableView.backgroundColor = RGBFromHexadecimal(0xf7f5f6);

    NSLog(@"url %@  params %@",self.url,self.params);
    
    //去掉tableView多余的横线
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    self.mTableView.separatorInset=UIEdgeInsetsMake(0,0, 0, 0);//top left bottom right
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- getter and setter

- (MasterOrderListModel*)viewModel{
    if (_viewModel==nil) {
        _viewModel = [[MasterOrderListModel alloc] initWithViewController:self];
    }
    return _viewModel;
}

@end
