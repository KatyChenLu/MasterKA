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
@end

@implementation KAPlaceViewController
@synthesize viewModel = _viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"场地介绍";
    [self.view addSubview:self.mTableView];
    
    [self.viewModel bindTableView:self.mTableView];
}
- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - (IsPhoneX?(34 + 88):64)) style:UITableViewStylePlain];
        
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
