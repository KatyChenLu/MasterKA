//
//  MsgTableView.h
//  MasterKA
//
//  Created by 余伟 on 16/7/6.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgTableView : UITableView

@property(nonatomic ,strong)NSArray * hobys;

//注册返回的数据
@property(nonatomic ,strong)id data;

//第三方昵称
@property(nonatomic ,copy)NSString * thirdName;

//第三方登录方式
@property(nonatomic ,assign)UMSocialPlatformType  thirdMethod;


@property(nonatomic , copy)void(^push)();

//存储数据
@property(nonatomic ,strong)NSDictionary * saveData;


@property(nonatomic ,copy)void(^autho)(NSInteger type , NSIndexPath * index);


//
@property(nonatomic ,assign)BOOL * bindStatue;


@end
