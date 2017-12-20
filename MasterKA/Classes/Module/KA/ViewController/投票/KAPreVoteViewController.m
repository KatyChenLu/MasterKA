//
//  KAPreVoteViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/21.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAPreVoteViewController.h"
#import "KAProViewModel.h"
#import "KAEditVoteViewController.h"

@interface KAPreVoteViewController ()

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) UIButton *beginVoteBtn;
@property (nonatomic, strong) KAProViewModel *viewModel;
@property (nonatomic, strong) NSArray *selecArr;

//页数
@property(nonatomic ,copy)NSString * page;
//每页单位
@property(nonatomic ,copy)NSString * page_size;

@end

@implementation KAPreVoteViewController
@synthesize viewModel = _viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = @"1";
    self.page_size = @"10";
    
    [self.view addSubview:self.beginVoteBtn];
        [self.view addSubview:self.mTableView];
    [self.beginVoteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(@42);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];

    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(self.view);
        
        make.bottom.equalTo(self.beginVoteBtn.mas_top);
    }];
    [self.viewModel bindTableView:self.mTableView];
    

}
- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self);
    [RACObserve(self.viewModel, selectVoteArr) subscribeNext:^(NSMutableArray *selArr) {
        @strongify(self);
        [self.beginVoteBtn setTitle:[NSString stringWithFormat:@"发起投票(%lu)",(unsigned long)selArr.count] forState:UIControlStateNormal];
        if (selArr.count == 0) {
            [self.beginVoteBtn setTitle:@"发起投票" forState:UIControlStateNormal];
        }
        if (selArr.count <2) {
            self.beginVoteBtn.backgroundColor =RGBFromHexadecimal(0xcdcdcd);
            self.beginVoteBtn.enabled = NO;
        }else{
           self.beginVoteBtn.backgroundColor = MasterDefaultColor;
            self.beginVoteBtn.enabled = YES;
        }
        self.selecArr = selArr;
    }];
    
}
- (UIButton *)beginVoteBtn {
    if (!_beginVoteBtn) {
        _beginVoteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _beginVoteBtn.frame = CGRectMake(0, ScreenHeight - (IsPhoneX?(34 + 44):0) - 42 - 49 -42,  ScreenWidth, 42);
        _beginVoteBtn.backgroundColor = MasterDefaultColor;
        NSString *btnTitle =@"发起投票";
        _beginVoteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_beginVoteBtn setTitle:btnTitle forState:UIControlStateNormal];
        [_beginVoteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_beginVoteBtn addTarget:self action:@selector(beginVoteAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beginVoteBtn;
}
- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] init];

    }
    _mTableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    _mTableView.separatorColor = RGBFromHexadecimal(0xeaeaea);
    _mTableView.estimatedRowHeight = 0;
    _mTableView.estimatedSectionFooterHeight = 0;
    _mTableView.estimatedSectionHeaderHeight = 0;
    return _mTableView;
}

- (KAProViewModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[KAProViewModel alloc] initWithViewController:self
                      ];
         _viewModel.isHideSelect = NO;
    }
    return _viewModel;
}

-(void)beginVoteAction {
    KAEditVoteViewController *kaEditVoteVC = [[KAEditVoteViewController alloc] init];
    kaEditVoteVC.info = _viewModel.info;
    kaEditVoteVC.selArr = self.selecArr;
    [self.navigationController pushViewController:kaEditVoteVC animated:YES];
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
