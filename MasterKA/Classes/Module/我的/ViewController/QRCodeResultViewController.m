//
//  QRCodeResultViewController.m
//  MasterKA
//
//  Created by jinghao on 16/6/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "QRCodeResultViewController.h"
#import "QRCodeResultViewModel.h"
@interface QRCodeResultViewController ()
@property (nonatomic,strong)QRCodeResultViewModel *viewModel;
@property (nonatomic,weak)IBOutlet UITableView *mTableView;
@property (nonatomic,weak)IBOutlet UIButton *changeOrderButton;

@end


@implementation QRCodeResultViewController
@synthesize viewModel = _viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel.orderCode = self.params[@"code"];
    self.viewModel.orderId = self.params[@"oid"];
    self.viewModel.buyerId = self.params[@"id"];
    [self.viewModel bindTableView:self.mTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- 

- (QRCodeResultViewModel*)viewModel
{
    if (!_viewModel) {
        _viewModel = [[QRCodeResultViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}

- (void)bindViewModel
{
    [super bindViewModel];
    @weakify(self);
    [[self.changeOrderButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.changeOrderCommand execute:nil];
    }];
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
