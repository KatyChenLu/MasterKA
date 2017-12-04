//
//  MineRootViewController.m
//  MasterKA
//
//  Created by jinghao on 15/12/22.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "MineRootViewController.h"
#import "MyHeadViewCell.h"
#import "MineRootViewModel.h"
#import "SDWebImageManager.h"
#import "QRCodeViewController.h"
#import "UITableView+Gzw.h"
#import "MyOrderHomeViewController.h"

#import "Masonry.h"

@interface MineRootViewController ()
{
    AppDelegate* appdelegate;
}
@property (nonatomic,weak)IBOutlet UITableView *mTableView;
@property (nonatomic,strong)MyHeadViewCell *mineHeadView;
@property (nonatomic,strong)MineRootViewModel *viewModel;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint *tableViewRightLayout;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingItem;
@property (nonatomic,strong)UIButton* xiaoxiBtn;

@end

@implementation MineRootViewController

@synthesize viewModel = _viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的";
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.mTableView.contentInset = UIEdgeInsetsZero;
    [self.viewModel bindTableView:self.mTableView];
    [self.mTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-45);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
//    self.tableViewRightLayout.constant = self.tableViewRightValue;
//    self.mineHeadView.height=120;
    self.mTableView.tableHeaderView = self.mineHeadView;
//    self.mTableView.tableHeaderView.height = 322;// = CGRectMake(0, 0, 0, 240);
    self.xiaoxiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.xiaoxiBtn setImage:[UIImage imageNamed:@"消息"] forState:UIControlStateNormal];
        [self.xiaoxiBtn addTarget:self action:@selector(showMsg:) forControlEvents:UIControlEventTouchUpInside];
    self.xiaoxiBtn.size = CGSizeMake(30, 30);
    if (IS_IOS_11) {
        self.xiaoxiBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    }
    UIBarButtonItem *fetchItem = [[UIBarButtonItem alloc] initWithCustomView:self.xiaoxiBtn];
    self.navigationItem.rightBarButtonItem = fetchItem;

    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom ]];
    
    [self.navigationItem setLeftBarButtonItem: leftBtn];
    

    BOOL isLogin =[UserClient sharedUserClient].rawLogin;
    //如果没有登入就就显示footview；

    if (!isLogin) {
        
        self.mTableView.tableFooterView.hidden = YES;

        
    }else{
        
        self.mineHeadView.userInteractionEnabled = YES;
        
        self.mTableView.tableFooterView.hidden = YES;
        

        
    }

    
    [self.mineHeadView.mashangDenglu addTarget:self action:@selector(mashangClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.mineHeadView.changeInfo addTarget:self action:@selector(changeInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.mineHeadView.headImageView setTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [self gotoMineInfo];
    }];
    
//    [self.navigationItem addLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setting:)] animated:TRUE];
    
    
    
}

- (IBAction)settingClick:(UIBarButtonItem *)sender {
    
    [self setting:sender];
    
    
}
- (IBAction)msgClick:(UIBarButtonItem *)sender {
    
    [self showMsg:sender];
}

//未登入footView

-(void)layoutBgView {
    
    UIView * redView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,300 )];
    
    
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    loginBtn.frame = CGRectMake(redView.width/8,redView.bounds.size.height-90,redView.width/4*3, 40);
    

    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    loginBtn.backgroundColor = MasterDefaultColor;
    
    
    loginBtn.cornerRadius = loginBtn.height*0.5;
    
    [redView addSubview:loginBtn];
    
    redView .backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.0f];

    self.mTableView.tableFooterView =  redView;

}

