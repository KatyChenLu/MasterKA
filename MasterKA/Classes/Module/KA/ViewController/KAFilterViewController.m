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
@property (nonatomic, strong) KAFilterView *filterView;
@property (nonatomic, strong) KAHomeTableView *kaHomeTableView;
@property (nonatomic, strong) NSArray *itemModelArr;
@property (nonatomic, strong) UIView *filterTitleView;
@property (nonatomic, strong)UIView *conditionView;
@property (nonatomic, strong)NSMutableArray *titleBtnArr;
@property (nonatomic,strong) NSMutableArray *filterArr;

@end

@implementation KAFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.titleBtnArr = [[NSMutableArray alloc] initWithCapacity:3];
    
    UIBarButtonItem *fetchItem = [[UIBarButtonItem alloc] initWithCustomView:self.voteNavView];
    
    self.navigationItem.rightBarButtonItem = fetchItem;
    
    [self.view addSubview:self.filterTitleView];
    
    [self.view addSubview:self.kaHomeTableView];
    [self.kaHomeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(50);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
     self.kaHomeTableView.baseVC = self;
    
    [self requestKAHomeData:@"1" pageId:@"1"];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
     self.cntLabel.text = [NSString stringWithFormat:@"%ld",[UserClient sharedUserClient].voteNum];
    
}

#pragma fanfa
- (void)requestKAHomeData:(NSString*)page pageId:(NSString*)pageId {
    
    
    RACSignal *fetchSignal1 = [[HttpManagerCenter sharedHttpManager] getCategoryList:@"0" order_type:nil select_type:nil page:@"1" page_size:@"10" resultClass:[CourseListModel class]];
    
    @weakify(self)
    [fetchSignal1 subscribeNext:^(BaseModel *model) {
        @strongify(self)
        if (model.code==200) {
            
            
            CourseListModel * course = model.data;
            
            self.itemModelArr = course.item_list;
            
            
            self.kaHomeTableView.kaHomeData = course.course_list;
            [self.kaHomeTableView reloadData];
        }
        
    }completed:^{
        
    }];
}
- (KAHomeTableView *)kaHomeTableView {
    if (!_kaHomeTableView) {
        _kaHomeTableView = [[KAHomeTableView alloc]init];
        
        
    }
    return _kaHomeTableView;
}



- (UIView *)filterTitleView {
    if (!_filterTitleView) {
        _filterTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 42)];
        NSArray *titleArr = @[@"预算",@"人数",@"时长"];
        for (int i = 0; i<3; i++) {
            LeftTitleBtn * categoryBtn = [[LeftTitleBtn alloc]initWithFrame:CGRectMake(ScreenWidth/3*i, 0, ScreenWidth/3, 50)];
            [categoryBtn addTarget: self action:@selector(titleAction:) forControlEvents:UIControlEventTouchUpInside];
            [categoryBtn setTitle:titleArr[i] forState:UIControlStateNormal];
            categoryBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            categoryBtn.tag = i*1000;
            categoryBtn.backgroundColor = [UIColor whiteColor];
            [categoryBtn setImage:[UIImage imageNamed:@"jiantouxia1"] forState:UIControlStateNormal];
            [categoryBtn setImage:[UIImage imageNamed:@"jiantoushang"] forState:UIControlStateSelected];
            [categoryBtn setTitleColor:RGBFromHexadecimal(0xff5e28) forState:UIControlStateSelected];
            [categoryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_filterTitleView addSubview:categoryBtn];
            [_titleBtnArr addObject:categoryBtn];
        }
        
    }
    return _filterTitleView;
}

- (void)titleAction:(LeftTitleBtn *)sender {

    
   
        [self.filterView removeFromSuperview];
        self.filterView = nil;
    
        if ([_titleBtnArr indexOfObject:sender]*1000 == 1000) {
            _filterView = [[KAFilterView alloc] initWithFrame:CGRectMake(0, 42, ScreenWidth, ScreenHeight) withType:optionFilter];
            
            
        }else if ([_titleBtnArr indexOfObject:sender]*1000 == 0){
            _filterView = [[KAFilterView alloc] initWithFrame:CGRectMake(0, 42, ScreenWidth, ScreenHeight) withType:jampanFilter];
            
            
        }else if ([_titleBtnArr indexOfObject:sender]*1000 == 2000){
            _filterView = [[KAFilterView alloc] initWithFrame:CGRectMake(0, 42, ScreenWidth, ScreenHeight) withType:optionFilter];
            
        }
        _filterView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
        
        
        [self.view addSubview:self.filterView];
        @weakify(self);
        [_filterView setTouchBlock:^{
            @strongify(self);
            for (LeftTitleBtn *btn in self.titleBtnArr) {
                
                btn.selected = NO;
                _filterView = nil;
            }
            
        }];
  
  
    
    
    
    for (LeftTitleBtn *btn in _titleBtnArr) {
        if (btn.tag == [_titleBtnArr indexOfObject:sender]*1000) {
            sender.selected = !sender.selected;
        }else{
            btn.selected = NO;
        }
        
    }
    
    if (sender.selected) {
        sender.imageView.tintColor = RGBFromHexadecimal(0xff5e28);
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)filterArr {
    if (!_filterArr) {
        
        NSArray* arr = @[@{@"title":@"不限",@"value":@""},
                         @{@"title":@"¥ 0~99",@"value":@"1"},
                         @{@"title":@"¥ 99~199",@"value":@"2"},
                         @{@"title":@"¥ 199~929",@"value":@"3"},
                         @{@"title":@"¥ 299~399",@"value":@"4"},
                         ];
        _filterArr =[[NSMutableArray alloc]initWithArray:arr];
    }
    return _filterArr;
}

- (void)creatUIWithFilterArr:(NSArray *)filterArr {
    
    int totalloc =3;
    CGFloat btnVH = 30; //高
    CGFloat margin = 30; //间距
    
    CGFloat btnVW = (ScreenWidth-margin*(totalloc+1))/totalloc; //宽
    
    int count =(int)filterArr.count;
    for (int i=0;i<count;i++){
        int row =i/totalloc;  //行号
        int loc =i%totalloc;  //列号
        CGFloat btnVX =margin+(margin +btnVW)*loc;
        CGFloat btnVY =40+(margin +btnVH)*row;
        
        UIButton *starBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        starBtn.frame = CGRectMake(btnVX, btnVY, btnVW, btnVH);
        [starBtn setTitle:[NSString stringWithFormat:@"%@",filterArr[i][@"title"]] forState:UIControlStateNormal];
        [starBtn setTitleColor:RGBFromHexadecimal(0xeb3027) forState:UIControlStateSelected];
        [starBtn setTitleColor:RGBFromHexadecimal(0x999999) forState:UIControlStateNormal];
        starBtn.titleLabel.font =[UIFont systemFontOfSize:10];
        starBtn.tag=i+100;
        starBtn.layer.cornerRadius=5;
        starBtn.layer.borderColor =[UIColor colorWithWhite:0.6 alpha:1].CGColor;
        starBtn.layer.borderWidth=1;
        [starBtn  addTarget:self action:@selector(starBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.conditionView addSubview: starBtn];
    }
    
//    _slider = [[JLDoubleSlider alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth- 50, 50)];
//    _slider.unit = @"￥";
//    _slider.minNum = 10;
//    _slider.maxNum = 200;
//    _slider.minTintColor = [UIColor redColor];
//    _slider.maxTintColor = [UIColor blueColor];
//    _slider.mainTintColor = [UIColor blackColor];
    
    //    [self.view addSubview:_slider];
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
