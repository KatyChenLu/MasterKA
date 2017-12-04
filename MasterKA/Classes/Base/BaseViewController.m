 //
//  BaseViewController.m
//  MasterKA
//
//  Created by jinghao on 15/12/11.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "BaseViewController.h"
#import "MasterTableHeaderView.h"
#import "MasterTableFooterView.h"
#import "LoadingFailView.h"
#import "TableViewModel.h"
#import "GoodsHomeViewController.h"
#import "DBHelper.h"
#import "AppConfigModel.h"
#import "UIButton+Master.h"
#import "ShopBaseViewController.h"
//#import "NewSearchViewController.h"
#import "SelectDetailController.h"
//#import "MasterShareSearchViewController.h"
#import "KAVoteViewController.h"
#import "KAHomeViewController.h"

@interface BaseViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong)UIScrollView *freshScrollView;
@property (nonatomic,strong)LoadingFailView *loadingFailView;
@property (nonatomic, strong, readwrite) BaseViewModel *viewModel;
@property (nonatomic, strong, readwrite) UserClient *userClient;
@property (nonatomic,strong,readwrite)UITextField *searchTitleView;
@property (nonatomic,strong)NSDictionary *requestAlert;
@property (nonatomic,strong)NSDictionary *userInfo;
@end

@implementation BaseViewController
{
    AppDelegate* appdelegate;
    
    UIView * _locationView;
    
    UIView * _cityView;
    
    UIButton * _selectBtn;
 
    UIImageView * _cityImage;
    
    int _btnTotol;
    
}
@synthesize myLoadView = _myLoadView;
@synthesize loginBackView = _loginBackView;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    BaseViewController *viewController = [super allocWithZone:zone];
    
    @weakify(viewController)
    [[viewController
      rac_signalForSelector:@selector(viewDidLoad)]
     subscribeNext:^(id x) {
         @strongify(viewController)
         [viewController bindViewModel];
     }];
    
    return viewController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideLogView)name:@"HideLoginView" object:nil];
//    self.hidesBottomBarWhenPushed = YES;
    appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    if ([self isKindOfClass:[KAHomeViewController class]]) {
        
    }else if (![self isKindOfClass:[ShopBaseViewController class]]) {
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackNormal"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
        [self.navigationItem setLeftBarButtonItem:backItem];
        
    }
    
    if ([self isKindOfClass:[GoodsHomeViewController class]]) {
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
        [self.navigationItem setLeftBarButtonItem:backItem];
        
        
    }
    
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],
//                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];

    self.hiddenTabbar = YES;
    self.showLeftMenu =NO;
    self.urlManager = [MasterUrlManager shareMasterUrlManager];
    NSString *title = self.params[@"title"];
    if (title) {
        self.viewModel.title = title;
    }
    
    _btnTotol = 0;
    
//    if (self.tabBarController) {
//        self.tabBarController.tabBar.hidden = YES;
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    if(![self isKindOfClass:[SelectDetailController class]]){
     appdelegate.baseVC = self;
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    NSLog(@"viewWillAppear %@  tabbar %d",self,self.tabBarController.tabBar.hidden);
    
    [MobClick beginLogPageView:NSStringFromClass([self class])];//(页面名称)
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.viewModel) {
        self.viewModel.active = YES;
    }
}

-(void)hideLogView{
    _loginBackView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.0];
    self.loginBackView.hidden = YES;

}

-(UIView *)loginBackView
{
    if (!_loginBackView) {
        
        _loginBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
        _loginBackView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.0];
        
        _loginBackView.hidden = YES;
        [self.view.window addSubview:_loginBackView];
    }
    return _loginBackView;
}

-(LoginView *)myLoadView
{
    if (!_myLoadView) {
        _myLoadView = [[LoginView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-60)];
        _myLoadView.backView =self.loginBackView;
        appdelegate.dengluview = _myLoadView;
    }
    
    return appdelegate.dengluview;
}



- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    NSLog(@"viewWillDisappear %@  tabbar %d",self,self.tabBarController.tabBar.hidden);

}

