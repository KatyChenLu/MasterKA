//
//  KADetailVoteViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/22.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KADetailVoteViewController.h"

#import "KADetailVoteViewModel.h"
@interface KADetailVoteViewController ()

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) KADetailVoteViewModel *viewModel;
@property (nonatomic,strong)UIButton *shareBtn;
@end

@implementation KADetailVoteViewController
@synthesize viewModel = _viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"投票详情";
    [self.view addSubview:self.mTableView];
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    
    [self.viewModel bindTableView:self.mTableView];
    
    UIBarButtonItem *shareBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.shareBtn];
    [self.navigationItem setRightBarButtonItem:shareBarBtnItem];
    
    
}
- (void)bindViewModel {
    [super bindViewModel];
    
}
- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.frame = CGRectMake(0, 0, 30, 30);
        [_shareBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}
- (void)shareButtonOnClick {
    [self shareContentOfApp:self.viewModel.info[@"share_data"]];
}
- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - (IsPhoneX?(34 + 44):0) - 49) style:UITableViewStylePlain];
        
        _mTableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
        _mTableView.separatorColor = RGBFromHexadecimal(0xeaeaea);
    }
    return _mTableView;
}

- (KADetailVoteViewModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[KADetailVoteViewModel alloc] initWithViewController:self
                      ];
        _viewModel.vote_id = self.vote_id;
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
