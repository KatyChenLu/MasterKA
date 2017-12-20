//
//  KAInVoteViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/21.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAInVoteViewController.h"
#import "KAInVIewModel.h"

@interface KAInVoteViewController ()

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) KAInVIewModel *viewModel;

//页数
@property(nonatomic ,copy)NSString * page;
//每页单位
@property(nonatomic ,copy)NSString * page_size;
@end

@implementation KAInVoteViewController
@synthesize viewModel = _viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投票详情";
    self.page = @"1";
    self.page_size = @"10";
    [self.view addSubview:self.mTableView];
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.equalTo(self.view);
        
    }];
    
    [self.viewModel bindTableView:self.mTableView];
//    [self.mTableView.mj_header beginRefreshing];
    
}
- (void)bindViewModel {
    [super bindViewModel];
    
}
- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] init];
        
        _mTableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
        _mTableView.separatorColor = RGBFromHexadecimal(0xeaeaea);
        _mTableView.estimatedRowHeight = 0;
        _mTableView.estimatedSectionFooterHeight = 0;
        _mTableView.estimatedSectionHeaderHeight = 0;
        
    }
    return _mTableView;
}

- (KAInVIewModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[KAInVIewModel alloc] initWithViewController:self
                      ];
        
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