- (UserClient*)userClient
{
    if (!_userClient) {
        _userClient = [UserClient sharedUserClient];
    }
    return _userClient;
}

#pragma mark -- SlideNavigationControllerDelegate

//- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
//{
//    return self.showLeftMenu;
//}


#pragma mark -- 私有方法


- (UITextField*)searchTitleView{
    
    if (!_searchTitleView) {
        
        _searchTitleView = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-60, 30)];
        
        [_searchTitleView setBackgroundColor:[UIColor colorWithHex:0xffffff]];
        
        [_searchTitleView setCornerRadius:15];
        
        _searchTitleView.font = [UIFont systemFontOfSize:13.0f];
        
        _searchTitleView.returnKeyType  = UIReturnKeySearch;
        
        _searchTitleView.enablesReturnKeyAutomatically = NO;
        
        UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];

        _searchTitleView.leftView =leftView;

        _searchTitleView.leftViewMode = UITextFieldViewModeAlways;
        
        _searchTitleView.placeholder =@"搜索分享、达人、课程";
        
        [_searchTitleView setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        
        _searchTitleView.tintColor = [UIColor colorWithHex:0xe2b910];
        
    }
    
    return _searchTitleView;
    
}

- (UIButton *)searchBtn {
    
    if (!_searchBtn) {
        
        _searchBtn= [[UIButton alloc]initWithFrame:CGRectMake(10, 15, 53/1.5, 61/1.5)];
        
        [_searchBtn setImage:[UIImage imageNamed:@"放大镜"] forState:UIControlStateNormal];
        
        [_searchBtn addTarget:self action:@selector(seachclicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return  _searchBtn;
    
}


/**
 *  返回
 *
 */
- (void)gotoBack{
    [self.searchTitleView resignFirstResponder];

    if ([self canGotoBack]) {
        if(appdelegate.isfromprotocol ==YES)
        {
            appdelegate.isfromprotocol =NO;
            [self doLogin];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)gotoBack:(BOOL)animated viewControllerName:(NSString*)viewControllerName{
    
    if ([self canGotoBack]) {
        if (self.navigationController) {
            NSMutableArray* array = [NSMutableArray array];
            for (UIViewController* view in self.navigationController.childViewControllers) {
                NSString* className =  NSStringFromClass([view class]);
                [array addObject:view];
                if ([className isEqualToString:viewControllerName]) {
                    break;
                }
            }
            [self.navigationController setViewControllers:array animated:animated];
        }else{
            [self dismissViewControllerAnimated:animated completion:^{
                
            }];
        }
    }
}

- (void)pushViewControllerFrom:(NSString*)viewControllerName viewController:(UIViewController*)viewController animated:(BOOL)animated
{
    if (self.navigationController) {
        NSMutableArray* array = [NSMutableArray array];
        for (UIViewController* view in self.navigationController.childViewControllers) {
            NSString* className =  NSStringFromClass([view class]);
            [array addObject:view];
            if ([className isEqualToString:viewControllerName]) {
                break;
            }
        }
        [array addObject:viewController];
        [self.navigationController setViewControllers:array animated:animated];
    }else{
        [self presentViewController:viewController animated:animated completion:^{
            
        }];
    }
}

- (NSString*)backTitle{
    if (_backTitle==nil) {
        return @"返回";
    }
    return _backTitle;
}
- (BOOL)canGotoBack{
    return YES;
}

- (LoadingFailView*)loadingFailView{
    if (!_loadingFailView) {
        _loadingFailView = [[LoadingFailView alloc] init];
        _loadingFailView.hidden = TRUE;
        [self.view addSubview:_loadingFailView];
        [_loadingFailView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return _loadingFailView;
}

//- (void)setTitle:(NSString *)title
//{
//    super.title = title;
//    if(title && ![title isEqualToString:self.viewModel.title])
//    {
//        self.viewModel.title = title;
//    }
//}

- (void)bindViewModel
{
    if (self.title) {
        self.viewModel.title = self.title;
    }
    RAC(self, title) = RACObserve(self.viewModel, title);

}

- (void)pushViewControllerWithUrl:(NSString*)url
{
    if ([url hasPrefix:URL_MasterLoginRoot]) {
        if(![self doLogin]){
            return ;
        }
    }
    [self pushViewControllerWithUrl:url callback:nil];
}

- (void)pushViewControllerWithUrl:(NSString*)url callback:(ViewControlerCallback)callback
{
    
    if ([[MasterUrlManager shareMasterUrlManager] isPrivateUrlString:url]) {
        if (![UserClient sharedUserClient].rawLogin) {
            [self doLogin];
            return;
        }
    }
    UIViewController *vct = [self.urlManager viewControllerWithUrl:url];
    if ([vct isKindOfClass:[UINavigationController class]]) {
        [self presentViewController:vct animated:YES completion:^{
            
        }];
    }else{
        vct.callbackBlock = callback;
        [self.navigationController pushViewController:vct animated:YES];
    }
}
- (UIView *)voteNavView {
    if (!_voteNavView) {
        _voteNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
      
        [_voteNavView addSubview:self.voteBtn];
        [_voteNavView addSubview:self.cntLabel];
        self.cntLabel.center = CGPointMake(30, 0);
        
        self.cntLabel.hidden = [UserClient sharedUserClient].voteNum?NO:YES;
        
    }
    return _voteNavView;
}

- (UIButton *)voteBtn{
    if (!_voteBtn) {
        _voteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voteBtn setImage:[UIImage imageNamed:@"投票箱"] forState:UIControlStateNormal];
        _voteBtn.frame = CGRectMake(0, 5, 30, 30);
      [_voteBtn addTarget:self action:@selector(voteClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voteBtn;
}

- (UILabel *)cntLabel {
    if (!_cntLabel) {
        _cntLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        _cntLabel.textColor = [UIColor whiteColor];
        _cntLabel.textAlignment = NSTextAlignmentCenter;
        _cntLabel.font = [UIFont boldSystemFontOfSize:13];
        _cntLabel.backgroundColor =RGBFromHexadecimal(0xfe3600) ;
        _cntLabel.layer.cornerRadius = CGRectGetHeight(_cntLabel.bounds)/2;
        _cntLabel.layer.masksToBounds = YES;
        
    }
    return _cntLabel;
}
#pragma mark -- 公开方法

- (void)showLoadingFailView:(BOOL)show{
    if (self.loadingFailView.hidden == !show) {
        [self.view bringSubviewToFront:self.loadingFailView];
        self.loadingFailView.hidden = show;
    }
}

- (BOOL)doLogin{
    
    BOOL isLogin =[UserClient sharedUserClient].rawLogin;
    
    if (!isLogin) {
        
//        appdelegate.dengluview.backView.hidden = NO;
//        
//        self.loginBackView.hidden = NO;

        
        [self.view.window  addSubview:self.myLoadView];
        self.myLoadView.backView.hidden = NO;
        
        [UIView animateWithDuration:LoginViewShowHideAniTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.myLoadView.frame = CGRectMake(0,60, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-60);
            
            self.myLoadView.backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
            
        } completion:^(BOOL finished) {
        }];
        
    }
    return isLogin;
    
}


-(void)tapEvent:(UITapGestureRecognizer *)recongnizer {
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _cityImage.transform = CGAffineTransformIdentity;
        
    }];
    
    
    
    [_locationView removeFromSuperview];
    
    _locationView = nil;
    
}


-(void)locationClick:(UIButton *)sender {
    

    _selectBtn.selected = NO;
    
    _selectBtn = sender;
    
    sender.selected = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _cityImage.transform = CGAffineTransformIdentity;
        
    }];
    
    
    [_locationView removeFromSuperview];
    
     _locationView = nil;
    
    self.changeCity(sender);
    
    //    [self.navigationController.navigationItem.leftBarButtonItem setTitle:sender.titleLabel.text];
    
    
}



- (void)showHelpImageView:(NSString*)imageName{
    //    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (Int64)(2 * NSEC_PER_SEC));
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults removeObjectForKey:imageName];
    if (![userDefaults stringForKey:imageName]) {
        [userDefaults setObject:imageName forKey:imageName];
        [userDefaults synchronize];
        __block UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeTopRight;
        imageView.image = [UIImage imageNamed:imageName];
        imageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [SharedAppDelegate.window addSubview:imageView];
        [imageView setTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [gestureRecoginzer.view removeFromSuperview];
        }];
    }
}

#pragma mark -- 下拉上拉刷新


- (void)addHeaderAndFooterViews:(UIScrollView*)scrollView
{
    scrollView.mj_header = [MasterTableHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(headerFresh)];
    scrollView.mj_footer = [MasterTableFooterView footerWithRefreshingTarget:self refreshingAction:@selector(footerFresh)];
    self.freshScrollView = scrollView;
}
- (void)addHeaderView:(UIScrollView*)scrollView{
    scrollView.mj_header = [MasterTableHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(headerFresh)];
    self.freshScrollView = scrollView;
}
- (void)addFooterView:(UIScrollView*)scrollView
{
    scrollView.mj_footer = [MasterTableFooterView footerWithRefreshingTarget:self refreshingAction:@selector(footerFresh)];
    self.freshScrollView = scrollView;
}

- (void)headerFresh{
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.freshScrollView.mj_header endRefreshing];
    });
}

