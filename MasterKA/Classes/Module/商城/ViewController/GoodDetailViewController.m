//
//  GoodDetailViewController.m
//  MasterKA
//
//  Created by hyu on 16/5/13.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "GoodDetailViewController.h"
#import "GoodDetailModel.h"
#import "CouseDetailHeadView.h"
#import "QuestionView.h"
#import "PaySuccessController.h"
@interface GoodDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic,strong) GoodDetailModel*viewModel;
@property (nonatomic,strong)UIBarButtonItem *shangchuan;
@property (nonatomic,strong)UIButton *shoucang;
@property(nonatomic,strong) QuestionView *quest;
@property (nonatomic,assign)float lastAlphaNavigationBar;
@end

@implementation GoodDetailViewController
@synthesize viewModel = _viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel.title = @"课程详情";
    NSString *courseId =self.params[@"courseId"];
    if (courseId==nil) {
        courseId =self.params[@"course_id"];
    }
    if (courseId) {
        self.course_id = courseId;
    }
    
    
    @weakify(self)
    __weak typeof(self)weakSelf = self;
    [self.viewModel setGroup_buy:^(NSDictionary * dic){
        @strongify(self)
        self.yueIt.hidden=YES;
        
        self.isGroupCourse.hidden = NO;

        self.alonePriceLab.text = [NSString stringWithFormat:@"¥%@" ,dic[@"price"]];
        self.groupPriceLab.text = [NSString stringWithFormat:@"¥%@" ,dic[@"groupby_info"][@"group_price"]];
        self.groupLab.text = [NSString stringWithFormat:@"%@人团还少%@位就满团了",dic[@"groupby_info"][@"group_num"],dic[@"groupby_info"][@"group_num_last"]];
        
    }];

    
    self.isGroupCourse.hidden = YES;
    
    self.viewModel.course_id = self.course_id;
    [self.viewModel bindTableView:self.mTableView];
    UIView *headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    _mineHeadView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    [headerView addSubview:_mineHeadView];
    self.mTableView.tableHeaderView=headerView;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeolder"]];
    backImageView.frame = CGRectMake(0, ScreenWidth, ScreenWidth, 400);
    [backgroundView addSubview:backImageView];
    self.mTableView.backgroundView =  backgroundView;
    
    self.shangchuan = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shangchuan"] style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonOnClick:)];
    [self.navigationItem addRightBarButtonItem:self.shangchuan animated:YES];
    _shoucang = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shoucang setFrame:CGRectMake(0, 0, 50, 50)];
    [_shoucang setImageEdgeInsets:UIEdgeInsetsMake(-3, 0, 0, 0)];
    [_shoucang sizeToFit];
    UIBarButtonItem*shoucangItem = [[UIBarButtonItem alloc] initWithCustomView:_shoucang];
    [self.navigationItem addRightBarButtonItem:shoucangItem animated:YES];
    
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor blackColor]};
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImageAlpha:self.lastAlphaNavigationBar];
//    [self.mTableView reloadData];
      [self.viewModel first];
}


-(void)qusetion
{
    
    [self.navigationController pushViewController:[[PaySuccessController alloc]init] animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImageAlpha:1.0f];
    self.tabBarController.tabBar.hidden =YES;
}

- (GoodDetailModel*)viewModel
{
    if (!_viewModel) {
        _viewModel = [[GoodDetailModel alloc] initWithViewController: self];
    }
    return _viewModel;
}
- (void)bindViewModel{
    [super bindViewModel];
   NSString * url = [self.params[@"coverStr"] masterFullImageUrl];
    
    @weakify(self);
    [RACObserve(self.viewModel, info) subscribeNext:^(NSDictionary *info) {
        @strongify(self);
        
        [self.mineHeadView setImageWithURLString:info[@"cover"] placeholderImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]]];
        self.mineHeadView.contentMode = UIViewContentModeScaleAspectFill;
        if([info[@"is_enterprise"]intValue]==1){
            self.yueIt.hidden=YES;
//            self.group_buyBtn.hidden=YES;
            self.teleToCompany.hidden=NO;
        }else{
            self.teleToCompany.hidden=YES;
        }
        if([info[@"is_collect"] isEqual:@"1"]){
            [_shoucang setImage:[UIImage imageNamed:@"shoucanghong"] forState:UIControlStateNormal];
        }else{
             [_shoucang setImage:[UIImage imageNamed:@"shoucangCourse"] forState:UIControlStateNormal];
        }
    }];
    [[self.yueIt rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.engagements execute:x];
    }];
    
    //单人购买
    [[self.alone_buyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.engagements execute:x];
    }];
    
    //团购
    [[self.group_buyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.engagements execute:x];
    }];
   
    
//    [[self.group_buyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self);
//        [self.viewModel.engagements execute:x];
//    }];
    
