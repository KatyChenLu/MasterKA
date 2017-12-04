//
//  MyCardViewController.m
//  MasterKA
//
//  Created by hyu on 16/4/27.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MyCardViewController.h"
#import "MyCardViewModel.h"
#import "UITableView+Gzw.h"
#import "GoodsSubListViewController.h"
@interface MyCardViewController ()
@property (nonatomic, strong,readonly) MyCardViewModel *viewModel;
@end

@implementation MyCardViewController
@synthesize viewModel = _viewModel;
@synthesize mTableView = _mTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.navigationItem setTitle:@"设置"];
      self.viewModel.title = @"我的酱油卡";
//    UIButton *leftbuton=[UIButton buttonWithType:UIButtonTypeCustom];
//    [leftbuton setFrame:CGRectMake(300, 20, 40, 40)];
//    [leftbuton setTitle:@"明细" forState:UIControlStateNormal];
//    leftbuton.tintColor=[UIColor colorWithRed:178/255.f green:178/255.f blue:178/255.f alpha:1.0f];
//    [leftbuton setBackgroundColor:[UIColor clearColor]];
//    UIBarButtonItem *leftBar =[[UIBarButtonItem alloc]initWithCustomView:leftbuton];
//    self.navigationItem.rightBarButtonItem = leftBar;
    id __strong Sself=self;
    self.mTableView.delegate = Sself;
    self.mTableView.dataSource = Sself;

    [self.viewModel bindTableView:self.mTableView];

    [self.mTableView.mj_header beginRefreshing];
    //    self.viewModel.curPage = @(1);
    
    //去掉tableView多余的横线
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.mTableView.descriptionText = @"用酱油卡比直接购买更划算哦~";
    
    //    self.mTableView.separatorInset=UIEdgeInsetsMake(0,0, 0, 0);//top left bottom right
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
if([self.userClient.city_name isEqualToString:@"广东"])
{
    [self.buyCardBtn setTitle:@"兑换酱油卡" forState:UIControlStateNormal];
}
else{
[self.buyCardBtn setTitle:@"购买酱油卡" forState:UIControlStateNormal];
}
    
}

- (IBAction)gotoCardListVCT:(id)sender{
    
    if([self.userClient.city_name isEqualToString:@"广东"])
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
        UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"ExchangeViewController"];
        [self.navigationController pushViewController:myView animated:YES];

    }
    else{
         UIViewController *myView = [UIViewController viewControllerWithName:@"CardListViewController"];
         [self.navigationController pushViewController:myView animated:YES];
    }
}

#pragma mark -- getter and setter

- (MyCardViewModel*)viewModel{
    if (_viewModel==nil) {
        _viewModel = [[MyCardViewModel alloc] initWithViewController:self];
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
