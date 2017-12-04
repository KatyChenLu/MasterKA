//
//  MasterOrUserHomepageViewController.m
//  MasterKA
//
//  Created by hyu on 16/5/23.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MasterOrUserHomepageViewController.h"
#import "MasterOrUserHomepageModel.h"
#import "UIImageView+LBBlurredImage.h"
#import "SlideNavigationController.h"

@interface MasterOrUserHomepageViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic,strong) MasterOrUserHomepageModel*viewModel;
@property (nonatomic,strong)UIBarButtonItem *shangchuan;
@property(strong,nonatomic)UIWindow *window;

@property (nonatomic,assign)float lastAlphaNavigationBar;
@end

@implementation MasterOrUserHomepageViewController
@synthesize viewModel = _viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.viewModel bindTableView:self.mTableView];
    self.viewModel.uid=self.params[@"uid"];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackNormal"]
                                                                 style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    
    _shangchuan = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Share_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonOnClick:)];
    [self.navigationItem addRightBarButtonItem:_shangchuan animated:YES];

    if (@available(iOS 11.0, *)) {
        
        self.mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImageAlpha:1.0f];
    self.tabBarController.tabBar.hidden =YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImageAlpha:self.lastAlphaNavigationBar];
    
}

- (MasterOrUserHomepageModel*)viewModel
{
    if (!_viewModel) {
        _viewModel = [[MasterOrUserHomepageModel alloc] initWithViewController: self];
    }
    return _viewModel;
}
- (MyDetailCell*)mineHeadView
{
    if (!_mineHeadView) {
    }
    return _mineHeadView;
}


- (void)bindViewModel{
    [super bindViewModel];
    @weakify(self);
    [[RACObserve(self.viewModel, info) filter:^BOOL(id value) {
        return value!=nil;
    }] subscribeNext:^(NSDictionary *info) {
        @strongify(self);
        self.mineHeadView = [MyDetailCell loadInstanceFromNib];
        self.mTableView.tableHeaderView=self.mineHeadView.contentView;
        
        [self.mineHeadView.cover sd_setImageWithURL:[NSURL URLWithString:[info[@"cover"] masterFullImageUrl]]placeholderImage:[UIImage imageNamed:@"touxiangbeijing"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
            if(image==nil){ image=[UIImage imageNamed:@"touxiangbeijing"];}
            [self.mineHeadView.blurImageView setImageToBlur:image
                                                 blurRadius:kLBBlurredImageDefaultBlurRadius
                                            completionBlock:^(){
                                                NSLog(@"The blurred image has been set");
                                            }];
        }];
        [self.mineHeadView.img_top setImageWithURLString:info[@"img_top"] placeholderImage:[UIImage imageNamed:@"xiaotouxiang"]];
        [self.mineHeadView.img_top setCanBrowser:YES];
        self.mineHeadView.img_top.browserImages = @[[info[@"img_top"] masterFullImageUrl]];
        self.mineHeadView.nikename.text =info[@"nikename"];
        if([self.viewModel.info[@"identity"] integerValue]== 2){
            self.mineHeadView.identifier.hidden=NO;
            self.mineHeadView.identifier.image=[UIImage imageNamed:@"master"];
            self.mineHeadView.identifier.contentMode=UIViewContentModeScaleAspectFit;
        }else{
            self.mineHeadView.identifier.hidden=YES;
        }
        self.mineHeadView.zanNum.text =info[@"by_like_num"];
        self.mineHeadView.by_browse_num.text =info[@"by_browse_num"];
        if ([info[@"is_like"] intValue] ==1) {
            [self.dianZan setImage:[UIImage imageNamed:@"dianzan-hong"] forState:UIControlStateNormal];
            [self.dianZan setTitle:@"已赞" forState:UIControlStateNormal];
        }else{
            [self.dianZan setImage:[UIImage imageNamed:@"dianzan"] forState:UIControlStateNormal];
            [self.attention setTitle:@"点赞" forState:UIControlStateNormal];
        }
        if ([info[@"is_follow"] intValue] ==1) {
            [self.attention setImage:[UIImage imageNamed:@"yiguanzhu"] forState:UIControlStateNormal];
            [self.attention setTitle:@"已关注" forState:UIControlStateNormal];
        }else{
            [self.attention setImage:[UIImage imageNamed:@"attention"] forState:UIControlStateNormal];
            [self.attention setTitle:@"关注" forState:UIControlStateNormal];
        }
    }];
    [[self.dianZan rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.dianZan execute:x];
    }];
    [[self.question rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.question execute:x];
    }];
    [[self.attention rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.attention execute:x];
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
    
}
- (void)changeBarButtonColor:(BOOL)black{
    if (black) {
        self.shangchuan.tintColor = [UIColor blackColor];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
        self.title=@"个人主页";
    }else{
        self.title=@"";
        self.shangchuan.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    }
}
- (void)shareButtonOnClick:(id)sender{
    if (self.viewModel.info) {
        NSDictionary *shareData =self.viewModel.info[@"share_data"];
        [self shareContentOfApp:shareData];
        //        [self shareContentOfApp:self.viewModel.shareDetailModel.share[@"title"] content:self.viewModel.shareDetailModel.share[@"content"] imageUrl:self.viewModel.shareDetailModel.share[@"cover"]];
    }
}


- (void)gotoBack{
    [self.searchTitleView resignFirstResponder];
    
    if ([self canGotoBack]) {
        [self.navigationController popViewControllerAnimated:YES];
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
