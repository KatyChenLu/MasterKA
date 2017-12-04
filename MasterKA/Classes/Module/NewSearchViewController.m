//
//  NewSearchViewController.m
//  MasterKA
//
//  Created by lijiachao on 16/10/12.
//  Copyright © 2016年 jinghao. All rights reserved.
// 发现页

#import "MasterSearchListModel.h"
#import "NewSearchViewController.h"
#import "searchTableView.h"
#import "HttpManagerCenter.h"
#import "MasterShareListModel.h"
#import "HttpManagerCenter+Share.h"
#import "MJRefresh.h"
#import "MasterShareBannerModel.h"
#import "LoopScrollView.h"
#import "MasterTableHeaderView.h"
#import "MasterShareSearchViewController.h"
#import "SendMessageModel.h"
#import <MJExtension.h>

#import "HyPopMenuView.h"
#import "SelectMovController.h"
#import "MasterPickerViewController.h"

typedef NS_ENUM(NSInteger, RefreshType) {
    //以下是枚举成员
    Headrefresh = 0,
    Footrefresh = 1,
};

@interface NewSearchViewController ()<LoopScrollViewDelegate,UITextViewDelegate,HyPopMenuViewDelegate,TZImagePickerControllerDelegate>{
    
    
    searchTableView* mTableView;
    
    NSString * _city;
    
    AppDelegate* appdelegate;
    
}

@property (nonatomic,strong)NSArray*bannerList;
@property (nonatomic,strong)NSArray* sharelist;
@property (nonatomic, strong) LoopScrollView *headView;
@property (nonatomic,assign) NSInteger PageTwo;
@property (nonatomic,assign) NSInteger PageOne;
@property (nonatomic,assign) NSInteger PageThr;
@property (nonatomic,assign) NSInteger tableType;
@property (nonatomic,strong) NSString* userID;


@property (nonatomic, assign) CGFloat lineX;
@property (nonatomic, strong) HyPopMenuView *menu;

@end

@implementation NewSearchViewController
@synthesize httpService1 = _httpService1;

