//
//  KAMomentViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/6.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAMomentViewController.h"

#import "KAMomentViewModel.h"
@interface KAMomentViewController ()

@property (nonatomic, strong) KAMomentViewModel *viewModel;
@property (nonatomic, strong) UITableView *mTableView;

//页数
@property(nonatomic ,copy)NSString * page;
//每页单位
@property(nonatomic ,copy)NSString * page_size;
@end

@implementation KAMomentViewController

@synthesize viewModel = _viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"精彩时刻";
    
    self.page = @"1";
    self.page_size = @"10";
    [self.view addSubview:self.mTableView];
    
    [self.viewModel bindTableView:self.mTableView];
}
- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - (IsPhoneX?(34 + 88):64)) style:UITableViewStylePlain];
        _mTableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
        _mTableView.separatorColor = RGBFromHexadecimal(0xeaeaea);
        _mTableView.mj_header = [MasterTableHeaderView addRefreshGifHeadViewWithRefreshBlock:^{
            
            [self.viewModel first];
            
        }];
        
        _mTableView.mj_footer = [MasterTableFooterView footerWithRefreshingBlock:^{
            [self.viewModel requestRemoteDataSignalWithPage:[self.page integerValue]+1];
            
            
        }];
    }
    return _mTableView;
}

- (KAMomentViewModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[KAMomentViewModel alloc] initWithViewController:self
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
