//
//  SplashViewController.m
//  MasterKA
//
//  Created by jinghao on 16/5/4.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "SplashViewController.h"
#import "LoginViewModel.h"
//#import "UMSocial.h"
#import <UMSocialCore/UMSocialCore.h>
#import "HobyViewController.h"
#import "MJExtension.h"

@interface SplashViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)LoginViewModel *viewModel;
@property (nonatomic,weak)IBOutlet UIImageView *splashImageView;
@property (nonatomic,weak)IBOutlet UIView *guidedView;
@property (nonatomic,weak)IBOutlet UIPageControl *pageControl;
@property (nonatomic,weak)IBOutlet UIScrollView *mScrollView;
@property (nonatomic,weak)IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIView *playerView;

@property(nonatomic , strong)AVPlayer * player;

@property(nonatomic , assign)BOOL firstInstall;

@end

@implementation SplashViewController
@synthesize viewModel = _viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.skipButton.hidden = YES;
//    self.view.backgroundColor = MasterDefaultColor;
    self.guidedView.hidden = YES;
    
//    self.splashImageView.image = [self getTheLaunchImage];
//     [self buildPlayLayer];
    [self initAppConfig];
    [self checkAppVersion];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)initAppConfig{
    HttpManagerCenter* httpCenter = [HttpManagerCenter sharedHttpManager];
    DBHelper *dbHelper = [DBHelper sharedDBHelper];
    [[httpCenter appConfig:[AppConfigModel class]] subscribeNext:^(BaseModel *model) {
        if (model.code == 200) {
            AppConfigModel *configModel = model.data;
            [dbHelper deleteClass:[CityModel class]];
            [dbHelper insertModelArray:configModel.city_list];
            
            [[UserClient sharedUserClient] setAppConfigUrl:configModel];
        
        }
    }];
}

- (UIImage *)getTheLaunchImage
{
    NSString *defaultImageName = @"LaunchImage";
    NSInteger osVersion = floor([[[UIDevice currentDevice] systemVersion] floatValue])*100;
    if (osVersion > 800){
        osVersion = 800;
    }
    NSInteger screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    // 3.5inch
    if (screenHeight < 568) {
        // >iOS7
        if (osVersion >= 700) {
            defaultImageName = [NSString stringWithFormat:@"%@-%zd",defaultImageName,osVersion];
        }
        // <iOS7
    }
    // 4.0inch and 4.7inch
    else if(screenHeight < 736){
        // >iOS7
        if (osVersion >= 700) {
            if (screenHeight <667) {
                
                osVersion = 700;
            }
            
            defaultImageName = [NSString stringWithFormat:@"%@-%zd-%zdh",defaultImageName,osVersion,screenHeight];
        }
        // <iOS7
        else {
            defaultImageName = [NSString stringWithFormat:@"%@-%zdh",defaultImageName,screenHeight];
        }
    }
    // 5.5inch
    else{
        NSString *orientation = @"";
        switch ([[UIApplication sharedApplication] statusBarOrientation]) {
            case UIInterfaceOrientationUnknown:
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationPortraitUpsideDown:
                orientation = @"Portrait";
                break;
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                orientation = @"Landscape";
                break;
            default:
                break;
        }
        defaultImageName = [NSString stringWithFormat:@"%@-%zd-%@-%zdh",defaultImageName,osVersion,orientation,screenHeight];
    }
    return [UIImage imageNamed:defaultImageName];
}

- (void)checkAppVersion{

        self.playerView.hidden = YES;

        [self autoLogin];
        
//        [self buildPlayLayer];
    
    
}



