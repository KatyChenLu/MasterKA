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
@property (nonatomic,assign)float lastAlphaNavigationBar;
@property (nonatomic, strong) UIView *FootView;
@property (nonatomic,strong)UIBarButtonItem *shareBarBtn;
@property (nonatomic,strong)UIButton *shoucangBtn;
@property (nonatomic,strong)UIButton *shareBtn;
@property(nonatomic ,strong)UILabel * commentLabel;

@property(nonatomic ,assign)CGFloat totalWidth;

@property(nonatomic ,strong)UILabel * beforeLabel;
@property(nonatomic ,strong)UIView *tipView;
@end

@implementation KADetailViewController
@synthesize viewModel = _viewModel;
- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.frame = CGRectMake(0, 0, 30, 30);
        [_shareBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}
-  (UIButton *)shoucangBtn {
    if (!_shoucangBtn) {
        _shoucangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         _shoucangBtn.frame = CGRectMake(0, 0, 30, 30);
        [_shoucangBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
        [_shoucangBtn addTarget:self action:@selector(shoucangButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shoucangBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.viewModel.title = @"xiangqing";
    
    NSString *courseId =self.params[@"ka_course_id"];
    if (courseId==nil) {
        courseId =self.params[@"ka_course_id"];
    }
    if (courseId) {
        self.ka_course_id = courseId;
    }
    
    self.viewModel.ka_course_id = self.ka_course_id;
    
    UIBarButtonItem *voteBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.voteNavView];
    [self.voteBtn setImage:[UIImage imageNamed:@"投票箱白色"] forState:UIControlStateNormal];

    UIBarButtonItem *foc0 = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)]];
    
    
    UIBarButtonItem *shareBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.shareBtn];
    UIBarButtonItem *foc1 = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)]];
    
    UIBarButtonItem *shoucangBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.shoucangBtn];

    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:voteBarBtnItem,foc0,shareBarBtnItem,foc1,shoucangBarBtnItem, nil];
    
    
    [self.view addSubview:self.tableView];
    [self.viewModel bindTableView:self.tableView];
    
    UIView *headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*234/375)];
    _mineHeadView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*234/375)];
    _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenWidth*234/375 -30, ScreenWidth, 20)];
    
    [headerView addSubview:_mineHeadView];
    [headerView addSubview:_tipView];
    self.tableView.tableHeaderView=headerView;
    [self.mineHeadView setImageWithURLString:[self.headViewUrl ClipImageUrl:[NSString stringWithFormat:@"%f",ScreenWidth*0.7*[UIScreen mainScreen].scale]] placeholderImage:nil];
    
    [self.view addSubview:self.FootView];
     self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor blackColor]};
    
}
#pragma shengmingzhouqi

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    UIView *view = [self.navigationController.navigationBar viewWithTag:20];
//    [view removeFromSuperview];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImageAlpha:self.lastAlphaNavigationBar];
    [self reloadCntLabel];
//    [self.viewModel first];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar setBackgroundImageAlpha:1.0f];
    self.tabBarController.tabBar.hidden =YES;
}
#pragma jichengfnagfa

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
    [RACObserve(self.viewModel, info) subscribeNext:^(NSDictionary *info) {
        @strongify(self);
        
        if (self.params[@"ka_course_id"]) {
            
          [self.mineHeadView setImageWithURLString:[info[@"course_cover"] ClipImageUrl:[NSString stringWithFormat:@"%f",ScreenWidth*0.7*[UIScreen mainScreen].scale]] placeholderImage:nil];
        }
//        [self.mineHeadView setImageWithURLString:info[@"course_cover"] placeholderImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.headViewUrl masterFullImageUrl]]]]];

        [self createTags:info[@"tags_name"]];
        
        if([info[@"is_like"] isEqual:@"0"]||info == nil){
            [self.shoucangBtn setImage:[UIImage imageNamed:@"收藏白色"] forState:UIControlStateNormal];
        }else if([info[@"is_like"] isEqual:@"1"]){
            [self.shoucangBtn setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateNormal];
        }
    }];
    
    [[[RACObserve(self.viewModel, alphaNavigationBar) distinctUntilChanged] filter:^BOOL(NSNumber *x) {
        return x.floatValue>=0.0f && x.floatValue<=1.0f;
    }] subscribeNext:^(NSNumber *x) {
        @strongify(self)
        float alpha = [x floatValue];
        self.lastAlphaNavigationBar = alpha;
        if (alpha>0.2) {
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

//topic
- (UILabel *)commentLabel{
    
    if (!_commentLabel) {
        
        _commentLabel = [[UILabel alloc]init];
        
        _commentLabel.textColor = [UIColor blackColor];
        
        _commentLabel.font = [UIFont fontWithName:SpecialFont  size:10];
        
        _commentLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        
        _commentLabel.tag = 0;
        
        _commentLabel.textAlignment = NSTextAlignmentCenter;
        
        _commentLabel.userInteractionEnabled = YES;
        
        _commentLabel.layer.cornerRadius = 3.0f;
        _commentLabel.layer.masksToBounds = YES;
        
    }
    
    return _commentLabel;
    
}
- (void)createTags:(NSArray *)tagArr{
    [self.tipView addSubview:self.commentLabel];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipView);
        
        make.left.equalTo(self.tipView).offset(10);
        
        make.height.equalTo(@20);
    }];
    
    self.commentLabel.text = tagArr[0];

    NSMutableArray * topicLabels = [NSMutableArray arrayWithCapacity:10];
    
    for (int i =0; i<tagArr.count; i++) {
        if (i == 0) {
            CGSize size  = [tagArr[0] sizeWithAttributes:@{NSFontAttributeName : [UIFont fontWithName:SpecialFont  size:10]}];
            NSInteger firstW = size.width + 10.0;
            [self.commentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(firstW);
            }];
            
            self.totalWidth = size.width +10;
            
            self.beforeLabel = _commentLabel;
        }else {
            UILabel *nextLabel = [[UILabel alloc] init];
            nextLabel.text = tagArr[i];
            nextLabel.tag = i;
            nextLabel.textColor = [UIColor blackColor];
            
            nextLabel.font = [UIFont fontWithName:SpecialFont  size:12];
            
            nextLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
            nextLabel.textAlignment = NSTextAlignmentCenter;
            
            nextLabel.layer.cornerRadius = 3.0f;
            nextLabel.layer.masksToBounds = YES;
            [topicLabels addObject:nextLabel];
            [self.tipView addSubview:nextLabel];
            CGSize nextSize  = [tagArr[i] sizeWithAttributes:@{NSFontAttributeName : [UIFont fontWithName:SpecialFont  size:10]}];
            
            if (self.totalWidth + 6+10+nextLabel.width <=ScreenWidth) {
                [nextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.beforeLabel.mas_right).offset(6);
                    
                    make.top.equalTo(self.beforeLabel);
                    
                    make.width.mas_equalTo(nextSize.width+10);
                    
                    make.height.equalTo(@20);
                }];
                self.totalWidth += (nextSize.width +6);
            }else {
                
                [nextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(self.commentLabel);
                    
                    make.top.equalTo(self.beforeLabel.mas_bottom).offset(10);
                    
                    make.height.equalTo(@12);
                    
                }];
                
                self.totalWidth = nextSize.width + 10;
            }
            self.beforeLabel = nextLabel;
            
        }
        
    }
    
}

