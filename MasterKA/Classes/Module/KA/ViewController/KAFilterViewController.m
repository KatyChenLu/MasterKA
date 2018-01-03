//
//  KAFilterViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/10/11.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAFilterViewController.h"
#import "NavCityBtn.h"
#import "KAFilterView.h"
#import "KAHomeTableView.h"
#import "CourseListModel.h"
#import "LeftTitleBtn.h"

@interface KAFilterViewController ()

@property (nonatomic, strong) NavCityBtn *cityBtn;
@property (nonatomic, strong) UIButton *releaseBtn;
@property (nonatomic, strong) KAFilterView *filterView0;
@property (nonatomic, strong) KAFilterView *filterView1;
@property (nonatomic, strong) KAFilterView *filterView2;
@property (nonatomic, strong) KAHomeTableView *kaHomeTableView;
@property (nonatomic, strong) NSArray *itemModelArr;
@property (nonatomic, strong) UIView *filterTitleView;
@property (nonatomic, strong)UIView *conditionView;
@property (nonatomic, strong)NSMutableArray *titleBtnArr;
@property (nonatomic,strong) NSMutableArray *filterArr;
@property (nonatomic,strong)UIView *defaultNoKeyWorkView;


//页数
@property(nonatomic ,copy)NSString * page;
//每页单位
@property(nonatomic ,copy)NSString * page_size;

@property (nonatomic, assign)CGFloat peopleMin;
@property (nonatomic, assign)CGFloat peopleMax;
@property (nonatomic, assign)CGFloat priceMin;
@property (nonatomic, assign)CGFloat priceMax;
@property (nonatomic, assign)CGFloat timeMin;
@property (nonatomic, assign)CGFloat timeMax;

@end

@implementation KAFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.page = @"1";
    self.page_size = @"10";
    
    self.priceMin = [[UserClient sharedUserClient].course_price_min floatValue];
    self.priceMax = [[UserClient sharedUserClient].course_price_max floatValue]+FilterOverFlow;
    self.peopleMin = [[UserClient sharedUserClient].people_num_min floatValue];
    self.peopleMax = [[UserClient sharedUserClient].people_num_max floatValue]+FilterOverFlow;
    self.timeMin = 0;
    self.timeMax = ([UserClient sharedUserClient].course_time.count -1)*10 ;
    
    self.filterArr = [[NSMutableArray alloc] initWithCapacity:3];
    self.titleBtnArr = [[NSMutableArray alloc] initWithCapacity:3];
    
    UIBarButtonItem *fetchItem = [[UIBarButtonItem alloc] initWithCustomView:self.voteNavView];
    
    self.navigationItem.rightBarButtonItem = fetchItem;
    
    [self.view addSubview:self.filterTitleView];
   
    
    [self.view addSubview:self.kaHomeTableView];
    [self.kaHomeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(40);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
     self.kaHomeTableView.baseVC = self;
    
    [self requestKAHomeData];
    @weakify(self);
    [RACObserve(self.kaHomeTableView, kaHomeData) subscribeNext:^(NSMutableArray *kaData) {
        @strongify(self);
        if (!kaData.count) {
            [self showDefaultNoKeyWorkView:YES];
        }else{
            [self showDefaultNoKeyWorkView:NO];
        }
    }];
    
}

- (UIView*)defaultNoKeyWorkView
{
    if (!_defaultNoKeyWorkView) {
        _defaultNoKeyWorkView = [[UIView alloc] init];
        _defaultNoKeyWorkView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_defaultNoKeyWorkView];
        [_defaultNoKeyWorkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.view);
            make.bottom.equalTo(self.mas_bottomLayoutGuide);
            make.top.equalTo(self.filterTitleView.mas_bottom);
        }];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"placeholder_fancy"];
        [_defaultNoKeyWorkView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_defaultNoKeyWorkView);
            make.centerY.equalTo(_defaultNoKeyWorkView).offset(-20);
        }];
        UILabel * defaulabel = [[UILabel alloc] init];
        defaulabel.text = @"什么也没找到~";
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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    [self reloadCntLabel];
    
}