-(void)buildPlayLayer
{

//    NSString * path = [[NSBundle mainBundle]pathForResource:@"app视频.mp4" ofType:nil];
//    
//    AVPlayerItem * playerItem = [[AVPlayerItem alloc]initWithURL:[NSURL fileURLWithPath:path]];
//    
//    self.player = [AVPlayer playerWithPlayerItem:playerItem];
//    
//    
//    AVPlayerLayer * playLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//    
//    playLayer.contents = (__bridge id)[UIColor redColor].CGColor;
//    
//    playLayer.videoGravity = AVLayerVideoGravityResize;
//    playLayer.frame = CGRectMake(0, 0, self.view.width, self.view.height* 0.7);
//    
//    [self.playerView.layer addSublayer:playLayer];
//    
//    [self.player play];
    //重复播放通知
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(runloopPlay:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    
    
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoMainViewController:)];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    
    
    UIImageView * bottomImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.height*0.7, self.view.width, self.view.height*0.3)];
    
    
//    bottomImage.backgroundColor = [UIColor redColor];
    
    bottomImage.image = [UIImage imageNamed:@"MASTER-1"];
    
    bottomImage.contentMode = UIViewContentModeScaleAspectFill;
    
    bottomImage.userInteractionEnabled = YES;
    
    [bottomImage addGestureRecognizer:tap];
    
    [self.playerView addSubview:bottomImage];
    
    
}




-(void)runloopPlay:(NSNotification *)notify
{
    
    AVPlayerItem * item = notify.object;
    
    [self.player seekToTime:CMTimeMake(0, item.currentTime.timescale)];
    
    [self.player play];
 
}


-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super viewWillDisappear:animated];
}


-(void)tap
{
  //第一次安装app
//    if (self.firstInstall) {
//
//        HobyViewController * hobyVC = [[HobyViewController alloc]init];
//        hobyVC.view.backgroundColor = [UIColor whiteColor];
//
//        [UIApplication sharedApplication].keyWindow.rootViewController = hobyVC;
//    }else//更新app
//    {
        [SharedAppDelegate openAppMainVCT];
//    }
    
    
    
    
}


- (LoginViewModel*)viewModel
{
    if (!_viewModel) {
        _viewModel = [[LoginViewModel alloc] initWithViewController:self
                      ];
    }
    return _viewModel;
}

- (void)bindViewModel{
    [super bindViewModel];
     NSLog(@"*************%s*********",__func__);
    self.viewModel.loginSuccessCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
     [SharedAppDelegate openAppMainVCT];
        return [RACSignal empty];
    }];
    self.viewModel.loginErrorCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
      [SharedAppDelegate openAppMainVCT];
        return [RACSignal empty];
    }];
}
- (void)thirdLoginType {
    UMSocialUserInfoResponse *input = [UMSocialUserInfoResponse mj_objectWithKeyValues:[UserClient sharedUserClient].UserInfoResponse];
    
    @weakify(self)
    [[[HttpManagerCenter sharedHttpManager] otherLoginByPlatform:input.platformType uid:input.uid unionId:input.openid nickname:input.name iconUrl:input.iconurl gender:input.unionGender resultClass:nil] subscribeNext:^(BaseModel *model) {
        @strongify(self)
        if (model.code==200) {
            [[UserClient sharedUserClient] setLoginTypeName:input.platformType];
            
            [[UserClient sharedUserClient] setUserInfo:model.data];
            [self hiddenHUDWithString:@"登陆成功" error:NO];
            
            [self.viewModel.loginSuccessCommand execute:nil];
            
            
        }else {
            //                [self.viewController hiddenHUDWithString:model.message error:NO];
            [self showRequestErrorMessage:model];
            if (self.viewModel.loginErrorCommand) {
                [self.viewModel.loginErrorCommand execute:nil];
            }
        }
    } error:^(NSError *error) {
        
    } completed:^{
        //            [self.viewController hiddenHUD];
    }];

}

