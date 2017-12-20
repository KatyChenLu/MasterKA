//
//  KACollectViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/12.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KACollectViewController.h"
#import "KACollectViewModel.h"

@interface KACollectViewController ()

@property (nonatomic, strong) KACollectViewModel *viewModel;
@property (nonatomic, strong) UITableView *mTableView;
//定制悬浮按钮
@property (nonatomic, strong) UIButton *customizeBtn;
@end

@implementation KACollectViewController

@synthesize viewModel = _viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    [self.view addSubview:self.mTableView];
    UIBarButtonItem *fetchItem = [[UIBarButtonItem alloc] initWithCustomView:self.voteNavView];
    
    self.navigationItem.rightBarButtonItem = fetchItem;
    
    [self.viewModel bindTableView:self.mTableView];
    
        NSInteger height = IsPhoneX?(65+100+34):(65+100);
    self.customizeBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-102*0.7, ScreenHeight-height, 102*0.7, 67*0.7)];
    
    [self.customizeBtn setImage:[UIImage imageNamed:@"高端定制"] forState:UIControlStateNormal];
    
    //    self.customizeBtn.hidden = YES;
    
    [self.customizeBtn addTarget: self action:@selector(customizeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.customizeBtn];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
     self.customizeBtn.hidden = NO;
    [self reloadCntLabel];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     self.customizeBtn.hidden = YES;
}
- (void)customizeAction:(UIButton *)button {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"KA" bundle:[NSBundle mainBundle]];
    UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"KACustomViewController"];
    [self pushViewController:myView animated:YES];
}
- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - (IsPhoneX?(34 + 88):64)) style:UITableViewStylePlain];
        
    }
    return _mTableView;
}

- (KACollectViewModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[KACollectViewModel alloc] initWithViewController:self
                      ];
        
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