#pragma mark ——— life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshNewView) name:@"refreshNewView" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresCommentView:) name:@"refresCommentView" object:nil];
    self.tableType = 1;
    
    self.PageOne =1;
    
    self.PageTwo=1;
    
    self.PageThr =1;
    
    self.lineX =(([UIScreen mainScreen].bounds.size.width-60)/3);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBtn];
    
    
    UIButton * fabuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [fabuBtn setImage:[UIImage imageNamed:@"放大镜"] forState:UIControlStateNormal];
    
    fabuBtn.size = CGSizeMake(35, 44);
    
    [fabuBtn addTarget: self action:@selector(fabuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * fabuItem = [[UIBarButtonItem alloc]initWithCustomView:fabuBtn];
    
    self.navigationItem.rightBarButtonItem = fabuItem;
    
    
     NSInteger height = IsPhoneX?(88+34+49):(64+49);
    
    mTableView = [[searchTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - height)];
    
    mTableView.backgroundColor = RGBFromHexadecimal(0xf7f5f6);
    
    mTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.view addSubview:mTableView];
    
//    [mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.top.and.right.equalTo(self.view);
//        make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(50);
//    }];

    
    self.tabBarController.tabBar.hidden = NO;
    
    @weakify(self)
    
    [RACObserve(self, bannerList) subscribeNext:^(NSArray *list) {
        
        @strongify(self)
        
        if (list && list.count>0) {
            
            NSMutableArray *banerUrlArray = [NSMutableArray new];
            
            for (MasterShareBannerModel *model in list) {
                
                [banerUrlArray addObject:model.pic_url];
                
                //                [didImgUrl addObject:model.pfurl];
                
            }
            
            self.headView.urls = banerUrlArray;
            
            mTableView.tableHeaderView = self.headView;
            
        }
        
    }];
    
    
    mTableView.NextViewControllerBlock = ^(int tag){
        
        @strongify(self)
        
        self.tableType = tag;
        
        switch (tag) {
                
            case 1:{
                
                self.tableType =1;
                
                break;
            }
            case 2:{
                
                self.tableType =2;
                
                if(mTableView.first2 == NO){
                    
                    NSString* number = [NSString stringWithFormat:@"%ld",(long)self.PageTwo];
                    NSString* type = [NSString stringWithFormat:@"%ld", (long)self.tableType];
                    [self requestSearchViewData:type pageId:number];
                    
                }
                break;
            }
            case 3:{
                
                self.tableType = 3;
                
                if(mTableView.first3 == NO){
                    
                    NSString* number = [NSString stringWithFormat:@"%ld",(long)self.PageThr];
                    NSString* type = [NSString stringWithFormat:@"%ld", (long)self.tableType];
                    [self requestSearchViewData:type pageId:number];
                    
                }
                break;
            }
        }
    };
    
    
    mTableView.mj_header = [MasterTableHeaderView addRefreshGifHeadViewWithRefreshBlock:^{
        mTableView.mtableRfreshId = Headrefresh;
        if(self.tableType ==1){
            self.PageOne =1;
            NSString* number = [NSString stringWithFormat:@"%ld",(long)self.PageOne];
            NSString* type = [NSString stringWithFormat:@"%ld",(long)self.tableType];
            [self requestSearchViewData:type pageId:number];
        }
        
        else if(self.tableType ==2){
            self.PageTwo =1;
            NSString* number = [NSString stringWithFormat:@"%ld",(long)self.PageTwo];
            NSString* type = [NSString stringWithFormat:@"%ld",(long)self.tableType];
            [self requestSearchViewData:type pageId:number];
        }
        else if(self.tableType ==3){
            self.PageThr =1;
            NSString* number = [NSString stringWithFormat:@"%ld",(long)self.PageThr];
            NSString* type = [NSString stringWithFormat:@"%ld",(long)self.tableType];
            [self requestSearchViewData:type pageId:number];
        }
        
    }];
    
    mTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        mTableView.mtableRfreshId = Footrefresh;
        
        if(self.tableType ==1){
            NSString* number = [NSString stringWithFormat:@"%ld",(long)self.PageOne];
            NSString* type = [NSString stringWithFormat:@"%ld",(long)self.tableType];
            [self requestSearchViewData:type pageId:number];
        }
        else if(self.tableType ==2){
            NSString* number = [NSString stringWithFormat:@"%ld",(long)self.PageTwo];
            NSString* type = [NSString stringWithFormat:@"%ld",(long)self.tableType];
            [self requestSearchViewData:type pageId:number];
        }
        else if(self.tableType ==3){
            NSString* number = [NSString stringWithFormat:@"%ld",(long)self.PageThr];
            NSString* type = [NSString stringWithFormat:@"%ld",(long)self.tableType];
            [self requestSearchViewData:type pageId:number];
        }
    }];
    
    self.userID= self.userClient.userId;
    
    _city =  [UserClient sharedUserClient].city_name;
    
    if(self.userClient.rawLogin){
        
        self.userID= self.userClient.userId;
        
    }else{
        
        self.userID= self.userClient.userId=@"0";
        
    }
    
    [self requestSearchViewData:@"1" pageId:@"1"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieve:)name:@"recieve@url" object:nil];
    mTableView.estimatedRowHeight = 0;
    mTableView.estimatedSectionFooterHeight = 0;
    mTableView.estimatedSectionHeaderHeight = 0;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tabBarController.tabBar setHidden:NO];
    
    appdelegate.baseVC = self;
    
    self.navigationController.navigationBarHidden = NO;
    //变化城市和用户切换
    if(![self.userID isEqualToString:self.userClient.userId]||![_city isEqualToString:[UserClient sharedUserClient].city_name]){
        
        self.userID = self.userClient.userId;
        
        _city = [UserClient sharedUserClient].city_name;
        
        mTableView.mtableRfreshId = Headrefresh;
        
        mTableView.first2 = NO;
        
        mTableView.first3 = NO;
        
        self.tableType = 1;
        
        self.PageOne = 1;
        
        self.PageTwo = 1;
        
        self.PageThr = 1;
        
        mTableView.currentTag = 1;
        
        mTableView.yy = self.lineX/2-15;
        
        mTableView.mostHostBtn.backgroundColor =RGBFromHexadecimal(0xFEDF1F);
        mTableView.newestBtn.backgroundColor =RGBFromHexadecimal(0xD4D4D4);
        mTableView.guanzhuBtn.backgroundColor =RGBFromHexadecimal(0xD4D4D4);
        
        [self requestSearchViewData:@"1" pageId:@"1"];
        
        [mTableView setContentOffset:CGPointMake(0,0) animated:NO];
       
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self.tabBarController.tabBar setHidden:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.tabBarController.tabBar setHidden:YES] ;
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ——— event response