- (void)autoLogin
{
    NSLog(@"*************%s*********",__func__);
     [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = NO;
    switch (self.userClient.loginType) {
        case MasterLoginType_Phone:{
            self.viewModel.username = self.userClient.userName;
            self.viewModel.password = self.userClient.password;
            [self.viewModel.loginCommand execute:nil];
        }
            break;
            
        case MasterLoginType_QQ:{
            [self thirdLoginType];
            
//            NSDictionary *authDic = [[UMSocialDataManager defaultManager] getAuthorUserInfoWithPlatform:UMSocialPlatformType_QQ];
//            UMSocialUserInfoResponse *resp = [[UMSocialUserInfoResponse alloc] init];
//            if (authDic) {
//                resp = [[UMSocialUserInfoResponse alloc] init];
//                resp.uid = [authDic objectForKey:kUMSocialAuthUID];
//                resp.openid = [authDic objectForKey:kUMSocialAuthOpenID];
//                
//                resp.accessToken = [authDic objectForKey:kUMSocialAuthAccessToken];
//                resp.expiration = [authDic objectForKey:kUMSocialAuthExpireDate];
//                resp.refreshToken = [authDic objectForKey:kUMSocialAuthRefreshToken];
//                
//                resp.platformType = UMSocialPlatformType_QQ;
//                resp.name = [UserClient sharedUserClient].userInfo[@"nikename"];
//                resp.iconurl = [UserClient sharedUserClient].userInfo[@"img_top"];
//                resp.gender = [UserClient sharedUserClient].userInfo[@"sex"];
//            }
//            
//            
//            
//                    [[self.viewModel otherLoginCommand] execute:resp];
            
           
        }
            break;
        case MasterLoginType_Sina:
        {
            [self thirdLoginType];
            
//            NSDictionary *authDic = [[UMSocialDataManager defaultManager] getAuthorUserInfoWithPlatform:UMSocialPlatformType_Sina];
//            UMSocialUserInfoResponse *resp = [[UMSocialUserInfoResponse alloc] init];
//            if (authDic) {
//                resp = [[UMSocialUserInfoResponse alloc] init];
//                resp.uid = [authDic objectForKey:kUMSocialAuthUID];
//                resp.openid = [authDic objectForKey:kUMSocialAuthOpenID];
//                
//                resp.accessToken = [authDic objectForKey:kUMSocialAuthAccessToken];
//                resp.expiration = [authDic objectForKey:kUMSocialAuthExpireDate];
//                resp.refreshToken = [authDic objectForKey:kUMSocialAuthRefreshToken];
//                
//                resp.platformType = UMSocialPlatformType_Sina;
//                resp.name = [UserClient sharedUserClient].userInfo[@"nikename"];
//                resp.iconurl = [UserClient sharedUserClient].userInfo[@"img_top"];
//                resp.gender = [UserClient sharedUserClient].userInfo[@"sex"];
//            }
//            
//            
//            
//            
//            
//                    [[self.viewModel otherLoginCommand] execute:resp];
//            
            
        
        }            break;
        case MasterLoginType_Weixin:
        {
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:[UMSocialSnsPlatformManager getSnsPlatformString:UMSocialSnsTypeWechatSession]];
//            [[self.viewModel otherLoginCommand] execute:snsAccount];
            
           
            
            
//            NSDictionary *authDic = [[UMSocialDataManager defaultManager] getAuthorUserInfoWithPlatform:UMSocialPlatformType_WechatSession];
//            UMSocialUserInfoResponse *resp = [[UMSocialUserInfoResponse alloc] init];
//            if (authDic) {
//                resp = [[UMSocialUserInfoResponse alloc] init];
//                resp.uid = [authDic objectForKey:kUMSocialAuthUID];
//                resp.openid = [authDic objectForKey:kUMSocialAuthOpenID];
//                
//                resp.accessToken = [authDic objectForKey:kUMSocialAuthAccessToken];
//                resp.expiration = [authDic objectForKey:kUMSocialAuthExpireDate];
//                resp.refreshToken = [authDic objectForKey:kUMSocialAuthRefreshToken];
//                
//                resp.platformType = UMSocialPlatformType_WechatSession;
//                resp.name = [UserClient sharedUserClient].userInfo[@"nikename"];
//                resp.iconurl = [UserClient sharedUserClient].userInfo[@"img_top"];
//                resp.gender = [UserClient sharedUserClient].userInfo[@"sex"];
//            }
//            
//            
//            
//                    [[self.viewModel otherLoginCommand] execute:resp];
            
//            UMSocialUserInfoResponse *input = (UMSocialUserInfoResponse *)[UserClient sharedUserClient].UserInfoResponse;
            
            [self thirdLoginType];
            
            
            
        }
            break;
        default:
            sleep(1.0f);
            [SharedAppDelegate openAppMainVCT];
            break;
    }
}

