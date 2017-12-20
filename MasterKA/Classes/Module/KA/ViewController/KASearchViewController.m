//
//  KASearchViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/12.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KASearchViewController.h"
#import "KASearchTableView.h"

@interface KASearchViewController ()<UITextFieldDelegate>
//@property(nonatomic ,copy)NSString * search_world;
@property (nonatomic, strong) KASearchTableView *mTableView;

@property (nonatomic,strong)UIView *defaultNoKeyWorkView;

//页数
@property(nonatomic ,copy)NSString * page;
//每页单位
@property(nonatomic ,copy)NSString * page_size;

@property (nonatomic, copy)NSString *keywords;

@end

@implementation KASearchViewController
@synthesize viewModel = _viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.page = @"1";
    self.page_size = @"10";
    self.searchTitleView.delegate = self;
    
    [self.searchTitleView becomeFirstResponder];
    
    self.navigationItem.titleView = self.searchTitleView;
    
//    UIBarButtonItem *cancleItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    
//    [self.navigationItem addRightBarButtonItem:cancleItem animated:YES];
    
    [self.view addSubview:self.mTableView];
    
    self.mTableView.baseVC = self;
    
//    [self requestKAHomeData:self.page pageId:self.page_size];
    UIBarButtonItem *fetchItem = [[UIBarButtonItem alloc] initWithCustomView:self.voteNavView];
    
   [self.navigationItem addRightBarButtonItem:fetchItem animated:YES];
    
    
    
    
}
- (KASearchTableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[KASearchTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
        _mTableView.mj_header = [MasterTableHeaderView addRefreshGifHeadViewWithRefreshBlock:^{
            
            [self first];
            
        }];
        
        _mTableView.mj_footer = [MasterTableFooterView footerWithRefreshingBlock:^{
            
            [self more];
            
        }];
    }
    return _mTableView;
}
- (void)first {
    [_mTableView.kaHomeData removeAllObjects];
    self.page = @"1";
    [self requestKAHomeData:self.page pageId:self.page_size];
    [_mTableView reloadData];
}

- (void)more {
    self.page = [NSString stringWithFormat:@"%d",[self.page intValue]+1];
    [self requestKAHomeData:self.page pageId:self.page_size];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
//    [self.navigationItem setLeftBarButtonItems:nil];
//    [self.navigationItem setHidesBackButton:YES animated:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    [self reloadCntLabel];
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)bindViewModel
{
    [super bindViewModel];
    @weakify(self);
    [self.searchTitleView.rac_textSignal subscribeNext:^(NSString *x) {
        @strongify(self);
        if (x==nil || x.length==0) {
            [self showDefaultNoKeyWorkView:YES];
        }else{
            [self showDefaultNoKeyWorkView:NO];
        }

        self.keywords = x;
          [self first];
    }];
//    [[self.searchTitleView rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(NSString *x){
//                @strongify(self);
//                if (x==nil || x.length==0) {
//                    [self showDefaultNoKeyWorkView:YES];
//                }else{
//                    [self showDefaultNoKeyWorkView:NO];
//                }
//
//                self.keywords = x;
//                  [self first];
//    }];
}

#pragma mark - fangfa -
- (void)requestKAHomeData:(NSString*)page pageId:(NSString*)pageId {
    
    
    RACSignal *fetchSignal = [[HttpManagerCenter sharedHttpManager] searchCourseWithKeywords:self.keywords page:self.page pageSize:self.page_size resultClass:nil];
    
    [fetchSignal subscribeNext:^(BaseModel *baseModel) {
        if (baseModel.code == 200) {
             self.mTableView.kaHomeData = baseModel.data;
        [self.mTableView reloadData];
        
        }
    }completed:^{
        
        if(self.mTableView.mj_header.isRefreshing){
            
            [self.mTableView.mj_header endRefreshing];
            
        }
        
        if(self.mTableView.mj_footer.isRefreshing){
            
            [self.mTableView.mj_footer endRefreshing];
        }
    }];
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    [self showDefaultNoKeyWorkView:NO];
    
    self.keywords =  textField.text ;
    
    [self.mTableView reloadData];
    return YES;
}


//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//
//    textField.placeholder = self.search_world;
//
//    return YES;
//}



- (UIView*)defaultNoKeyWorkView
{
    if (!_defaultNoKeyWorkView) {
        _defaultNoKeyWorkView = [[UIView alloc] init];
        _defaultNoKeyWorkView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_defaultNoKeyWorkView];
        [_defaultNoKeyWorkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"search_defaut"];
        [_defaultNoKeyWorkView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_defaultNoKeyWorkView);
            make.top.equalTo(_defaultNoKeyWorkView).with.offset(75);
        }];
        _defaultNoKeyWorkView.hidden = YES;
    }
    return _defaultNoKeyWorkView;
}

- (void)showDefaultNoKeyWorkView:(BOOL)show{
    if (show) {
        self.defaultNoKeyWorkView.hidden = NO;
    }else{
        self.defaultNoKeyWorkView.hidden = YES;
    }
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