#pragma fanfa
- (void)requestKAHomeData{
    NSInteger  firstInt =  self.timeMin/10;
    NSInteger secondInt = self.timeMax/10;
    NSString *priceMaxStr;
    NSString *peopleMaxStr;
    if ((int)self.priceMax >[[UserClient sharedUserClient].course_price_max floatValue]) {
        priceMaxStr = @"";
    }else{
        priceMaxStr = [NSString stringWithFormat:@"%.f",self.priceMax];
    }
    if ((int)self.peopleMax >[[UserClient sharedUserClient].people_num_max floatValue]) {
        peopleMaxStr = @"";
    }else{
        peopleMaxStr = [NSString stringWithFormat:@"%.f",self.peopleMax];
    }
    
    
    RACSignal *fetchSignal1 = [[HttpManagerCenter sharedHttpManager] getCourseScenesListWithID:self.scenesID peopleMin:[NSString stringWithFormat:@"%.f",self.peopleMin] peopleMax:peopleMaxStr priceMin:[NSString stringWithFormat:@"%.f",self.priceMin] priceMax:priceMaxStr timeMin:[UserClient sharedUserClient].course_time[firstInt] timeMax:[UserClient sharedUserClient].course_time[secondInt] page:self.page pageSize:self.page_size resultClass:nil];
    
    @weakify(self)
    [fetchSignal1 subscribeNext:^(BaseModel *model) {
        @strongify(self)
        if (model.code==200) {
            
            self.kaHomeTableView.kaHomeData = model.data;
            [self.kaHomeTableView reloadData];
        }
        
    }completed:^{
        if(self.kaHomeTableView.mj_header.isRefreshing){
            
            [self.kaHomeTableView.mj_header endRefreshing];
            
        }
        
        if(self.kaHomeTableView.mj_footer.isRefreshing){
            
            [self.kaHomeTableView.mj_footer endRefreshing];
        }
    }];
}
- (KAHomeTableView *)kaHomeTableView {
    if (!_kaHomeTableView) {
        _kaHomeTableView = [[KAHomeTableView alloc]init];
        
        _kaHomeTableView.mj_header = [MasterTableHeaderView addRefreshGifHeadViewWithRefreshBlock:^{
            
            [self first];
            
        }];
        
        _kaHomeTableView.mj_footer = [MasterTableFooterView footerWithRefreshingBlock:^{
            
            [self more];
            
        }];
        
    }
    return _kaHomeTableView;
}
- (void)first {
    [_kaHomeTableView.kaHomeData removeAllObjects];
    self.page = @"1";
    [self requestKAHomeData];
    [_kaHomeTableView reloadData];
}

- (void)more {
    self.page = [NSString stringWithFormat:@"%d",[self.page intValue]+1];
    [self requestKAHomeData];
    
}


- (UIView *)filterTitleView {
    if (!_filterTitleView) {
        _filterTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        _filterTitleView.backgroundColor = [UIColor whiteColor];
        NSArray *titleArr = @[@"预算",@"人数",@"时长"];
        for (int i = 0; i<3; i++) {
            LeftTitleBtn * categoryBtn = [[LeftTitleBtn alloc]initWithFrame:CGRectMake(ScreenWidth/3*i, 0, ScreenWidth/3, 40)];
            [categoryBtn addTarget: self action:@selector(titleAction:) forControlEvents:UIControlEventTouchUpInside];
            [categoryBtn setTitle:titleArr[i] forState:UIControlStateNormal];
            categoryBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            categoryBtn.tag = i;
            [categoryBtn setImage:[[UIImage imageNamed:@"jiantoushang"] imageWithTintColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]] forState:UIControlStateNormal];
            [categoryBtn setImage:[[UIImage imageNamed:@"jiantouxia1"] imageWithTintColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]] forState:UIControlStateSelected];
            [categoryBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
             [categoryBtn setBackgroundImage:[UIImage imageWithColor:RGBFromHexadecimal(0xf8f7f5)] forState:UIControlStateSelected];
            [categoryBtn setBackgroundImage:[UIImage imageWithColor:RGBFromHexadecimal(0xf8f7f5)] forState:UIControlStateHighlighted];
            [categoryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_filterTitleView addSubview:categoryBtn];
            [_titleBtnArr addObject:categoryBtn];
        }
        
    }
    return _filterTitleView;
}
- (KAFilterView *)filterView0 {
    if (!_filterView0) {
        _filterView0 = [[KAFilterView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight) withFilerMin:[[UserClient sharedUserClient].course_price_min floatValue] filerMax:[[UserClient sharedUserClient].course_price_max floatValue]+FilterOverFlow selectMin:self.priceMin selectMax:self.priceMax sliderArr:nil unit:@"￥"];
    }
    return _filterView0;
}
- (KAFilterView *)filterView1 {
    if (!_filterView1) {
        _filterView1 = [[KAFilterView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight) withFilerMin:[[UserClient sharedUserClient].people_num_min floatValue] filerMax:[[UserClient sharedUserClient].people_num_max floatValue]+FilterOverFlow selectMin:self.peopleMin selectMax:self.peopleMax sliderArr:nil unit:nil];
    }
    return _filterView1;
}
- (KAFilterView *)filterView2 {
    if (!_filterView2) {
        _filterView2 = [[KAFilterView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight) withFilerMin:0 filerMax:([UserClient sharedUserClient].course_time.count -1)*10  selectMin:self.timeMin selectMax:self.timeMax sliderArr:[UserClient sharedUserClient].course_time unit:nil];
        
    }
    return _filterView2;
}