-(void)loginClick:(UIButton*)sender {
    
    
//    [self doLogin];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self.tabBarController.tabBar setHidden:NO];
    self.viewModel.active = TRUE;
//    self.view.backgroundColor=[UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundImageAlpha = 1.0f;
//    if(self.mTableView.tableHeaderView==nil){
//        [self.mTableView beginUpdates];
//        self.mTableView.tableHeaderView = self.mineHeadView;
//        [self.mTableView endUpdates];
//    }
    
//      [self.viewModel bindTableView:self.mTableView];
    
    
    self.mTableView.descriptionText = @"您还没有登录哦~";
    
    self.mTableView.loadedImageName = @"coffee";
    
    
      BOOL isLogin =[UserClient sharedUserClient].rawLogin;
    
    if (!isLogin) {
        self.mTableView.tableFooterView.hidden = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefurbishMyInfo" object:nil];

        }else{
    
        self.mTableView.tableFooterView .hidden = YES;
            
             self.mineHeadView.userInteractionEnabled = YES;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefurbishMyInfo" object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:YES];
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.backgroundImageAlpha = 1.0f;
    
}

#pragma mark -- getter setter

- (MyHeadViewCell*)mineHeadView
{
    if (!_mineHeadView) {
        _mineHeadView = [MyHeadViewCell loadInstanceFromNib];
    }
    return _mineHeadView;
}

- (MineRootViewModel*)viewModel
{
    if (!_viewModel) {
        _viewModel = [[MineRootViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}

- (void)bindViewModel{
    [super bindViewModel];
    [RACObserve(self.viewModel, userInfo) subscribeNext:^(id x) {
        
        if([UserClient sharedUserClient].rawLogin){
            _mineHeadView.userName.hidden =NO;
            _mineHeadView.noDenglu.hidden = YES;
            _mineHeadView.mashangDenglu.hidden = YES;
        }
        else{
            
            _mineHeadView.userName.hidden =YES;
            _mineHeadView.noDenglu.hidden = NO;
            _mineHeadView.mashangDenglu.hidden = NO;
        }

        _mineHeadView.userName.text = [UserClient sharedUserClient].userInfo[@"nikename"]?_viewModel.userInfo[@"nikename"]:@"我是谁?";

      BOOL isLogin =[UserClient sharedUserClient].rawLogin;
        
        if (isLogin) {
            
            
            [_mineHeadView.headImageView setImageWithURLString:[UserClient sharedUserClient].userInfo[@"img_top"] placeholderImage:[UIImage imageNamed:@"DefaultImage"]];
        }
        else{
            [_mineHeadView.headImageView setImage:[UIImage imageNamed:@"LoadingDefault"]];
        
        
        }
    }];
}
-(NSMutableAttributedString*) changeLabelWithText:(NSString*)needText
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    UIFont *font = [UIFont systemFontOfSize:16];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,needText.length-1)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(needText.length-1,1)];
    return attrString;
}
- (void)setting:(id)sender{
    [self pushto:@"SettingViewController"];
}
-(void)showCoupon:(id)sender{
    
    if([self doLogin]){
    [self pushto:@"MyCouponViewController"];
    }
}
- (void)changeInfo:(id)sender{
      if([self doLogin]){
          [self pushto:@"MineInfoViewController"];}
}
-(void)showScoreDetial:(id)sender{
      if([self doLogin]){
          [self pushto:@"MyScoreViewController"];}
}
- (void)gotoMineInfo{
      if([self doLogin]){
    [self pushto:@"ChangePasswordViewController"];
      }
}
- (void)showMyCard:(id)sender{
      if([self doLogin]){
          [self pushto:@"MyCardViewController"];}
}
- (void)showMyFans:(id)sender{
      if([self doLogin]){
          [self pushtoFansViewController:@"fans" Andtitle:@"粉丝"];}
}
- (void)showMyFollows:(id)sender{
      if([self doLogin]){
    [self pushtoFansViewController:@"follow" Andtitle:@"关注"];
      }
}
- (void)showMyOrders:(id)sender{
      if([self doLogin]){
//    [self pushto:@"MineOrderHomeVC"];
//          UITabBarController * tabBar = (UITabBarController*)[[SlideNavigationController sharedInstance].viewControllers firstObject];
//          UINavigationController *nav = (UINavigationController*)[tabBar selectedViewController];
          
          MyOrderHomeViewController *myView = [[MyOrderHomeViewController alloc] init];
          myView.comeIdentifier = @"master";
          [self.navigationController pushViewController:myView animated:YES];
      }
}
- (void)showMsg:(id)sender{
      if([self doLogin]){
          [self pushto:@"MyMsgVC"];
      }
//    [DebugView showWithClickAction:^{
//        NSLog(@"hehe");
//    }];
}

- (void)saoma:(id)sender{
     if([self doLogin]){
//    UITabBarController * tabBar = (UITabBarController*)[[SlideNavigationController sharedInstance].viewControllers firstObject];
//    __block UINavigationController *nav = (UINavigationController*)[tabBar selectedViewController];
    __weak typeof(self) weakSelf = self;
    QRCodeViewController *qrcodevc = [[QRCodeViewController alloc] init];
    qrcodevc.QRCodeSuncessBlock = ^(QRCodeViewController *aqrvc,NSString *qrString){
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [weakSelf performSelector:@selector(checkQRString:) withObject:qrString afterDelay:1.0f];
//        [weakSelf checkQRString:qrString];
    };
    
    qrcodevc.QRCodeFailBlock = ^(QRCodeViewController *aqrvc){
        [weakSelf toastWithString:@"扫描失败" error:NO];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    qrcodevc.QRCodeCancleBlock = ^(QRCodeViewController *aqrvc){
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
//    [self presentViewController:qrcodevc animated:YES completion:nil];
    [weakSelf.navigationController pushViewController:qrcodevc animated:NO];
//    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
//
//    }];
     }
}
- (void)checkQRString:(NSString*)qrString{
    if (qrString==nil || qrString.length==0) {
        [self toastWithString:@"二维码有误" error:NO];
        return;
    }
    
    //判断是否是url
    
    if ([[MasterUrlManager shareMasterUrlManager] isPrivateUrlString:qrString]) {
        if (![UserClient sharedUserClient].rawLogin) {
            [self doLogin];
            return;
        }
    }
    UIViewController *vct = [self.urlManager viewControllerWithUrl:qrString];
    if (vct==nil) {
        NSString *orderString = [qrString decryptWithText];
        NSData *jsonData = [orderString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if(err==nil) {
            vct = [UIViewController viewControllerWithStoryboard:@"Mine" identifier:@"QRCodeResultViewController"];
            vct.params = dic;
        }
    }
    if (vct) {
        [self gotoViewController:vct];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"扫描结果" message:qrString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)mashangClicked{
//    [self doLogin];
//[[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil];
    
        
//        BaseViewController* vc = (BaseViewController*)appdelegate.baseVC;
//        
//        [vc doLogin];

    [self doLogin];
}




-(void)pushto:(NSString *)identifier{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
    UIViewController *myView = [story instantiateViewControllerWithIdentifier:identifier];
    
    if([identifier isEqual:@"MyScoreViewController"]){
        
    }else if([identifier isEqual:@"MineOrderHomeVC"]){
        myView.params = @{@"comeIdentifier":@"master"};
    }else if([identifier isEqual:@"MyMsgVC"]){
        myView.params = self.viewModel.userInfo;
    }
    [self gotoViewController:myView];
}
-(void)pushtoFansViewController:(NSString *)identifier Andtitle:(NSString *)title{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
    UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"MyFansViewController"];
    myView.params = @{@"comeIdentity":identifier,@"title":title};
    
    [self gotoViewController:myView];
}

- (void)gotoViewController:(UIViewController*)vct{
//    UITabBarController * tabBar = (UITabBarController*)[[SlideNavigationController sharedInstance].viewControllers firstObject];
//    UINavigationController *nav = (UINavigationController*)[tabBar selectedViewController];
    [self.navigationController pushViewController:vct animated:YES];
    
//    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
//
//    }];
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