- (void)gotoMainViewController:(id)sender{
    [SharedAppDelegate openAppMainVCT];
    
    
    
    
}

//改变滚动视图的方法实现
- (void)setUpPage
{
    //设置委托
    self.mScrollView.delegate = self;
    //设置背景颜色
//    self.mScrollView.backgroundColor = [UIColor blackColor];
    //设置取消触摸
    self.mScrollView.canCancelContentTouches = NO;
    //设置滚动条类型
    self.mScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    //是否自动裁切超出部分
    self.mScrollView.clipsToBounds = YES;
    //设置是否可以缩放
    self.mScrollView.scrollEnabled = YES;
    //设置是否可以进行画面切换
    self.mScrollView.pagingEnabled = YES;
    //设置在拖拽的时候是否锁定其在水平或者垂直的方向
    self.mScrollView.directionalLockEnabled = NO;
    //隐藏滚动条设置（水平、跟垂直方向）
    self.mScrollView.alwaysBounceHorizontal = NO;
    self.mScrollView.alwaysBounceVertical = NO;
    self.mScrollView.showsHorizontalScrollIndicator = NO;
    self.mScrollView.showsVerticalScrollIndicator = NO;
    
    int imageCount = 5;
    self.pageControl.numberOfPages = imageCount;
    for (int i=0; i<imageCount; i++) {
        NSString *imageName = [NSString stringWithFormat:@"Master_Guide%d",i];
        if((int)ScreenHeight % 480==0){
            imageName = [NSString stringWithFormat:@"Master_Guide%d_320x480",i];
        }
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:imageName];
        imageView.frame = CGRectMake(i*ScreenWidth, 0, ScreenWidth, ScreenHeight);
        
        if (i==(imageCount-1)) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"立即进入" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.backgroundColor = MasterDefaultColor;
            button.cornerRadius = 6.0f;
            button.showsTouchWhenHighlighted = NO;
            [button addTarget:self action:@selector(gotoMainViewController:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
            imageView.userInteractionEnabled = YES;
            button.frame = CGRectMake(75, ScreenHeight-50-40, ScreenWidth-150, 40);
        }
        
        [self.mScrollView addSubview:imageView];
    }
    self.mScrollView.contentSize = CGSizeMake(ScreenWidth*imageCount, ScreenHeight);
    
    //设置页码控制器的响应方法
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    //设置总页数
    //默认当前页为第一页
    self.pageControl.currentPage = 0;
    //为页码控制器设置标签
    self.pageControl.tag = 110;
}


//改变页码的方法实现
- (void)changePage:(id)sender
{
    //获取当前视图的页码
    CGRect rect = self.mScrollView.frame;
    //设置视图的横坐标，一幅图为320*460，横坐标一次增加或减少320像素
    rect.origin.x = self.pageControl.currentPage * self.mScrollView.frame.size.width;
    //设置视图纵坐标为0
    rect.origin.y = 0;
    //scrollView可视区域
    [self.mScrollView scrollRectToVisible:rect animated:YES];
}
#pragma mark-----UIScrollViewDelegate---------
//实现协议UIScrollViewDelegate的方法，必须实现的
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //获取当前视图的宽度
    CGFloat pageWith = scrollView.frame.size.width;
    //根据scrolView的左右滑动,对pageCotrol的当前指示器进行切换(设置currentPage)
    int page = floor((scrollView.contentOffset.x - pageWith/2)/pageWith)+1;
    //切换改变页码，小圆点
    self.pageControl.currentPage = page;
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
