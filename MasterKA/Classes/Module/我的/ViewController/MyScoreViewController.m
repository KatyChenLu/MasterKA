//
//  MyScoreDetialViewController.m
//  MasterKA
//
//  Created by hyu on 16/4/27.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MyScoreViewController.h"
#import "MyScoreDetialModel.h"
#import "MyScoreHeadview.h"


@interface MyScoreViewController ()
@property (nonatomic, strong,readonly) MyScoreDetialModel *viewModel;
@property (nonatomic,strong)MyScoreHeadview *mineHeadView;
@end

@implementation MyScoreViewController
@synthesize viewModel = _viewModel;
@synthesize mTableView = _mTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    id __strong Sself=self;
      self.viewModel.title = @"我的M点";
    self.mTableView.delegate = Sself;
    self.mTableView.dataSource = Sself;
    _score.text = self.params[@"score"];
    [self.viewModel bindTableView:self.mTableView];
    [self.mTableView.mj_header beginRefreshing];
    //    self.viewModel.curPage = @(1);
    
    //去掉tableView多余的横线
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    self.mTableView.separatorInset=UIEdgeInsetsMake(0,0, 0, 0);//top left bottom right
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([@"广东" isEqualToString:[UserClient sharedUserClient].city_name])
    {
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"广东地区暂不支持M点服务" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
    
    [alert show];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- getter and setter

- (MyScoreDetialModel*)viewModel{
    if (_viewModel==nil) {
        _viewModel = [[MyScoreDetialModel alloc] initWithViewController:self];
    }
    return _viewModel;
}
//- (MyScoreHeadview*)mineHeadView
//{
//    if (!_mineHeadView) {
//        _mineHeadView = [MyScoreHeadview loadInstanceFromNib];
//    }
//    return _mineHeadView;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
