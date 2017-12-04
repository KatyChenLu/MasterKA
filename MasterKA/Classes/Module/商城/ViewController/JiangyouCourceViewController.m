//
//  JiangyouCourceViewController.m
//  MasterKA
//
//  Created by lijiachao on 16/7/26.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "JiangyouCourceViewController.h"
#import "JiangyouModel.h"

@interface JiangyouCourceViewController ()
@property (nonatomic,strong) UITableView *mTableView;


@property (nonatomic,strong,readwrite)JiangyouModel *viewModel;

@end

@implementation JiangyouCourceViewController
@synthesize viewModel = _viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
    self.viewModel.cardId = self.card_id;
    [self.viewModel bindTableView:self.mTableView];
    self.title = @"酱油卡课程列表";
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTableView{
    self.mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    self.mTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mTableView];
}

- (JiangyouModel*)viewModel
{
    if (!_viewModel) {
        _viewModel = [[JiangyouModel alloc] initWithViewController: self];
        
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
