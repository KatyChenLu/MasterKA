//
//  KAOrderDetailViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/28.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAOrderDetailViewController.h"
#import "KAOrderDetailViewModel.h"
@interface KAOrderDetailViewController ()

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) KAOrderDetailViewModel *viewModel;
@end

@implementation KAOrderDetailViewController
@synthesize viewModel = _viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    [self.view addSubview:self.mTableView];
    [self.viewModel bindTableView:self.mTableView];
    
    
}
- (void)bindViewModel {
    [super bindViewModel];
    
}
- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - (IsPhoneX?(34 + 44):0) - 49) style:UITableViewStylePlain];
        [_mTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _mTableView;
}

- (KAOrderDetailViewModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[KAOrderDetailViewModel alloc] initWithViewController:self
                      ];
        _viewModel.oid = self.oid;
        _viewModel.orderStatus =self.orderStatus;
        
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
