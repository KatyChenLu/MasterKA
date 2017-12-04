//
//  MainTabBarController.m
//  MasterKA
//
//  Created by jinghao on 15/12/22.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseViewController.h"
#import "MineRootViewController.h"

//#import "SGRecordViewController.h"
#import "HyPopMenuView.h"
//#import "MasterPickerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BaseNavigationController.h"

//#import "SelectMovController.h"
#import "KAHomeViewController.h"


@interface MainTabBarController ()<CAAnimationDelegate,HyPopMenuViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    AppDelegate* appdelegate;
}

@property (nonatomic,strong)UIView *tabbarView;

@property (nonatomic,strong)NSArray *tabbarButton;

@property (nonatomic, strong, readwrite) UserClient *userClient;

@property (nonatomic, strong)UIButton * releaseBtn;

@property (nonatomic, strong) HyPopMenuView *menu;


@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshtabBar) name:@"refreshtabBar" object:nil];
    
    self.view.backgroundColor = MasterDefaultColor;
    
    self.navigationController.navigationBarHidden = YES;
    
    UIImageView * imageView  = [[UIImageView alloc] init];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.tabBar.frame.size.height)];
    
    imageView.backgroundColor = [UIColor whiteColor];
    
//    if (IsPhoneX) {
//        imageView.frame = CGRectMake(0, -8, ScreenWidth, self.tabBar.frame.size.height + 8);
//        imageView.image = [[UIImage imageNamed:@"tabbar_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
//    }else{
//        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -8, ScreenWidth, self.tabBar.frame.size.height)];
//
//        imageView.image = [UIImage imageNamed:@"tabbar_bg"];
//         imageView.contentMode = UIViewContentModeCenter;
//    }
    
    [self.tabBar insertSubview:imageView atIndex:0];
    
    [[UITabBar appearance] setShadowImage:[self creatImageWithColor:[UIColor clearColor]]];
    
    [[UITabBar appearance]setBackgroundImage:[self creatImageWithColor:[UIColor clearColor]]];
    
    self.viewControllers = [self rootViewController];
}


- (UIImage *)creatImageWithColor:(UIColor*)color{
    
    CGRect rect = CGRectMake( 0, 0, 1.0, 1.0);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, rect);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    return  image;
    
}

- (NSMutableArray*)rootViewController{
    
    NSMutableArray * vctArray = [NSMutableArray array];
    NSMutableArray * buttonArray = [NSMutableArray array];
    
    UIButton * masterShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [masterShareBtn setImage:[UIImage imageNamed:@"首页默认"] forState:UIControlStateNormal];
    [masterShareBtn setImage:[UIImage imageNamed:@"首页选中"] forState:UIControlStateSelected];
//    [buttonArray addObject:masterShareBtn];
    
    UIButton * userShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [userShareBtn setImage:[UIImage imageNamed:@"发现默认"] forState:UIControlStateNormal];
    [userShareBtn setImage:[UIImage imageNamed:@"发现选中"] forState:UIControlStateSelected];
//    [buttonArray addObject:userShareBtn];
    
//    self.releaseBtn= [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.releaseBtn setImage:[UIImage imageNamed:@"发布"] forState:UIControlStateNormal];
//    [self.releaseBtn setImage:[UIImage imageNamed:@"发布"] forState:UIControlStateSelected];
//    [buttonArray addObject:self.releaseBtn];
    
    UIButton * userShareBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [userShareBtn1 setImage:[UIImage imageNamed:@"团建默认"] forState:UIControlStateNormal];
    [userShareBtn1 setImage:[UIImage imageNamed:@"团建选中"] forState:UIControlStateSelected];
    [buttonArray addObject:userShareBtn1];
    
    UIButton * shopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shopButton setImage:[UIImage imageNamed:@"课程默认"] forState:UIControlStateNormal];
    [shopButton setImage:[UIImage imageNamed:@"课程选中"] forState:UIControlStateSelected];
//    [buttonArray addObject:shopButton];
    
    UIButton * myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton setImage:[UIImage imageNamed:@"我的默认"] forState:UIControlStateNormal];
    [myButton setImage:[UIImage imageNamed:@"我的选中"] forState:UIControlStateSelected];
    [buttonArray addObject:myButton];
    
//    UIViewController * vct = [[UIStoryboard storyboardWithName:@"MasterShare" bundle:nil] instantiateInitialViewController];
//    [vctArray addObject:vct];
    
//    vct = [[UIStoryboard storyboardWithName:@"UserShare" bundle:nil] instantiateInitialViewController];
//    [vctArray addObject:vct];
    
