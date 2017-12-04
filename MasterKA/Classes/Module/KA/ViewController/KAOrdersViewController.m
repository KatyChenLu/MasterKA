//
//  KAOrdersViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/28.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAOrdersViewController.h"
#import "KAOrdersViewModel.h"

@interface KAOrdersViewController ()
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) KAOrdersViewModel *viewModel;
@end
@implementation KAOrdersViewController
@synthesize viewModel = _viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mTableView];
    self.title = @"团建订单";
    [self.viewModel bindTableView:self.mTableView];
    
    
}
- (void)bindViewModel {
    [super bindViewModel];
    
}
- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - (IsPhoneX?(34 + 44):0) - 49) style:UITableViewStylePlain];
        
    }
    return _mTableView;
}

- (KAOrdersViewModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[KAOrdersViewModel alloc] initWithViewController:self
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