- (void)titleAction:(LeftTitleBtn *)sender {
    for (KAFilterView *fil in self.filterArr) {
        [fil removeFromSuperview];
        [self.filterArr removeAllObjects];
    }
 

       if ([_titleBtnArr indexOfObject:sender] == 0){
           
           
           [self.view addSubview:self.filterView0];
           [self.filterView0 animateAction];
           [self.filterArr addObject:self.filterView0];
            @weakify(self);
           [_filterView0 setFilterSendBlock:^(CGFloat min, CGFloat max) {
               @strongify(self);
               self.priceMin = min;
               self.priceMax = max;
                 [self first];
               for (LeftTitleBtn *btn in self.titleBtnArr) {
                   btn.selected = NO;
                   [self.filterView0 baceAnimateAction];
               }
           }];
           
           [_filterView0 setTouchBlock:^{
               @strongify(self);
               for (LeftTitleBtn *btn in self.titleBtnArr) {
                   btn.selected = NO;
//                    [self.filterView0 baceAnimateAction];
               }
               
           }];
       }else if ([_titleBtnArr indexOfObject:sender] == 1) {
           [self.view addSubview:self.filterView1];
            [self.filterView1 animateAction];
             [self.filterArr addObject:self.filterView1];
           @weakify(self);
           [_filterView1 setFilterSendBlock:^(CGFloat min, CGFloat max) {
               @strongify(self);
               self.peopleMin = min;
               self.peopleMax = max;
               [self first];
               for (LeftTitleBtn *btn in self.titleBtnArr) {
                   btn.selected = NO;
                   [self.filterView1 baceAnimateAction];
               }
               
           }];
           [_filterView1 setTouchBlock:^{
               @strongify(self);
               for (LeftTitleBtn *btn in self.titleBtnArr) {
                   
                   btn.selected = NO;
//                   [self.filterView1 baceAnimateAction];
               }
               
           }];
       } else if ([_titleBtnArr indexOfObject:sender] == 2){
             [self.view addSubview:self.filterView2];
            [self.filterView2 animateAction];
             [self.filterArr addObject:self.filterView2];
            @weakify(self);
            [_filterView2 setFilterSendBlock:^(CGFloat min, CGFloat max) {
                @strongify(self);
                self.timeMin = min;
                self.timeMax = max;
                 [self first];
                for (LeftTitleBtn *btn in self.titleBtnArr) {
                    btn.selected = NO;
                    [self.filterView2 baceAnimateAction];
                }
               
            }];
           [_filterView2 setTouchBlock:^{
               @strongify(self);
               for (LeftTitleBtn *btn in self.titleBtnArr) {
                   
                   btn.selected = NO;
//                   [self.filterView2 baceAnimateAction];
               }
               
           }];
         
        }
 
    for (LeftTitleBtn *btn in _titleBtnArr) {
        if (btn.tag == [_titleBtnArr indexOfObject:sender]) {
            if (sender.selected) {
                KAFilterView *selecFilter = [self.filterArr objectAtIndex:0];
                [selecFilter baceAnimateAction];
            }
            sender.selected = !sender.selected;
        }else{
            btn.selected = NO;
        }
        
    }
    
//    if (sender.selected) {
////        sender.imageView.tintColor = RGBFromHexadecimal(0xff5e28);
//    }
     [self.view bringSubviewToFront:self.filterTitleView];
    
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
