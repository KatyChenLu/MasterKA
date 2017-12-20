//
//  KAPlaceViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/27.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAPlaceViewController.h"
#import "KAPlaceViewModel.h"
@interface KAPlaceViewController ()
@property (nonatomic, strong) KAPlaceViewModel *viewModel;
@property (nonatomic, strong) UITableView *mTableView;

//页数
@property(nonatomic ,copy)NSString * page;
//每页单位
@property(nonatomic ,copy)NSString * page_size;
@end

@implementation KAPlaceViewController
@synthesize viewModel = _viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.page = @"1";
    self.page_size = @"10";
    self.title = @"场地介绍";
    [self.view addSubview:self.mTableView];
    
    [self.viewModel bindTableView:self.mTableView];
}
- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - (IsPhoneX?(34 + 88):64)) style:UITableViewStylePlain];
        _mTableView.mj_header = [MasterTableHeaderView addRefreshGifHeadViewWithRefreshBlock:^{
            
            [self.viewModel first];
            
        }];
        
        _mTableView.mj_footer = [MasterTableFooterView footerWithRefreshingBlock:^{
            [self.viewModel requestRemoteDataSignalWithPage:[self.page integerValue]+1];
            
            
        }];
    }
    return _mTableView;
}

- (KAPlaceViewModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[KAPlaceViewModel alloc] initWithViewController:self
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