//    [[self.yueIt rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self);
//        if([self.viewModel.info[@"is_group"]isEqual: @"1"]){
//            if(![self.viewModel.info[@"course_cfg"] isEqual:@[]]){
//                [self gotoSelectView:0];
//            }else{
//                [self pushtoCourseDateViewController:nil];
//            }
//            
//        }else{
//            [self pushtoCourseDateViewController:nil];
//        }
//
//
    
    
    
    self.question = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.question setImage:[UIImage imageNamed:@"question-1"] forState:UIControlStateNormal];
    
//    self.question.backgroundColor = [UIColor redColor];
    
//    self.question.frame = CGRectMake(self.view.width-60, self.view.height-100, 50, 50);
    
    //    [[UIApplication sharedApplication].keyWindow addSubview:self.question];
    
    [self.view addSubview:self.question];
    
    [self.question mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@50);
        make.height.mas_equalTo(@50);
        make.right.equalTo(self.view).offset(-8);
        make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(-50);
    }];

    
    
    [[self.question rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"QuestionView" owner:nil options:nil];
        self.quest = [nibView objectAtIndex:0];
        self.quest.frame=CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
        [self.view addSubview:self.quest];
        [UIView animateWithDuration:0.4 animations:^{
            self.quest.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        } completion:^(BOOL finish){
            self.quest.backColor.backgroundColor=[UIColor blackColor];
        }];
        [self.quest.telePhone addTarget:self action:@selector(phoneMaster:) forControlEvents:UIControlEventTouchUpInside];
        [self.quest.question addTarget:self action:@selector(questionToMaster) forControlEvents:UIControlEventTouchUpInside];
        [self.quest.removeView addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *remove =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
        [self.quest.backColor addGestureRecognizer:remove];
    }];
    [[self.shoucang rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if ([self doLogin]) {
            if ([self.viewModel.info[@"is_collect"] isEqual:@"0"]) {
                [[[HttpManagerCenter sharedHttpManager] collectCourse:self.course_id resultClass:nil] subscribeNext:^(BaseModel *model) {
                    @strongify(self)
                    if (model.code==200) {
                        [_shoucang setImage:[UIImage imageNamed:@"shoucanghong"] forState:UIControlStateNormal];
                        [self.viewModel.info setValue:@"1" forKey:@"is_collect"];
                        [self toastWithString:model.message error:NO];
                    }else{
                        [self toastWithString:model.message error:YES];
                    }
                }];
            }else{
                [[[HttpManagerCenter sharedHttpManager] removeCollectCourse:self.course_id resultClass:nil] subscribeNext:^(BaseModel *model) {
                    @strongify(self)
                    if (model.code==200) {
                        if(self.lastAlphaNavigationBar>0.5){
                            [_shoucang setImage:[UIImage imageNamed:@"shoucang-hei"] forState:UIControlStateNormal];
                        }else{
                            [_shoucang setImage:[UIImage imageNamed:@"shoucangCourse"] forState:UIControlStateNormal];
                        }
                        [self.viewModel.info setValue:@"0" forKey:@"is_collect"];
                        [self toastWithString:model.message error:NO];
                    }else{
                        [self toastWithString:model.message error:YES];
                    }
                }];
            }
        }else{
            
        }
    }];
    
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
    
    [[self.teleToCompany rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
//        [self showPhonesActionSheet:CustomerServicePhone];
        [self phoneMaster:nil];
    }];


}

-(void)phoneMaster:(UIButton *)sender{//电话
    [self showPhonesActionSheet:self.viewModel.info[@"course_mobile"]];
    [self removeView];
}
-(void)questionToMaster{//私信
    NSString * url = [NSString stringWithFormat:@"%@?userId=%@",URL_IMChating,self.viewModel.info[@"uid"]];
    [self pushViewControllerWithUrl:url];
      [self removeView];
}
-(void)removeView{
    _quest.backColor.backgroundColor=[UIColor clearColor];
    [UIView animateWithDuration:0.4 animations:^{
        _quest.frame=CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    } completion:^(BOOL finish){
        [_quest removeFromSuperview];
    }];
}
- (void)changeBarButtonColor:(BOOL)black{
    if (black) {
        self.shangchuan.tintColor = [UIColor blackColor];
        if([self.viewModel.info[@"is_collect"] isEqual:@"0"]){
            [_shoucang setImage:[UIImage imageNamed:@"shoucang-hei"] forState:UIControlStateNormal];
        }
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
        self.title=@"课程详情";
         self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor blackColor]};
    }else{
        self.title=@"";
        self.shangchuan.tintColor = [UIColor whiteColor];
        if([self.viewModel.info[@"is_collect"] isEqual:@"0"]){
            [_shoucang setImage:[UIImage imageNamed:@"shoucangCourse"] forState:UIControlStateNormal];
        }
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    }
}
- (void)shareButtonOnClick:(id)sender{
    if (self.viewModel.info) {
        [self shareContentOfApp:self.viewModel.info[@"share_data"]];
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
