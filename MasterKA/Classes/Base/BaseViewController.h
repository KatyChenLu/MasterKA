//
//  BaseViewController.h
//  MasterKA
//
//  Created by jinghao on 15/12/11.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
//#import "BaseViewModel.h"
#import "MBProgressHUD.h"
#import "UserClient.h"
#import "IQKeyboardManager.h"
#import "LoginView.h"

@interface BaseViewController : UIViewController<SlideNavigationControllerDelegate>

@property (nonatomic,strong)LoginView* myLoadView;
@property (nonatomic,strong)UIView* loginBackView;
@property (nonatomic,strong)MasterUrlManager *urlManager;
@property (nonatomic, strong, readonly) BaseViewModel *viewModel;
@property (nonatomic, strong, readonly) UserClient *userClient;
@property (nonatomic,strong,readonly)UITextField *searchTitleView;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong)UILabel *cntLabel;
@property (nonatomic, strong) UIView *voteNavView;
@property (nonatomic, strong) UIButton *voteBtn;

@property (nonatomic)BOOL hiddenTabbar;
@property (nonatomic)BOOL showLeftMenu;

//切换城市的block
@property(nonatomic , copy)void(^changeCity)(UIButton * sender);


/**
 *  返回按钮标题
 */
@property (nonatomic,strong)NSString* backTitle;
/**
 *  控制返回是否可用
 *
 *  @return YES 可以返回，NO不可以返回
 */

@property(nonatomic ,assign)NSInteger index;
- (BOOL)canGotoBack;

- (void)gotoBack;

- (void)gotoBack:(BOOL)animated viewControllerName:(NSString*)viewControllerName;

- (void)addHeaderAndFooterViews:(UIScrollView*)scrollView;
- (void)addHeaderView:(UIScrollView*)scrollView;
- (void)addFooterView:(UIScrollView*)scrollView;

- (void)showLoadingFailView:(BOOL)show;

- (BOOL)doLogin;

- (void)showUserCenter:(id)sender;

- (void)showHelpImageView:(NSString*)imageName;

- (void)bindViewModel;

- (void)pushViewControllerFrom:(NSString*)viewControllerName viewController:(UIViewController*)viewController animated:(BOOL)animated;

- (void)pushViewControllerWithUrl:(NSString*)url;
- (void)pushViewControllerWithUrl:(NSString*)url callback:(ViewControlerCallback)callback;

- (void)showPhonesActionSheet:(NSString*)phones;


- (void)showRequestErrorMessage:(BaseModel*)model;
@end