//    vct = [[UIViewController alloc]init];
//    [vctArray addObject:vct];
    UIViewController * vct = [[KAHomeViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vct];
    
    [vctArray addObject:nav];
    
//    vct = [[UIStoryboard  storyboardWithName:@"Goods" bundle:nil]instantiateInitialViewController];
//    [vctArray addObject:vct];
    
    vct = [[UIStoryboard  storyboardWithName:@"Mine" bundle:nil]instantiateInitialViewController];
    [vctArray addObject:vct];
    
    self.tabbarButton = buttonArray;
    
    self.tabBarBtn = self.tabbarButton;
    
    
    float btnW = ScreenWidth/self.tabbarButton.count;
    
    for (int i = 0; i < self.tabbarButton.count; i++) {
        
        UIButton * btn = self.tabbarButton[i];
        
        btn.adjustsImageWhenHighlighted = NO;
        
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;

        [btn addTarget:self action:@selector(tabbarButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];

         btn.frame = CGRectMake(i*btnW, 0, btnW, 49);
//        btn.frame = CGRectMake(i*btnW, i==2?-10:0, btnW, 49);
        
//        if (i == 2) {
//
//            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(btnW/3,49/2-5)];
//
//            CAShapeLayer * shapeLayer = [CAShapeLayer layer];
//
//            shapeLayer.frame = btn.bounds;
//
//            shapeLayer.path = path.CGPath;
//
//            btn.layer.mask = shapeLayer;
//
//        }
        
        [self.tabbarView addSubview:btn];
        
        if (i==0) {
            
            btn.selected = YES;
            
        }
        
    }
    
    return vctArray;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
    
}

- (void)refreshtabBar{
    
    UIButton* button = [self.tabbarButton objectAtIndex:1];
    
    NSInteger selectIndex = 1;
    
    if (selectIndex != NSNotFound && selectIndex != self.selectedIndex) {
        
//        if (selectIndex != 2) {
        
            self.selectedIndex = selectIndex;
            
            for (UIButton *btn in self.tabbarButton) {
                
                btn.selected = NO;
            }
            
            button.selected = YES;
            
//        }
        
    }
    
}

- (UIView*)tabbarView{
    
    if (!_tabbarView) {
        
        _tabbarView = [[UIView alloc] init];
        
        _tabbarView.backgroundColor = [UIColor clearColor];
        
    }
    
    return _tabbarView;
    
}

- (BOOL)shouldAutorotate{
    
    return TRUE;
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (self.tabbarView.superview==nil) {
        
        [self.tabBar addSubview:self.tabbarView];

        self.tabbarView.frame = CGRectMake(0, IsPhoneX?8:0, ScreenWidth, 49);

    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

- (void)popMenuView:(HyPopMenuView *)popMenuView didSelectItemAtIndex:(NSUInteger)index {
    
    if(!self.userClient.isMaster){
        switch (index) {
            case 0:
                [self userClicked];
                break;
            case 1:
                [self movieClicked];
                break;
            default:
                break;
        }
    }else{
        switch (index) {
            case 0:
                [self userClicked];
                break;
            case 1:
                [self masterClicked];
                break;
            case 2:
                [self movieClicked];
                break;
            default:
                break;
        }
        
    }
    
}

- (void)tabbarButtonOnClick:(UIButton*)button{
    
    NSInteger selectIndex = [self.tabbarButton indexOfObject:button];
 
    
    if (selectIndex == self.selectedIndex ) {
        if (selectIndex == 0) {
//             [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshFirstView" object:self];
        }else if (selectIndex == 1){
             [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshNewView" object:self];
        }else if (selectIndex == 3){
//             [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshShopView" object:self];
        }
        
    }
    
    if (selectIndex != NSNotFound && selectIndex != self.selectedIndex) {
        
//        if (selectIndex != 2) {
        
            self.selectedIndex = selectIndex;
            
            for (UIButton *btn in self.tabbarButton) {
                
                btn.selected = NO;
                
            }
            
            button.selected = YES;
            
//        }
        
    }
   
    
//    if (selectIndex == 2) {
//
//        if(![(BaseViewController*)appdelegate.baseVC doLogin]){
//
//            return;
//        }else{
//
//            _menu = [HyPopMenuView sharedPopMenuManager];
//
//            if(!self.userClient.isMaster){
//
//                PopMenuModel* model = [PopMenuModel
//                                       allocPopMenuModelWithImageNameString:@"短分享-拷贝"
//                                       AtTitleString:@"短分享"
//                                       AtTextColor:[UIColor whiteColor]
//                                       AtTransitionType:PopMenuTransitionTypeSystemApi
//                                       AtTransitionRenderingColor:nil];
//
//                PopMenuModel* model1 = [PopMenuModel
//                                        allocPopMenuModelWithImageNameString:@"小视频"
//                                        AtTitleString:@"小视频"
//                                        AtTextColor:[UIColor whiteColor]
//                                        AtTransitionType:PopMenuTransitionTypeSystemApi
//                                        AtTransitionRenderingColor:nil];
//
//                _menu.dataSource = @[model,model1];
//                  _menu.columnNum = 2;
//
//            }else{
//
//                PopMenuModel* model = [PopMenuModel
//                                       allocPopMenuModelWithImageNameString:@"短分享-拷贝"
//                                       AtTitleString:@"短分享"
//                                       AtTextColor:[UIColor whiteColor]
//                                       AtTransitionType:PopMenuTransitionTypeSystemApi
//                                       AtTransitionRenderingColor:nil];
//
//                PopMenuModel* model1 = [PopMenuModel
//                                        allocPopMenuModelWithImageNameString:@"长图文"
//                                        AtTitleString:@"长图文"
//                                        AtTextColor:[UIColor whiteColor]
//                                        AtTransitionType:PopMenuTransitionTypeSystemApi
//                                        AtTransitionRenderingColor:nil];
//
//                PopMenuModel* model2 = [PopMenuModel
//                                        allocPopMenuModelWithImageNameString:@"小视频"
//                                        AtTitleString:@"小视频"
//                                        AtTextColor:[UIColor whiteColor]
//                                        AtTransitionType:PopMenuTransitionTypeSystemApi
//                                        AtTransitionRenderingColor:nil];
//
//                _menu.dataSource = @[model,model1,model2];
//                _menu.columnNum = 3;
//
//            }
//
//            _menu.delegate = self;
//
//            _menu.popMenuSpeed = 12.0f;
//
//            _menu.automaticIdentificationColor = false;
//
//            _menu.animationType = HyPopMenuViewAnimationTypeViscous;
//
//            _menu.backgroundType = HyPopMenuViewBackgroundTypeDarkBlur;
//
//            [_menu openMenu];
//        }
//
//    }
}

- (void)movieClicked{
   
//    SelectMovController*vc = [[SelectMovController alloc]init];
//
//    [self pushViewController:vc animated:YES];

//    SGRecordViewController*vc = [[SGRecordViewController alloc]init];
//
//  BaseNavigationController *  viewController = [[BaseNavigationController alloc] initWithRootViewController:vc];
//    
//    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)userClicked{
    
//    MasterPickerViewController *imagePickerVc = [[MasterPickerViewController alloc] initWithMaxImagesCount:9 delegate:self];
//
//    @weakify(self);
//
//    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//
//        @strongify(self);
//
//        UIViewController *vct = [UIViewController viewControllerWithStoryboard:@"UserShare" identifier:@"AddUserShareVC"];
//
//        [vct setValue:photos forKey:@"chosenImages"];
//
//        [vct setValue:assets forKey:@"chosenAssets"];
//
//        [self pushViewController:vct animated:YES];
//
//    }];
//
//   [self presentViewController:imagePickerVc animated:YES completion:nil];
//
//
}

-(void)masterClicked{
    
//    MasterPickerViewController *imagePickerVc = [[MasterPickerViewController alloc] initWithMaxImagesCount:1 delegate:nil];
//
//    
//    imagePickerVc.cropRect = CGRectMake(0, ((ScreenHeight - 64 - 44)- ScreenWidth/8*3)/2, ScreenWidth, ScreenWidth/4*3);
//    
//    @weakify(self);
//    
//    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//        
//        @strongify(self);
//        
//        UIViewController *vct = [UIViewController viewControllerWithStoryboard:@"MasterShare" identifier:@"MasterShareReleaseViewController"];
//        
//        [vct setValue:photos forKey:@"imageArray"];
//        
//        [self pushViewController:vct animated:YES];
//        
//    }];
//    
//    [self presentViewController:imagePickerVc animated:YES completion:nil];
//    
}

- (UserClient*)userClient{
    
    if (!_userClient) {
        
        _userClient = [UserClient sharedUserClient];
        
    }
    
    return _userClient;
    
}

#pragma  mark --

- (BOOL)slideNavigationControllerShouldDisplayRightMenu{
    
    return NO;
    
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu{
    
    return NO;
    
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
