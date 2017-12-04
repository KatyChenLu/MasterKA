//
//  MsgViewController.h
//  MasterKA
//
//  Created by 余伟 on 16/7/6.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseTableViewController.h"

@interface MsgViewController : BaseTableViewController


//注册返回的数据
@property(nonatomic ,strong)id data;


//密码
@property(nonatomic ,copy)NSString * passWord;


//是否是第三方登录
@property(nonatomic ,copy)NSString * thirdLogin;


//第三方登录的昵称
@property(nonatomic ,copy)NSString * thirdName;


//第三方登录方式
@property(nonatomic ,assign)UMSocialPlatformType  thirdMethod;


@end