- (void)refresCommentView:(NSNotification *)noti {
    
    NSDictionary *sendmessageData = noti.userInfo[@"sendMessageData"];
    
    mTableView.sendMessageModel = sendmessageData;
    
    mTableView.indexRow = noti.userInfo[@"indexRow"];
    
    [mTableView addCommentWithSendMessage:sendmessageData indexRow:noti.userInfo[@"indexRow"]];
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:[noti.userInfo[@"indexRow"] integerValue] inSection:1];
    
    [mTableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationRight];
    
    [mTableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)refreshNewView{
    
    [mTableView.mj_header beginRefreshing];
    
    mTableView.mtableRfreshId = Headrefresh;
    
    mTableView.first2 = NO;
    
    mTableView.first3 = NO;
    
    self.tableType = 1;
    
    self.PageOne = 1;
    
    self.PageTwo= 1;
    
    self.PageThr =1;
    
    mTableView.currentTag = 1;
    
    mTableView.yy = self.lineX/2-15;
    
    mTableView.mostHostBtn.backgroundColor = RGBFromHexadecimal(0xFEDF1F);
    
    mTableView.newestBtn.backgroundColor = RGBFromHexadecimal(0xD4D4D4);
    
    mTableView.guanzhuBtn.backgroundColor = RGBFromHexadecimal(0xD4D4D4);
    
    [self requestSearchViewData:@"1" pageId:@"1"];

    
}

#pragma mark ——— private methods

//network request
- (void)requestSearchViewData:(NSString*)page pageId:(NSString*)pageId{
    
    @weakify(self)
    
//    [self showHUDWithString:@"加载中"];
    
    RACSignal *fetchSignal = [[HttpManagerCenter sharedHttpManager] RequestForSearchData:page page:pageId page_size:@"10" resultClass:[MasterSearchListModel class]];
    
    [fetchSignal subscribeNext:^(BaseModel *model) {
        
        @strongify(self)
        
        if (model.code==200) {
            
            NSLog(@"%@" ,model.data);
            self.masterShareList = model.data;
            self.bannerList = self.masterShareList.banner_list;
            self.sharelist = self.masterShareList.share_list;
            
            if(self.tableType==1){
                
                if(self.masterShareList.share_list.count>0){
                    
                    mTableView.shareTableList = self.masterShareList;
                    
                    self.PageOne+=1;
                    
                }
                
            }else if(self.tableType ==2){
                
                if(self.masterShareList.share_list.count>0){
                    
                    mTableView.shareTableList2 = self.masterShareList;
                    
                    self.PageTwo+=1;
                    
                }
                
            }else if(self.tableType ==3){
                
                if(self.masterShareList.share_list.count>0){
                    
                    mTableView.shareTableList3 = self.masterShareList;
                    
                    self.PageThr+=1;
                    
                }
                
            }
            
        }else{
            [self showHUDWithString:@"请检查网络"];
        }
    } completed:^{
        NSLog(@"11***");
        [self hiddenHUD];
        mTableView.mtableRfreshId= 3;
        if(mTableView.mj_footer.isRefreshing){
            
            [mTableView.mj_footer endRefreshing];
            
        }
        
        if(mTableView.mj_header.isRefreshing){
            
            [mTableView.mj_header endRefreshing];
        }
        
        if(mTableView.btnChanged ==YES&&mTableView.isOnTop ==YES){
            NSIndexPath *localIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [mTableView scrollToRowAtIndexPath:localIndexPath atScrollPosition:UITableViewScrollPositionTop
                                      animated:NO];
        }
        mTableView.btnChanged =NO;
    }];
}

- (LoopScrollView*)headView{
    if (!_headView) {
        _headView = [[LoopScrollView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 190)];
        _headView.isAutoScroll = YES;
        _headView.delegate = self;
    }
    return _headView;
}

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIViewController *vct = [UIStoryboard viewController:@"MasterShare" identifier:@"MasterShareSearchViewController"];
    [self pushViewController:vct animated:YES];
    return NO;
}

- (void)circleView:(LoopScrollView *)view didSelectedIndex:(NSInteger)index{
    if(self.bannerList.count>0){
        MasterShareBannerModel *model = self.bannerList[index];
        if ([model.is_login integerValue]==1 && !self.userClient.rawLogin) {
            [self doLogin];
        }else{
            
            //广告位统计
            RACSignal * singal = [[HttpManagerCenter sharedHttpManager]totalAds_data_id:model.ads_data_id index:[NSString stringWithFormat:@"%ld",index] resultClass:nil];
            
            
            [singal subscribeNext:^(BaseModel *model) {
                
                if (model.code == 200) {
                    
                    NSLog(@"%@", model.data);
                }
                
            }];
            
            
            
            [self pushViewControllerWithUrl:model.pfurl];
        }
    }
}


-(void)recieve:(NSNotification*) notification{
    NSArray* array =  [notification object];
    NSURL* urlstr = array[0];
    NSString *str = [urlstr absoluteString];
    [self pushViewControllerWithUrl:str];
}
-(void)dealloc{
     [[NSNotificationCenter  defaultCenter] removeObserver:self  name:@"refreshNewView" object:nil];
     [[NSNotificationCenter  defaultCenter] removeObserver:self  name:@"refresCommentView" object:nil];
    [[NSNotificationCenter  defaultCenter] removeObserver:self  name:@"recieve@url" object:nil];
}

