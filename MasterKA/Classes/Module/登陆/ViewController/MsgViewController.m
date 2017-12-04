//
//  MsgViewController.m
//  MasterKA
//
//  Created by 余伟 on 16/7/6.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MsgViewController.h"
#import "MsgTableView.h"
#import "HobyCell.h"
#import "BindCell.h"
#import "MsgCell.h"
#import "GenderCell.h"
#import "UserMsgModel.h"

#import "HttpManagerCenter.h"
#import "ReactiveCocoa.h"
#import "UserClient.h"

#import "BindPhoneController.h"

//#import "UMSocial.h"



@interface MsgViewController ()<UITableViewDataSource , UITableViewDelegate>

@end

@implementation MsgViewController


{
    
    MsgTableView * _msgTabelView;
    
    HttpManagerCenter * _httpService;
    
    NSDictionary * _saveData;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"完善信息";
    
    UIBarButtonItem * jumpItem = [[UIBarButtonItem alloc]initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:self action:@selector(jumpItemClick:)];
    
    
    [self.navigationItem setRightBarButtonItem:jumpItem];
    
    _msgTabelView =  [[MsgTableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    [self setBtn];
    
    [self.view addSubview:_msgTabelView];
    

    [_msgTabelView registerClass:[HobyCell class] forCellReuseIdentifier:@"HobyCell"];
   
    
    [_msgTabelView registerClass:[BindCell class] forCellReuseIdentifier:@"BindCell"];

    
    [_msgTabelView registerClass:[MsgCell class] forCellReuseIdentifier:@"MsgCell"];
    
    [_msgTabelView registerClass:[GenderCell class] forCellReuseIdentifier:@"GenderCell"];
    
    _msgTabelView.data = self.data;
    
    _msgTabelView.thirdName = self.thirdName;
    
    _msgTabelView.thirdMethod = self.thirdMethod;
    
    _saveData = _msgTabelView.saveData;
    
    @weakify(self)
    
    [_msgTabelView setAutho:^(NSInteger type , NSIndexPath * index) {
        
       @strongify(self)
        
        [self otherLogin:type];

        
//        BindCell * bindCell = (BindCell *)[_msgTabelView cellForRowAtIndexPath:index];
        
//        bindCell.statueStr = @"已绑定";
        
       
        
    }];
    
    //回调block
    
    __weak typeof(self)weakSlef = self;
    
    [_msgTabelView setPush:^{
        
        
        UIStoryboard * board = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        
        BindPhoneController * bindVc = [board instantiateViewControllerWithIdentifier:@"BindPhoneController"];

        
        bindVc.title = @"绑定手机";
        
        
        [weakSlef.navigationController pushViewController: bindVc animated:YES];
        
    }];
    
    
    [self setBtn];
    
    [self initLocalData];
    
    _httpService = [HttpManagerCenter sharedHttpManager];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bindPhone:) name:@"bindPhone" object:nil];
    
    
}




-(void)initLocalData {
    
    RLMResults * hoby = [CategoryModel allObjects];
    
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:10];
    
    for (CategoryModel * model in hoby) {
        
        
        [arr addObject:model];
        
    }
    
    _msgTabelView.hobys = arr;
    
    
}



-(void)setBtn{
    
    UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    
    saveBtn.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
    
    saveBtn.backgroundColor = MasterDefaultColor;
    
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    saveBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [saveBtn addTarget: self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _msgTabelView.tableFooterView = saveBtn;
    

    
}



//saveBtn

-(void)saveBtnClick:(UIButton *)sender {
    
 
    @weakify(self)
    
    [[_httpService modifilrUserInfo:_saveData resultClass:nil]subscribeNext:^(id x) {
        
        
        @strongify(self);
       
        [self hiddenHUDWithString:@"保存成功" error:NO];
        
    }];
    
    
    
}





//jumpItem
-(void)jumpItemClick:(UIButton *)sender {
    
    UserMsgModel * model = self.data;
    
    
    NSString * phoneNum = model.mobile;
    
    
//    NSString * passWordMD5 = [self.passWord md5HexDigest];
    
    
    
    if (self.thirdLogin != nil) {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [[GCDQueue mainQueue] queueBlock:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:MasterUserLoginNotification object:nil];
                
            } afterDelay:0.5f];
        }];
    }
    
    @weakify(self)
    
    [[_httpService loginByPhone:phoneNum password:self.passWord resultClass:nil] subscribeNext:^(BaseModel *model) {
    
        
        @strongify(self)
        if (model.code==200) {
            [[UserClient sharedUserClient] setUserName:phoneNum password:self.passWord];
            [[UserClient sharedUserClient] setLoginType:MasterLoginType_Phone];
            [[UserClient sharedUserClient] setUserInfo:model.data];
//            [self hiddenHUDWithString:@"登录成功" error:NO];
            
            
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                [[GCDQueue mainQueue] queueBlock:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:MasterUserLoginNotification object:nil];
                    
                } afterDelay:0.5f];
            }];

        }
        
    }];

    
}


#pragma 第三方登录授权
    
-(void)otherLogin:(int)otherTppe{
    
 
    
    UMSocialPlatformType platformName = UMSocialPlatformType_UnKnown;
    if(otherTppe==1){
        
        platformName = UMSocialPlatformType_QQ;
    }
    else if(otherTppe==2)
    {
        platformName= UMSocialPlatformType_WechatSession;
    }
    else if(otherTppe==3){
        
        platformName= UMSocialPlatformType_Sina;
        
    }
    
    if (platformName) {
        
        
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformName currentViewController:nil completion:^(id result, NSError *error) {
            //           获取微博用户名、uid、token、第三方的原始用户信息thirdPlatformUserProfile等
            if (error) {
                
            } else {
                UMSocialUserInfoResponse *resp = result;
             
                [self authoSuccess:resp];
            }
            
        }];
    }
    
      
        
}



-(void)authoSuccess:(UMSocialUserInfoResponse *)input {
    
    @weakify(self)
    
    [[_httpService otherLoginByPlatform:input.platformType uid:input.uid unionId:input.openid nickname:input.name iconUrl:input.iconurl gender:input.gender resultClass:nil] subscribeNext:^(BaseModel *model) {
        @strongify(self)
        if (model.code==200) {
            [[UserClient sharedUserClient] setLoginTypeName:input.platformType];
            [[UserClient sharedUserClient] setUserInfo:model.data];
            [self hiddenHUDWithString:@"授权成功" error:NO];
            
            NSDictionary * dic = model.data;
            
            //第一次登入
            if ([dic[@"is_first"] isEqualToString:@"1"]) {
            
                
                self.thirdLogin = @"1";
                
                self.thirdName = input.name;
                
                self.thirdMethod = input.platformType;
                
                _msgTabelView.thirdMethod  = input.platformType;
                
            }
            
            [_msgTabelView reloadData];
        }
    
    }];
    
}

-(void)bindPhone: (NSNotification *)notify {
    
    
    NSIndexPath * index  = [NSIndexPath indexPathForItem:0 inSection:2];
    
    UserMsgModel * model = [[UserMsgModel alloc]init];
    
    model.mobile = notify.object;
    
    _msgTabelView.data =  model;
    
    [_msgTabelView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    
    
    
}


-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"bindPhone" object:nil];
  
    
}


@end
