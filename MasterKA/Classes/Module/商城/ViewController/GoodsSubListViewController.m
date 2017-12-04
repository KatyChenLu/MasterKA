//
//  GoodsSubListViewController.m
//  MasterKA
//
//  Created by xmy on 16/5/11.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "GoodsSubListViewController.h"
#import "GoodsSubListViewModel.h"

@interface GoodsSubListViewController ()

@property (nonatomic,weak)IBOutlet UITableView *mTableView;


@property (nonatomic,strong,readwrite)GoodsSubListViewModel *viewModel;

@end

@implementation GoodsSubListViewController
@synthesize viewModel = _viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideView) name:@"showTarBarVC" object:nil];
    [self.viewModel bindTableView:self.mTableView];
    self.viewModel.title = self.params[@"title"];
    self.categoryId = self.params[@"categoryId"];
    
//    if(self.viewModel.categoryId && [self.viewModel.categoryId isEqualToString:@"-1"]){
//        [self.shuaiXuanBtn setHidden:YES ];
//    }
    
    self.mTableView.backgroundColor = self.view.backgroundColor;
    //去掉tableView多余的横线
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideView{
self.tabBarController.tabBar.hidden = NO;
}
- (void)bindViewModel
{
    [super bindViewModel];
    RAC(self.viewModel,categoryId) = RACObserve(self, categoryId);
}

- (GoodsSubListViewModel*)viewModel
{
    if (!_viewModel) {
        _viewModel = [[GoodsSubListViewModel alloc] initWithViewController: self];
        _viewModel.shuaiXuanBtn = self.shuaiXuanBtn;
    }
    return _viewModel;
}
- (IBAction)clickSelectOrder:(id)sender {
    
    [self.viewModel gotoSelectOrder];
    
}



@end