- (void)changeBarButtonColor:(BOOL)black{
    if (black) {
        [self.voteBtn setImage:[UIImage imageNamed:@"投票箱"] forState:UIControlStateNormal];
        
        [self.shareBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
        
        if([self.viewModel.info[@"is_like"] isEqual:@"0"]){
          [self.shoucangBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
        }
        
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
//        self.title=self.viewModel.info[@"course_title"];
//        self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor blackColor]};
    }else{
//        self.title=@"";
         [self.voteBtn setImage:[UIImage imageNamed:@"投票箱白色"] forState:UIControlStateNormal];
        [self.shareBtn setImage:[UIImage imageNamed:@"分享白色"] forState:UIControlStateNormal];
        if([self.viewModel.info[@"is_like"] isEqual:@"0"]){
            [self.shoucangBtn setImage:[UIImage imageNamed:@"收藏白色"] forState:UIControlStateNormal];
        }
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    }
}

- (void)dingzhi:(UIButton *)sender {
    if([self doLogin]){
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"KA" bundle:[NSBundle mainBundle]];
    KACustomViewController *myView = [story instantiateViewControllerWithIdentifier:@"KACustomViewController"];
    myView.courseID = self.ka_course_id;
    myView.courseTitle = self.viewModel.info[@"course_title"];
    [self pushViewController:myView animated:YES];
    }
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(UIView *)FootView {
    if (!_FootView) {
        _FootView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 42 - (IsPhoneX?34:0), ScreenWidth, 42)];
       
        UIButton *dingzhiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dingzhiBtn.frame = CGRectMake(0, 0, ScreenWidth, 45);
        [dingzhiBtn setTitle:@"定制需求" forState:UIControlStateNormal];
        dingzhiBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
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
- (void)shareButtonOnClick {
    [self shareContentOfApp:self.viewModel.info[@"share_data"]];
}
- (void)shoucangButtonOnClick {
    if ([self doLogin]) {
          @weakify(self);
        if ([self.viewModel.info[@"is_like"] isEqual:@"0"]) {
            [[[HttpManagerCenter sharedHttpManager] addLikeCource:self.ka_course_id resultClass:nil] subscribeNext:^(BaseModel *model) {
                @strongify(self)
                if (model.code==200) {
                    [self.shoucangBtn setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateNormal];
                    [self.viewModel.info setValue:@"1" forKey:@"is_like"];
                    [self toastWithString:model.message error:NO];
                }else{
                    [self toastWithString:model.message error:YES];
                }
            }];
        }else{
            [[[HttpManagerCenter sharedHttpManager] cancelLikeCource:self.ka_course_id resultClass:nil] subscribeNext:^(BaseModel *model) {
                @strongify(self)
                if (model.code==200) {
                    if(self.lastAlphaNavigationBar>0.5){
                        [self.shoucangBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
                    }else{
                        [self.shoucangBtn setImage:[UIImage imageNamed:@"收藏白色"] forState:UIControlStateNormal];
                    }
                    [self.viewModel.info setValue:@"0" forKey:@"is_like"];
                    [self toastWithString:model.message error:NO];
                }else{
                    [self toastWithString:model.message error:YES];
                }
            }];
        }
    }
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