- (void)fabuBtnAction:(UIButton *)btn {
    
            if(![(BaseViewController*)appdelegate.baseVC doLogin]){
    
                return;
            }else{
    
                _menu = [HyPopMenuView sharedPopMenuManager];
    
                if(!self.userClient.isMaster){
    
                    PopMenuModel* model = [PopMenuModel
                                           allocPopMenuModelWithImageNameString:@"短分享-拷贝"
                                           AtTitleString:@"短分享"
                                           AtTextColor:[UIColor whiteColor]
                                           AtTransitionType:PopMenuTransitionTypeSystemApi
                                           AtTransitionRenderingColor:nil];
    
                    PopMenuModel* model1 = [PopMenuModel
                                            allocPopMenuModelWithImageNameString:@"小视频"
                                            AtTitleString:@"小视频"
                                            AtTextColor:[UIColor whiteColor]
                                            AtTransitionType:PopMenuTransitionTypeSystemApi
                                            AtTransitionRenderingColor:nil];
    
                    _menu.dataSource = @[model,model1];
                      _menu.columnNum = 2;
    
                }else{
    
                    PopMenuModel* model = [PopMenuModel
                                           allocPopMenuModelWithImageNameString:@"短分享-拷贝"
                                           AtTitleString:@"短分享"
                                           AtTextColor:[UIColor whiteColor]
                                           AtTransitionType:PopMenuTransitionTypeSystemApi
                                           AtTransitionRenderingColor:nil];
    
                    PopMenuModel* model1 = [PopMenuModel
                                            allocPopMenuModelWithImageNameString:@"长图文"
                                            AtTitleString:@"长图文"
                                            AtTextColor:[UIColor whiteColor]
                                            AtTransitionType:PopMenuTransitionTypeSystemApi
                                            AtTransitionRenderingColor:nil];
    
                    PopMenuModel* model2 = [PopMenuModel
                                            allocPopMenuModelWithImageNameString:@"小视频"
                                            AtTitleString:@"小视频"
                                            AtTextColor:[UIColor whiteColor]
                                            AtTransitionType:PopMenuTransitionTypeSystemApi
                                            AtTransitionRenderingColor:nil];
    
                    _menu.dataSource = @[model,model1,model2];
                    _menu.columnNum = 3;
    
                }
    
                _menu.delegate = self;
    
                _menu.popMenuSpeed = 12.0f;
    
                _menu.automaticIdentificationColor = false;
    
                _menu.animationType = HyPopMenuViewAnimationTypeViscous;
    
                _menu.backgroundType = HyPopMenuViewBackgroundTypeDarkBlur;
    
                [_menu openMenu];
            }
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


- (void)movieClicked{
    
    SelectMovController*vc = [[SelectMovController alloc]init];
    
    [self pushViewController:vc animated:YES];
    
    //    SGRecordViewController*vc = [[SGRecordViewController alloc]init];
    //
    //  BaseNavigationController *  viewController = [[BaseNavigationController alloc] initWithRootViewController:vc];
    //
    //    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)userClicked{
    
    MasterPickerViewController *imagePickerVc = [[MasterPickerViewController alloc] initWithMaxImagesCount:9 delegate:self];
    
    @weakify(self);
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        @strongify(self);
        
        UIViewController *vct = [UIViewController viewControllerWithStoryboard:@"UserShare" identifier:@"AddUserShareVC"];
        
        [vct setValue:photos forKey:@"chosenImages"];
        
        [vct setValue:assets forKey:@"chosenAssets"];
        
        [self pushViewController:vct animated:YES];
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
    
}

-(void)masterClicked{
    
    MasterPickerViewController *imagePickerVc = [[MasterPickerViewController alloc] initWithMaxImagesCount:1 delegate:nil];
    
    
    imagePickerVc.cropRect = CGRectMake(0, ((ScreenHeight - 64 - 44)- ScreenWidth/8*3)/2, ScreenWidth, ScreenWidth/4*3);
    
    @weakify(self);
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        @strongify(self);
        
        UIViewController *vct = [UIViewController viewControllerWithStoryboard:@"MasterShare" identifier:@"MasterShareReleaseViewController"];
        
        [vct setValue:photos forKey:@"imageArray"];
        
        [self pushViewController:vct animated:YES];
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

#pragma mark ——— getter & setter


- (HttpManagerCenter *)httpService
{
    if (!_httpService1) {
        _httpService1  = [HttpManagerCenter sharedHttpManager];
    }
    return _httpService1;
}
@end
