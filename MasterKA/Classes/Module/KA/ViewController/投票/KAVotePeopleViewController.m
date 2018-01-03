//
//  KAVotePeopleViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/12.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAVotePeopleViewController.h"
#import "KAVotePeopleViewModel.h"

@interface KAVotePeopleViewController ()

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) KAVotePeopleViewModel *viewModel;

//页数
@property(nonatomic ,copy)NSString * page;
//每页单位
@property(nonatomic ,copy)NSString * page_size;
@end

@implementation KAVotePeopleViewController
@synthesize viewModel = _viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投票详情";
    self.page = @"1";
    self.page_size = @"10";
    [self.view addSubview:self.mTableView];
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    [self.viewModel bindTableView:self.mTableView];
    
    
}
- (void)bindViewModel {
    [super bindViewModel];
    
}
- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - (IsPhoneX?(34 + 44):0) - 49) style:UITableViewStylePlain];
        _mTableView.mj_header = [MasterTableHeaderView addRefreshGifHeadViewWithRefreshBlock:^{
            
            [self.viewModel first];
            
        }];
        
        _mTableView.mj_footer = [MasterTableFooterView footerWithRefreshingBlock:^{
            [self.viewModel requestRemoteDataSignalWithPage:[self.page integerValue]+1];
            
        }];
        
        _mTableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
        _mTableView.separatorColor = RGBFromHexadecimal(0xeaeaea);
    }
    return _mTableView;
}

- (KAVotePeopleViewModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[KAVotePeopleViewModel alloc] initWithViewController:self
                      ];
        _viewModel.item_id = self.item_id;
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
