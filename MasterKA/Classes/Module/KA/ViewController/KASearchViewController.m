//
//  KASearchViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/12.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KASearchViewController.h"
#import "KASearchTableView.h"
#import "HomeTextField.h"

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
    
//    [self.searchTitleView becomeFirstResponder];
    
    self.navigationItem.titleView = self.searchTitleView;
    
    [self.view addSubview:self.mTableView];
    
    self.mTableView.baseVC = self;
    
    
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
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    [self reloadCntLabel];
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self.searchTitleView becomeFirstResponder];
    
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
 
//    [[self.searchTitleView rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(HomeTextField *x){
//                @strongify(self);
//                if (x.text==nil || x.text.length==0) {
//                    [self showDefaultNoKeyWorkView:YES];
//                }else{
//                    [self showDefaultNoKeyWorkView:NO];
//                }
//
//                self.keywords = x.text;
//                  [self first];
//    }];
    [RACObserve(self.mTableView, kaHomeData) subscribeNext:^(NSMutableArray *kaData) {
        @strongify(self);
        if (!kaData.count) {
            [self showDefaultNoKeyWorkView:YES];
        }else{
            [self showDefaultNoKeyWorkView:NO];
        }
    }];
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
    
//    [self showDefaultNoKeyWorkView:NO];
    
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
        imageView.image = [UIImage imageNamed:@"placeholder_fancy"];
        [_defaultNoKeyWorkView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_defaultNoKeyWorkView);
            make.centerY.equalTo(_defaultNoKeyWorkView).offset(-20);
        }];
        UILabel * defaulabel = [[UILabel alloc] init];
        defaulabel.text = @"什么也没找到~换个关键词试试~";
        defaulabel.textColor = RGBFromHexadecimal(0x7f7f7f);
        [_defaultNoKeyWorkView addSubview:defaulabel];
        [defaulabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_defaultNoKeyWorkView);
            make.centerY.equalTo(imageView.mas_bottom).offset(20);
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