- (void)footerFresh{
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.freshScrollView.mj_footer endRefreshing];
    });
}


- (void)showPhonesActionSheet:(NSString*)phones
{
    NSString* courseMobile = phones;
    courseMobile = [courseMobile stringByReplacingOccurrencesOfString:@"、" withString:@","];
    courseMobile = [courseMobile stringByReplacingOccurrencesOfString:@"，" withString:@","];
    NSArray* phonesArray = [courseMobile componentsSeparatedByString:@","];
    UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
    actionSheet.title = @"电话号码";
    [actionSheet addButtonWithTitle:@"取消"];
    for (NSString* phone in phonesArray) {
        [actionSheet addButtonWithTitle:phone];
    }
    [actionSheet setCancelButtonIndex:0];
    [actionSheet showInView:self.view];
    [actionSheet.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
        if (index.integerValue>0) {
            NSString* phone = [actionSheet buttonTitleAtIndex:index.integerValue];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]]];
        }
    } ];
}

- (void)showRequestErrorMessage:(BaseModel*)model
{
    if (model.code!=200) {
        if (model.alert && ![model.alert[@"msg"] isEmpty]) {
            self.requestAlert = model.alert;
            [self showAlertMessage];
        }else{
            [self hiddenHUDWithString:model.message error:YES];
        }
    }
}

- (void)showAlertMessage{
    NSString *title = self.requestAlert[@"title"];
    NSString *message = self.requestAlert[@"msg"];
    NSString *url = self.requestAlert[@"url"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    if (url && ![url isEmpty]) {
        alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        @weakify(self);
        [alertView.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
            @strongify(self);
            if (index.integerValue==0) {
                [self pushViewControllerWithUrl:self.requestAlert[@"url"]];
            }
        } ];
    }
    [alertView show];
}
- (void)seachclicked{
    
//    MasterShareSearchViewController *vct = (MasterShareSearchViewController *)[UIStoryboard viewController:@"MasterShare" identifier:@"MasterShareSearchViewController"];
//
//    [self.navigationController pushViewController:vct animated:YES];
    
}

- (void)voteClicked {
    KAVoteViewController *vct = (KAVoteViewController *)[UIStoryboard viewController:@"KA" identifier:@"KAVoteViewController"];
    
    [self.navigationController pushViewController:vct animated:YES];
}

#pragma mask -- UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
{
    return [self canGotoBack];
}

- (void)dealloc
{
  //  [[NSNotificationCenter defaultCenter]removeObserver:self name:@"HideLoginView" object:nil];
    NSLog(@"dealloc  ===============================%@",self);
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