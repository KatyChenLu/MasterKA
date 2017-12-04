//
//  KADetailViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/10/12.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KADetailViewController.h"
#import "KADetailViewModel.h"
#import "KADetailTableView.h"
#import "KACustomViewController.h"

@interface KADetailViewController ()

@property (nonatomic, strong) KADetailViewModel *viewModel;
@property (nonatomic, strong) KADetailTableView *tableView;
@property (strong , nonatomic) NSString *course_id;
@property (nonatomic,assign)float lastAlphaNavigationBar;
@property (nonatomic, strong) UIView *FootView;
@property (nonatomic,strong)UIBarButtonItem *shangchuan;
@property (nonatomic,strong)UIButton *shoucang;
@end

@implementation KADetailViewController
@synthesize viewModel = _viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel.title = @"xiangqing";
    self.course_id = self.params[@"courseId"];
    
    UIBarButtonItem *fetchItem = [[UIBarButtonItem alloc] initWithCustomView:self.voteNavView];
    [self.voteBtn setImage:[UIImage imageNamed:@"投票箱白色"] forState:UIControlStateNormal];
    [self.navigationItem addRightBarButtonItem:fetchItem animated:YES];
    
    self.shangchuan = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shangchuan"] style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonOnClick:)];
    [self.navigationItem addRightBarButtonItem:self.shangchuan animated:YES];
    _shoucang = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shoucang setFrame:CGRectMake(0, 0, 50, 50)];
    [_shoucang setImageEdgeInsets:UIEdgeInsetsMake(-3, 0, 0, 0)];
    [_shoucang sizeToFit];
    UIBarButtonItem*shoucangItem = [[UIBarButtonItem alloc] initWithCustomView:_shoucang];
    [self.navigationItem addRightBarButtonItem:shoucangItem animated:YES];
    
    
    [self.view addSubview:self.tableView];
    [self.viewModel bindTableView:self.tableView];
    
    UIView *headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    _mineHeadView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    [headerView addSubview:_mineHeadView];
    self.tableView.tableHeaderView=headerView;
    [self.mineHeadView setImageWithURLString:self.headViewUrl placeholderImage:nil];
    
    [self.view addSubview:self.FootView];
}

#pragma shengmingzhouqi

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    
    [self.viewModel first];
    
    [self.navigationController.navigationBar setBackgroundImageAlpha:self.lastAlphaNavigationBar];
    self.cntLabel.text = [NSString stringWithFormat:@"%ld",[UserClient sharedUserClient].voteNum];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImageAlpha:1.0f];
    self.tabBarController.tabBar.hidden =YES;
}
#pragma jichengfnagfa

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
    [[[RACObserve(self.viewModel, alphaNavigationBar) distinctUntilChanged] filter:^BOOL(NSNumber *x) {
        return x.floatValue>=0.0f && x.floatValue<=1.0f;
    }] subscribeNext:^(NSNumber *x) {
        @strongify(self)
        float alpha = [x floatValue];
        self.lastAlphaNavigationBar = alpha;
        if (alpha>0.2) {
            //            self.topImageView.hidden = FALSE;
        }
        if (alpha>0.5) {
            [self changeBarButtonColor:TRUE];
        }else{
            [self changeBarButtonColor:FALSE];
        }
        [self.navigationController.navigationBar setBackgroundImageAlpha:alpha];
    }];
}
#pragma siyoufnagfa
- (void)changeBarButtonColor:(BOOL)black{
    if (black) {
        self.shangchuan.tintColor = [UIColor blackColor];
        [self.voteBtn setImage:[UIImage imageNamed:@"投票箱黑色"] forState:UIControlStateNormal];
        if([self.viewModel.info[@"is_collect"] isEqual:@"0"]){
            [_shoucang setImage:[UIImage imageNamed:@"shoucang-hei"] forState:UIControlStateNormal];
        }
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
        self.title=@"KA详情";
        self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor blackColor]};
    }else{
        self.title=@"";
        self.shangchuan.tintColor = [UIColor whiteColor];
        [self.voteBtn setImage:[UIImage imageNamed:@"投票箱白色"] forState:UIControlStateNormal];
        if([self.viewModel.info[@"is_collect"] isEqual:@"0"]){
            [_shoucang setImage:[UIImage imageNamed:@"shoucangCourse"] forState:UIControlStateNormal];
        }
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    }
}

- (void)dingzhi:(UIButton *)sender {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserShare" bundle:[NSBundle mainBundle]];
    UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"KACustomViewController"];
    [self pushViewController:myView animated:YES];
    
}
#pragma lanjiazai

- (KADetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[KADetailViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}

- (KADetailTableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[KADetailTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-42- (IsPhoneX?34:0))];
    }
    return _tableView;
}

-(UIView *)FootView {
    if (!_FootView) {
        _FootView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 42 - (IsPhoneX?34:0), ScreenWidth, 42)];
       
        UIButton *dingzhiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dingzhiBtn.frame = CGRectMake(0, 0, ScreenWidth, 42);
        [dingzhiBtn setTitle:@"立即定制" forState:UIControlStateNormal];
        [dingzhiBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [dingzhiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        dingzhiBtn.backgroundColor = MasterDefaultColor;
        [dingzhiBtn addTarget:self action:@selector(dingzhi:) forControlEvents:UIControlEventTouchUpInside];
        [_FootView addSubview:dingzhiBtn];
    }
    return _FootView;
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
