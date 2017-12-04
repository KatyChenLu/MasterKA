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

@end

@implementation KAPreVoteViewController
@synthesize viewModel = _viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mTableView];
    [self.view addSubview:self.beginVoteBtn];
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
        }else{
           self.beginVoteBtn.backgroundColor = MasterDefaultColor;
        }
    }];
    
}
- (UIButton *)beginVoteBtn {
    if (!_beginVoteBtn) {
        _beginVoteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _beginVoteBtn.frame = CGRectMake(0, ScreenHeight - (IsPhoneX?(34 + 44):0) - 42 - 49 -42,  ScreenWidth, 42);
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
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - (IsPhoneX?(34 + 44):0) - 42-49 -42) style:UITableViewStylePlain];
        
    }
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
