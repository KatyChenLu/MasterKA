//
//  SelectOrderVC.m
//  MasterKA
//
//  Created by xmy on 16/5/17.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "SelectOrderVC.h"
#import "SelectOrderModel.h"

@interface SelectOrderVC ()
@property (nonatomic,weak)IBOutlet UITableView *mTableModel;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;


@property (nonatomic,strong)SelectOrderModel *viewModel;

@end

@implementation SelectOrderVC
@synthesize viewModel = _viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.viewModel.orderId = self.params[@"orderId"];
    self.viewModel.selectId = self.params[@"selectId"];
    self.viewModel.selectedOrder = TRUE;
    [self.orderBtn setTitleColor:RGBFromHexadecimal(0X0A92E5) forState:UIControlStateNormal];
    [self.selectBtn setTitleColor:RGBFromHexadecimal(0x424242) forState:UIControlStateNormal];
    [self.viewModel bindTableView:self.mTableModel];
    [self.viewModel reloadTable];
}

#pragma mark --

- (SelectOrderModel*)viewModel
{
    if (!_viewModel) {
        _viewModel = [[SelectOrderModel alloc] initWithViewController:self];
    }
    return _viewModel;
}

- (IBAction)clickOrder:(id)sender {
    self.viewModel.selectedOrder = TRUE;
    [self.orderBtn setTitleColor:RGBFromHexadecimal(0X0A92E5) forState:UIControlStateNormal];
    [self.selectBtn setTitleColor:RGBFromHexadecimal(0x424242) forState:UIControlStateNormal];
    [self.orderBtn setImage:[UIImage imageNamed:@"jiantouxia1"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"jiantoushang"] forState:UIControlStateNormal];
    [self.viewModel reloadTable];
}
- (IBAction)clickSelect:(id)sender {
    self.viewModel.selectedOrder = FALSE;
    [self.orderBtn setTitleColor:RGBFromHexadecimal(0x424242) forState:UIControlStateNormal];
    [self.selectBtn setTitleColor:RGBFromHexadecimal(0X0A92E5) forState:UIControlStateNormal];
    [self.orderBtn setImage:[UIImage imageNamed:@"jiantoushang"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"jiantouxia1"] forState:UIControlStateNormal];
    [self.viewModel reloadTable];
}

@end
